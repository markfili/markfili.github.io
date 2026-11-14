import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/main.dart';
import 'package:showcase/utils/widgets.dart';
import 'package:showcase/widgets/menu_layout.dart';

import 'test_utils.dart';

const desktop = Size(1440, 900);
const phone = Size(390, 844);

Future<List<Offset>> pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MyApp());
  await settleFonts(tester);
  return tester
      .widgetList(find.byType(ContactBadge))
      .map((w) => tester.getCenter(find.byWidget(w)))
      .toList();
}

void main() {
  group('MenuLayout', () {
    test('switches to orbit on narrow or short screens', () {
      expect(MenuLayout.useOrbit(desktop), isFalse);
      expect(MenuLayout.useOrbit(phone), isTrue);
      expect(MenuLayout.useOrbit(const Size(1200, 480)), isTrue);
    });

    test('needs more width before perching more bubbles', () {
      const laptop = Size(1024, 768);
      expect(MenuLayout.useOrbit(laptop), isFalse);
      expect(MenuLayout.useOrbit(laptop, count: 6), isTrue);
      expect(MenuLayout.useOrbit(const Size(1280, 800), count: 6), isTrue);
      expect(MenuLayout.useOrbit(const Size(1440, 900), count: 6), isFalse);
    });

    test('six perched bubbles never crowd each other at any desktop width', () {
      for (var w = 1350.0; w <= 2560; w += 20) {
        final size = Size(w, math.max(600, w * 0.6));
        final xs = MenuLayout.peakAnchors(size, count: 6).map((a) => a.dx);
        final sorted = xs.toList()..sort();
        for (var i = 1; i < sorted.length; i++) {
          expect(
            sorted[i] - sorted[i - 1],
            greaterThanOrEqualTo(80),
            reason: '$size: bubbles ${i - 1} and $i are crowded',
          );
        }
      }
    });

    test('peak anchors sit just above the skyline, left to right', () {
      for (final size in [
        desktop,
        const Size(1366, 768),
        const Size(1920, 1080),
        const Size(2560, 1300),
      ]) {
        final anchors = MenuLayout.peakAnchors(size, count: 6);
        expect(anchors, hasLength(6));
        for (var i = 0; i < anchors.length; i++) {
          final a = anchors[i];
          final ground = MenuLayout.skylineAt(a.dx, size);
          expect(
            a.dy + MenuLayout.bubbleRadius + MenuLayout.perchGap,
            closeTo(ground, 0.01),
          );
          final bubble = Rect.fromCircle(
            center: a,
            radius: MenuLayout.bubbleRadius,
          );
          expect(
            bubble.overlaps(MenuLayout.brandRect(size)),
            isFalse,
            reason: '$size: bubble $i covers the brand',
          );
          if (i > 0) {
            expect(
              a.dx - anchors[i - 1].dx,
              greaterThanOrEqualTo(2 * MenuLayout.bubbleRadius),
              reason: '$size: bubbles $i-1 and $i overlap',
            );
          }
        }
      }
    });

    test('peak anchors are local summits of the skyline', () {
      for (final a in MenuLayout.peakAnchors(desktop, count: 6)) {
        final here = MenuLayout.skylineAt(a.dx, desktop);
        // Neither neighbour is higher (smaller y) by more than a pixel.
        expect(MenuLayout.skylineAt(a.dx - 6, desktop), greaterThan(here - 1));
        expect(MenuLayout.skylineAt(a.dx + 6, desktop), greaterThan(here - 1));
      }
    });

    for (final count in [4, 6]) {
      test('$count orbit anchors are evenly spaced, none straight above or '
          'below the logo', () {
        const c = Offset(200, 300);
        final anchors = MenuLayout.orbitAnchors(c, count: count);
        expect(anchors, hasLength(count));
        final chord = 2 * MenuLayout.orbitRadius * math.sin(math.pi / count);
        for (var i = 0; i < count; i++) {
          final a = anchors[i];
          expect((a - c).distance, closeTo(MenuLayout.orbitRadius, 0.001));
          expect((anchors[(i + 1) % count] - a).distance, closeTo(chord, 0.01));
          expect((a.dx - c.dx).abs(), greaterThan(MenuLayout.bubbleRadius));
        }
        // Starts upper left and goes clockwise.
        expect(anchors.first.dx, lessThan(c.dx));
        expect(anchors.first.dy, lessThan(c.dy));
        expect(anchors[1].dx, greaterThan(anchors.first.dx));
      });
    }
  });

  testWidgets('desktop perches one bubble on each mountain', (tester) async {
    final centers = await pumpAt(tester, desktop);
    final expected = MenuLayout.peakAnchors(desktop, count: 6);
    for (var i = 0; i < 6; i++) {
      expect((centers[i] - expected[i]).distance, lessThan(0.5));
    }
  });

  testWidgets('phone circles the bubbles around the logo', (tester) async {
    final centers = await pumpAt(tester, phone);
    final logo = tester.getCenter(find.byType(Image));
    for (final c in centers) {
      expect((c - logo).distance, closeTo(MenuLayout.orbitRadius, 0.5));
    }
    // The wordmark sits below the ring.
    expect(
      tester.getTopLeft(find.text('arilus')).dy,
      greaterThan(logo.dy + MenuLayout.orbitRadius + MenuLayout.bubbleRadius),
    );
  });
}
