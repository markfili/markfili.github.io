import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:showcase/data/profile.dart';
import 'package:showcase/main.dart';
import 'package:showcase/utils/widgets.dart';
import 'package:showcase/widgets/menu_layout.dart';
import 'package:showcase/widgets/offer_ticker.dart';

import 'test_utils.dart';

Future<void> pumpTicker(
  WidgetTester tester, {
  bool wide = true,
  bool reduceMotion = false,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduceMotion),
        child: Scaffold(
          body: Center(child: OfferTicker(wide: wide)),
        ),
      ),
    ),
  );
}

void main() {
  test('offers read as one sentence for screen readers', () {
    expect(
      Profile.offersSentence,
      'I modernise legacy Django apps, Python 2 code bases, dated front ends '
      'and apps nobody wants to touch. I build new Flutter apps, new Django '
      'back ends and on what I modernise.',
    );
  });

  testWidgets('starts on the lead offer and rotates through every line', (
    tester,
  ) async {
    await pumpTicker(tester);
    expect(find.text('I modernise'), findsOneWidget);
    expect(find.text('legacy Django apps.'), findsOneWidget);

    // The lead offer holds for its full time.
    await tester.pump(OfferTicker.leadHold - const Duration(milliseconds: 50));
    expect(find.text('Python 2 code bases.'), findsNothing);

    // Then every line follows in order, each replacing the one before, and
    // the loop comes back to the lead.
    final order = [...OfferTicker.lines.skip(1), OfferTicker.lines.first];
    var previous = OfferTicker.lines.first;
    for (final line in order) {
      for (var i = 0; i < 60 && find.text(line.tail).evaluate().isEmpty; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.pumpAndSettle();
      expect(find.text(line.tail), findsOneWidget);
      expect(find.text(line.verb), findsOneWidget);
      expect(find.text(previous.tail), findsNothing);
      if (line.verb != previous.verb) {
        expect(find.text(previous.verb), findsNothing);
      }
      previous = line;
    }
  });

  testWidgets('holds the lead offer still when motion is reduced', (
    tester,
  ) async {
    await pumpTicker(tester, reduceMotion: true);
    await tester.pump(OfferTicker.leadHold * 3);
    await tester.pumpAndSettle();
    expect(find.text('legacy Django apps.'), findsOneWidget);
  });

  testWidgets('screen readers get the sentence, not the rotating text', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpTicker(tester, wide: false);
    expect(find.bySemanticsLabel(Profile.offersSentence), findsOneWidget);
    expect(find.bySemanticsLabel('legacy Django apps.'), findsNothing);
    handle.dispose();
  });

  for (final size in [
    const Size(1440, 900),
    const Size(1366, 768),
    const Size(1920, 1080),
    const Size(1350, 600),
    const Size(1024, 768),
    const Size(390, 844),
    const Size(360, 640),
  ]) {
    testWidgets('offer line clears the brand, bubbles and labels at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const MyApp());
      await settleFonts(tester);

      final ticker = tester.getRect(find.byType(OfferTicker));
      expect(ticker.left, greaterThanOrEqualTo(0), reason: 'off the left');
      expect(ticker.right, lessThanOrEqualTo(size.width), reason: 'off right');

      final wordmark = tester.getRect(find.text('arilus'));
      expect(ticker.top, greaterThanOrEqualTo(wordmark.bottom));

      for (final badge in tester.widgetList<ContactBadge>(
        find.byType(ContactBadge),
      )) {
        final circle = tester.getCenter(find.byWidget(badge));
        final bubble = Rect.fromCircle(
          center: circle,
          radius: MenuLayout.bubbleRadius,
        );
        final label = tester.getRect(
          find.descendant(
            of: find.byWidget(badge),
            matching: find.text(badge.label),
          ),
        );
        expect(bubble.overlaps(ticker), isFalse, reason: badge.label);
        expect(label.overlaps(ticker), isFalse, reason: '${badge.label} label');
      }

      // Peak mode keeps the line in open sky, above every summit.
      if (!MenuLayout.useOrbit(size, count: 6)) {
        var skyline = double.infinity;
        for (var x = ticker.left; x <= ticker.right; x += 4) {
          skyline = math.min(skyline, MenuLayout.skylineAt(x, size));
        }
        expect(ticker.bottom, lessThan(skyline));
      }
    });
  }
}
