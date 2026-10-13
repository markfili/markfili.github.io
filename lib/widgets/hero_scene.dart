import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// One silhouette of hills, drawn as a filled path anchored to the bottom
/// edge of the canvas.
///
/// The profile is a fixed sum of waves seeded by [seed], so the same ridge
/// renders identically on every load and at every size.
class Ridge {
  /// Seed for the phases of the profile.
  final int seed;

  /// Average elevation as a fraction of the canvas height, measured from the
  /// top (0 is the top edge, 1 is the bottom edge).
  final double horizon;

  /// How far above and below [horizon] the profile may swing, as a fraction
  /// of the canvas height.
  final double amplitude;

  /// 0 gives a clean edge, 1 adds a fine jagged treeline.
  final double roughness;

  /// Sharp mountain peaks instead of rolling hills.
  final bool peaked;

  /// Fill color at the crest of the ridge.
  final Color top;

  /// Fill color at the bottom edge of the canvas.
  final Color bottom;

  const Ridge({
    required this.seed,
    required this.horizon,
    required this.amplitude,
    required this.top,
    required this.bottom,
    this.roughness = 0,
    this.peaked = false,
  });

  // Octave weights sum to 1 so the profile never leaves the amplitude band.
  // The last octave is the treeline and is scaled by [roughness].
  static const _weights = [0.42, 0.22, 0.12, 0.06, 0.18];

  // Cycles per canvas height, so wide screens show more peaks rather than
  // stretched ones.
  static const _frequencies = [0.55, 1.3, 2.9, 6.1, 90.0];

  double _phase(int octave) {
    // Tiny integer hash; enough to make seeds look unrelated.
    var h = seed * 374761393 + octave * 668265263;
    h = (h ^ (h >> 13)) * 1274126177;
    h = h ^ (h >> 16);
    return (h & 0xffff) / 0xffff * 2 * math.pi;
  }

  /// Elevation at [t] (horizontal position in canvas heights) as a fraction
  /// of the canvas height from the top. Always within `horizon ± amplitude`.
  double elevationAt(double t) {
    var sum = 0.0;
    final last = _weights.length - 1;
    for (var i = 0; i < _weights.length; i++) {
      final x = t * _frequencies[i] * 2 * math.pi + _phase(i);
      final double wave;
      if (i == last) {
        wave = roughness * _triangle(x);
      } else if (peaked && i < 2) {
        wave = _ridged(x);
      } else {
        wave = math.sin(x);
      }
      sum += _weights[i] * wave;
    }
    return horizon + amplitude * sum;
  }

  /// Triangle wave in [-1, 1].
  static double _triangle(double x) {
    final p = (x / (2 * math.pi)) % 1.0;
    return 4 * (p - 0.5).abs() - 1;
  }

  /// Rectified sine in [-1, 1]; its sharp minima become peaks on screen.
  static double _ridged(double x) => 2 * math.sin(x).abs() - 1;

  /// The filled silhouette for a canvas of [size].
  Path path(Size size) {
    final steps = math.max(32, (size.width / 2).round());
    final path = Path()..moveTo(0, size.height);
    for (var i = 0; i <= steps; i++) {
      final x = i / steps * size.width;
      path.lineTo(x, elevationAt(x / size.height) * size.height);
    }
    path
      ..lineTo(size.width, size.height)
      ..close();
    return path;
  }
}

/// Full-screen backdrop: a dark sky with a warm glow on the horizon, layered
/// misty ridges along the bottom, and a film-grain overlay.
class HeroScene extends StatefulWidget {
  /// Asset key of the grain shader. When it cannot be loaded the scene
  /// renders without grain.
  final String grainShader;

  const HeroScene({this.grainShader = 'shaders/grain.frag', Key? key})
      : super(key: key);

  static const skyTop = Color(0xFF07070A);
  static const skyBottom = Color(0xFF1B1517);
  static const glow = Color(0xFF8A4232);
  static const mist = Color(0xFFC9BCBE);

  /// Text color over the scene.
  static const ink = Color(0xE6FFFFFF);

