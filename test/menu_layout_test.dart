import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/main.dart';
import 'package:showcase/utils/widgets.dart';
import 'package:showcase/widgets/hero_scene.dart';
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

  test('orbitLabelSide puts labels above the top bubbles, below the rest', () {
    expect(MenuLayout.orbitLabelSide(0, count: 6), Alignment.topCenter);
    expect(MenuLayout.orbitLabelSide(1, count: 6), Alignment.topCenter);
    expect(MenuLayout.orbitLabelSide(2, count: 6), Alignment.bottomCenter);
    expect(MenuLayout.orbitLabelSide(3, count: 6), Alignment.bottomCenter);
    expect(MenuLayout.orbitLabelSide(5, count: 6), Alignment.bottomCenter);
  });

  const names = ['LinkedIn', 'GitHub', 'Modernise', 'Stack', 'Work', 'AI'];

  for (final size in const [desktop, phone, Size(360, 640)]) {
    testWidgets('every label is visible and on screen at $size', (
      tester,
    ) async {
      await pumpAt(tester, size);
      for (final name in names) {
        expect(find.text(name), findsOneWidget, reason: name);
        final rect = tester.getRect(find.text(name));
        expect(
          Offset.zero & size,
          predicate<Rect>(
            (r) => r.contains(rect.topLeft) && r.contains(rect.bottomRight),
          ),
          reason: '$name at $rect',
        );
      }
    });
  }

  for (final size in const [desktop, Size(1440, 900), Size(1920, 1080)]) {
    testWidgets('peak labels sit in the sky at $size', (tester) async {
      await pumpAt(tester, size);
      for (final name in names) {
        final rect = tester.getRect(find.text(name));
        for (final x in [rect.left, rect.center.dx, rect.right]) {
          expect(
            rect.bottom,
            lessThan(MenuLayout.skylineAt(x, size)),
            reason: '$name at x=$x',
          );
        }
      }
    });
  }

  for (final size in const [phone, Size(360, 640)]) {
    testWidgets('orbit labels clear the wordmark at $size', (tester) async {
      await pumpAt(tester, size);
      final top = tester.getTopLeft(find.text('arilus')).dy;
      for (final name in names) {
        expect(
          tester.getRect(find.text(name)).bottom,
          lessThanOrEqualTo(top - 4),
          reason: name,
        );
      }
    });
  }

  for (final size in const [desktop, Size(1366, 768), Size(1920, 1080)]) {
    testWidgets('perched bubbles stay clear of the footer at $size', (
      tester,
    ) async {
      final centers = await pumpAt(tester, size);
      final footerTop = tester.getRect(find.byKey(MyHomePage.footerKey)).top;
      for (final c in centers) {
        expect(
          c.dy + MenuLayout.bubbleRadius,
          lessThanOrEqualTo(footerTop - 8),
          reason: 'bubble at $c',
        );
      }
    });
  }

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

  for (final size in const [phone, Size(360, 640), Size(1280, 720)]) {
    testWidgets('orbit brand clears the footer at $size', (tester) async {
      await pumpAt(tester, size);
      final wordmark = tester.getRect(find.text('arilus'));
      final footer = tester.getRect(find.byKey(MyHomePage.footerKey));
      final logo = tester.getRect(find.byType(Image).first);
      expect(footer.top, greaterThanOrEqualTo(wordmark.bottom + 8));
      expect(logo.top, greaterThanOrEqualTo(MenuLayout.bubbleRadius * 2));
    });
  }

  testWidgets('a landscape phone scrolls instead of overlapping', (
    tester,
  ) async {
    await pumpAt(tester, const Size(844, 390));
    final wordmark = tester.getRect(find.text('arilus'));
    final footer = tester.getRect(find.byKey(MyHomePage.footerKey));
    expect(footer.top, greaterThanOrEqualTo(wordmark.bottom + 8));
  });

  for (final size in const [
    Size(390, 844),
    Size(360, 640),
    Size(412, 915),
    Size(601, 800),
    Size(844, 390),
    Size(1280, 720),
  ]) {
    testWidgets('footer fits its reserve at $size', (tester) async {
      await pumpAt(tester, size);
      expect(
        tester.getSize(find.byKey(MyHomePage.footerKey)).height,
        lessThanOrEqualTo(MenuLayout.footerReserve(size)),
        reason: '$size',
      );
    });
  }

  for (final size in const [
    Size(320, 568),
    Size(360, 640),
    Size(390, 844),
    Size(1024, 768),
    Size(1440, 900),
  ]) {
    testWidgets('every bubble is a 48px target with its label on screen '
        'at $size', (tester) async {
      await pumpAt(tester, size);
      for (final button
          in find
              .descendant(
                of: find.byType(ContactBadge),
                matching: find.byType(IconButton),
              )
              .evaluate()) {
        expect(
          tester.getSize(find.byWidget(button.widget)),
          const Size(48, 48),
        );
      }
      for (final badge in tester.widgetList<ContactBadge>(
        find.byType(ContactBadge),
      )) {
        final label = tester.getRect(
          find.descendant(
            of: find.byWidget(badge),
            matching: find.text(badge.label),
          ),
        );
        expect(label.left, greaterThanOrEqualTo(0), reason: badge.label);
        expect(label.right, lessThanOrEqualTo(size.width), reason: badge.label);
      }
    });

    testWidgets('role and legal lines never end on a "·" at $size', (
      tester,
    ) async {
      await pumpAt(tester, size);
      // It only breaks where Profile.twoLines puts a newline, never by
      // wrapping, which could end a line on a "·".
      for (final start in ['Senior', 'obrt']) {
        final finder = find.byWidgetPredicate(
          (w) => w is Text && (w.data?.startsWith(start) ?? false),
        );
        final role = tester.widget<Text>(finder);
        final paragraph = tester.renderObject<RenderParagraph>(
          find.descendant(of: finder, matching: find.byType(RichText)),
        );
        final line = TextPainter(
          text: TextSpan(text: 'X', style: paragraph.text.style),
          textDirection: TextDirection.ltr,
          textScaler: paragraph.textScaler,
        )..layout();
        expect(
          (paragraph.size.height / line.height).round(),
          role.data!.split('\n').length,
          reason: role.data,
        );
        line.dispose();
      }
    });
  }

  test('footer text meets 4.5:1 over the mist', () {
    final bg = Color.alphaBlend(MyHomePage.footerScrim, HeroScene.mist);
    for (final ink in [HeroScene.ink, HeroScene.inkSoft]) {
      final l1 = Color.alphaBlend(ink, bg).computeLuminance();
      final l2 = bg.computeLuminance();
      final ratio = (math.max(l1, l2) + 0.05) / (math.min(l1, l2) + 0.05);
      expect(ratio, greaterThanOrEqualTo(4.5), reason: '$ink');
    }
  });

  for (final size in const [desktop, phone]) {
    testWidgets('every label fits its slot at $size', (tester) async {
      await pumpAt(tester, size);
      for (final name in names) {
        expect(
          tester.getSize(find.text(name)).width,
          lessThanOrEqualTo(ContactBadge.labelSlot.width),
          reason: name,
        );
      }
    });
  }
}
