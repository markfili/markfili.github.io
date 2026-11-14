import 'dart:math' as math;

import 'package:flutter/painting.dart';

import 'hero_scene.dart';

/// Where the round menu bubbles sit on the home page.
///
/// Wide screens perch one bubble on a mountain summit each; narrow or short
/// screens gather them in a circle around the logo.
class MenuLayout {
  /// Bubble radius ([ContactBadge] is a default [CircleAvatar]).
  static const bubbleRadius = 20.0;

  /// Gap between a bubble and the summit it sits on.
  static const perchGap = 6.0;

  /// Logo is 88×88.
  static const logoRadius = 44.0;

  /// Distance from the logo center to each bubble center in orbit mode.
  static const orbitRadius = 84.0;

  /// Horizontal half-width around the screen center used by the fallback
  /// placement when a side has too few summits clear of the brand.
  static const clearCenter = 170.0;

  /// Half-width and height of the "arilus" wordmark (56px DM Mono Light).
  static const wordmarkHalfWidth = 100.0;
  static const wordmarkHeight = 72.0;

  /// Area covered by the logo and wordmark in peak mode, plus breathing room.
  /// Bubbles never overlap it.
  static Rect brandRect(Size size) {
    final c = logoCenter(size, orbit: false);
    return Rect.fromLTRB(
      c.dx - wordmarkHalfWidth,
      c.dy - logoRadius,
      c.dx + wordmarkHalfWidth,
      wordmarkTop(size, orbit: false) + wordmarkHeight,
    ).inflate(12);
  }

  /// Below this height, or [widthPerPeakBubble] per bubble (and never below
  /// [minPeakWidth]), there is not enough ridge for one summit per bubble.
  static const minPeakWidth = 760.0;
  static const minPeakHeight = 520.0;
  static const widthPerPeakBubble = 225.0;

  static bool useOrbit(Size size, {int count = 4}) =>
      size.width < math.max(minPeakWidth, count * widthPerPeakBubble) ||
      size.height < minPeakHeight;

  /// Height of the visible mountain skyline (topmost ridge) at [x], in
  /// pixels from the top of a canvas of [size].
  static double skylineAt(
    double x,
    Size size, {
    List<Ridge> ridges = HeroScene.ridges,
  }) {
    final t = x / size.height;
    var top = double.infinity;
    for (final ridge in ridges) {
      top = math.min(top, ridge.elevationAt(t));
    }
    return top * size.height;
  }

  /// Bubble centers perched on [count] summits, ordered left to right.
  ///
  /// Takes the highest prominent summits across the whole skyline that keep
  /// a bubble clear of the brand and well apart from the others. If the
  /// skyline has too few, falls back to equal slots outside a central clear
  /// zone (half on each side), each taking its highest point.
  static List<Offset> peakAnchors(
    Size size, {
    int count = 4,
    List<Ridge> ridges = HeroScene.ridges,
    double margin = 24,
  }) {
    final pad = bubbleRadius + perchGap;
    var xs = _highestSummits(
      margin + pad,
      size.width - margin - pad,
      count,
      size,
      ridges,
      brandRect(size),
    );
    if (xs.length < count) xs = _slotted(size, count, ridges, margin);
    return [
      for (final x in xs) Offset(x, skylineAt(x, size, ridges: ridges) - pad),
    ];
  }

  static List<double> _slotted(
    Size size,
    int count,
    List<Ridge> ridges,
    double margin,
  ) {
    assert(count.isEven);
    final cx = size.width / 2;
    final pad = bubbleRadius + perchGap;
    final perSide = count ~/ 2;
    return [
      for (final side in [
        [margin, cx - clearCenter],
        [cx + clearCenter, size.width - margin],
      ])
        for (var i = 0; i < perSide; i++)
          _summitIn(
            side[0] + i * (side[1] - side[0]) / perSide + pad,
            side[0] + (i + 1) * (side[1] - side[0]) / perSide - pad,
            size,
            ridges,
          ),
    ];
  }