  /// Secondary text color over the scene.
  static const inkSoft = Color(0x99FFFFFF);

  static const ridges = [
    // Far peaks catching the light, dissolving into haze at their base.
    Ridge(
      seed: 11,
      horizon: 0.73,
      amplitude: 0.12,
      peaked: true,
      top: Color(0xFFB0695A),
      bottom: Color(0xFF6A5A5E),
    ),
    Ridge(
      seed: 23,
      horizon: 0.79,
      amplitude: 0.08,
      peaked: true,
      top: Color(0xFF7D4D47),
      bottom: Color(0xFF55484D),
    ),
    // Forested hills in front.
    Ridge(
      seed: 37,
      horizon: 0.86,
      amplitude: 0.05,
      roughness: 0.6,
      top: Color(0xFF3B4555),
      bottom: Color(0xFF232A34),
    ),
    Ridge(
      seed: 41,
      horizon: 0.91,
      amplitude: 0.04,
      roughness: 0.9,
      top: Color(0xFF252D39),
      bottom: Color(0xFF151A21),
    ),
    Ridge(
      seed: 53,
      horizon: 0.96,
      amplitude: 0.03,
      roughness: 1,
      top: Color(0xFF151B23),
      bottom: Color(0xFF07090C),
    ),
  ];

  @override
  State<HeroScene> createState() => _HeroSceneState();
}

class _HeroSceneState extends State<HeroScene> {
  ui.FragmentShader? _grain;

  @override
  void initState() {
    super.initState();
    _loadGrain();
  }

  Future<void> _loadGrain() async {
    try {
      final program = await ui.FragmentProgram.fromAsset(widget.grainShader);
      if (!mounted) return;
      setState(() => _grain = program.fragmentShader());
    } on Object catch (_) {
      // No grain is better than no page.
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _ScenePainter(grain: _grain),
        size: Size.infinite,
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  final ui.FragmentShader? grain;

  const _ScenePainter({this.grain});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    _paintSky(canvas, rect);
    final ridges = HeroScene.ridges;
    for (final ridge in ridges.where((r) => r.peaked)) {
      _paintRidge(canvas, size, ridge);
    }
    _paintValleyHaze(canvas, size, ridges);
    for (final ridge in ridges.where((r) => !r.peaked)) {
      _paintRidge(canvas, size, ridge);
    }
    _paintGrain(canvas, rect);
  }

  void _paintSky(Canvas canvas, Rect rect) {
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [HeroScene.skyTop, HeroScene.skyBottom],
        ).createShader(rect),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, 0.5),
          radius: 0.85,
          colors: [
            HeroScene.glow.withValues(alpha: 0.5),
            HeroScene.glow.withValues(alpha: 0),
          ],
        ).createShader(rect),
    );
  }

  /// Haze pooled in the valley where the peaks meet the forest. Clipped to
  /// the farthest ridge so it never bleeds into the sky.
  void _paintValleyHaze(Canvas canvas, Size size, List<Ridge> ridges) {
    final forest = ridges.firstWhere((r) => !r.peaked);
    final crest = (forest.horizon - forest.amplitude) * size.height;
    final band = Rect.fromLTRB(
      0,
      crest - size.height * 0.12,
      size.width,
      crest + size.height * 0.06,
    );
    canvas
      ..save()
      ..clipPath(ridges.first.path(size))
      ..drawRect(
        band,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              HeroScene.mist.withValues(alpha: 0),
              HeroScene.mist.withValues(alpha: 0.28),
            ],
          ).createShader(band),
      )
      ..restore();
  }

  void _paintRidge(Canvas canvas, Size size, Ridge ridge) {
    final path = ridge.path(size);
    final bounds = path.getBounds();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ridge.top, ridge.bottom],
        ).createShader(bounds),
    );
  }

  void _paintGrain(Canvas canvas, Rect rect) {
    final shader = grain;
    if (shader == null) return;
    shader.setFloat(0, 0.07);
    canvas.drawRect(rect, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_ScenePainter oldDelegate) => oldDelegate.grain != grain;
}
