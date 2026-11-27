import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:showcase/main.dart';
import 'package:showcase/utils/widgets.dart';
import 'package:showcase/widgets/menu_layout.dart';
import 'package:showcase/widgets/offer_ticker.dart';

import 'test_utils.dart';

void main() {
  for (final size in const [
    Size(1440, 900),
    Size(1024, 768),
    Size(390, 844),
    Size(360, 640),
    Size(320, 568),
  ]) {
    testWidgets('the corner button stays clear of everything at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const MyApp());
      await settleFonts(tester);

      final button = tester.getRect(find.byKey(MyHomePage.howKey));
      expect(button.size, const Size(48, 48));
      final screen = Offset.zero & size;
      expect(screen.contains(button.topLeft), isTrue);
      expect(
        screen.contains(button.bottomRight - const Offset(1, 1)),
        isTrue,
      );

      final others = <String, Rect>{
        'wordmark': tester.getRect(find.text('arilus')),
        'offer line': tester.getRect(find.byType(OfferTicker)),
      };
      for (final badge in tester.widgetList<ContactBadge>(
        find.byType(ContactBadge),
      )) {
        others[badge.label] = Rect.fromCircle(
          center: tester.getCenter(find.byWidget(badge)),
          radius: MenuLayout.bubbleRadius + 4,
        );
        others['${badge.label} label'] = tester.getRect(
          find.descendant(
            of: find.byWidget(badge),
            matching: find.text(badge.label),
          ),
        );
      }
      for (final MapEntry(:key, :value) in others.entries) {
        expect(button.overlaps(value), isFalse, reason: key);
      }
    });
  }

  testWidgets('it opens how.html in the same tab', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final launched = mockUrlLauncher(tester);
    await tester.pumpWidget(const MyApp());
    await settleFonts(tester);
    await tester.tap(find.byTooltip('How this page is made'));
    await tester.pump();
    expect(launched.single, endsWith('/how.html'));
  });

  test('how.html loads nothing from other hosts', () {
    final html = File('web/how.html').readAsStringSync();
    expect(
      RegExp(r'''(src|href)=["']https?://(?!arilus\.hr)''').hasMatch(html),
      isFalse,
    );
    expect(html, isNot(contains('googleapis')));
  });
}