  /// Up to [count] x positions of the highest local summits between [from]
  /// and [to], sorted left to right. A summit counts only if the skyline
  /// drops by a visible amount on both sides of it, and its bubble stays
  /// clear of [avoid]; picked summits are at least a fair share of the
  /// range apart.
  static List<double> _highestSummits(
    double from,
    double to,
    int count,
    Size size,
    List<Ridge> ridges,
    Rect avoid,
  ) {
    if (to <= from) return const [];
    const step = 2.0;
    final minDrop = size.height * 0.015;
    final window = size.width * 0.06;
    final summits = <Offset>[];
    var prevY = skylineAt(from, size, ridges: ridges);
    var rising = false;
    for (var x = from + step; x <= to; x += step) {
      final y = skylineAt(x, size, ridges: ridges);
      if (rising && y > prevY) {
        final peak = Offset(x - step, prevY);
        final bubble = Rect.fromCircle(
          center: peak.translate(0, -bubbleRadius - perchGap),
          radius: bubbleRadius,
        );
        if (!bubble.overlaps(avoid) &&
            _drop(peak, -window, size, ridges) >= minDrop &&
            _drop(peak, window, size, ridges) >= minDrop) {
          summits.add(peak);
        }
      }
      rising = y < prevY;
      prevY = y;
    }
    summits.sort((a, b) => a.dy.compareTo(b.dy));
    final minGap = math.max(
      2 * bubbleRadius + 2 * perchGap,
      (to - from) / (count * 1.8),
    );
    final picked = <double>[];
    for (final s in summits) {
      if (picked.length == count) break;
      if (picked.every((x) => (x - s.dx).abs() >= minGap)) picked.add(s.dx);
    }
    return picked..sort();
  }

  /// How far the skyline falls below [peak] within [span] pixels to one
  /// side (negative [span] looks left).
  static double _drop(Offset peak, double span, Size size, List<Ridge> ridges) {
    var lowest = peak.dy;
    for (var i = 1; i <= 12; i++) {
      final y = skylineAt(peak.dx + span * i / 12, size, ridges: ridges);
      lowest = math.max(lowest, y);
    }
    return lowest - peak.dy;
  }

  /// The highest local summit between [from] and [to]; when the skyline only
  /// rises or falls there, the highest point of the range.
  static double _summitIn(
    double from,
    double to,
    Size size,
    List<Ridge> ridges,
  ) {
    if (to <= from) return (from + to) / 2;
    const step = 2.0;
    double? bestPeak, bestPeakY;
    var bestX = from;
    var bestY = skylineAt(from, size, ridges: ridges);
    var prevY = bestY;
    var rising = false;
    for (var x = from + step; x <= to; x += step) {
      final y = skylineAt(x, size, ridges: ridges);
      // Screen y grows downwards: a summit is where y stops decreasing.
      if (rising && y > prevY && (bestPeakY == null || prevY < bestPeakY)) {
        bestPeak = x - step;
        bestPeakY = prevY;
      }
      rising = y < prevY;
      if (y < bestY) {
        bestX = x;
        bestY = y;
      }
      prevY = y;
    }
    return bestPeak ?? bestX;
  }

  /// Logo center: just above the middle of the screen, a little higher in
  /// orbit mode to leave room for the ring and the wordmark below it.
  static Offset logoCenter(Size size, {required bool orbit}) =>
      Offset(size.width / 2, size.height / 2 - (orbit ? 70 : 35));

  /// [count] bubble centers evenly spaced on a circle around [center],
  /// clockwise from the upper left, offset by half a step so no bubble sits
  /// straight above or below the logo.
  static List<Offset> orbitAnchors(Offset center, {int count = 4}) {
    final start = -math.pi / 2 - math.pi / count;
    return List.generate(count, (i) {
      final a = start + i * 2 * math.pi / count;
      return center + Offset(math.cos(a), math.sin(a)) * orbitRadius;
    });
  }

  /// Top of the wordmark under the logo.
  static double wordmarkTop(Size size, {required bool orbit}) {
    final c = logoCenter(size, orbit: orbit);
    return orbit ? c.dy + orbitRadius + bubbleRadius + 12 : c.dy + logoRadius;
  }
}
