import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:showcase/data/profile.dart';
import 'package:showcase/main.dart';
import 'package:showcase/utils/theme.dart';
import 'package:showcase/widgets/content_sheet.dart';
import 'package:showcase/widgets/profile_sheet.dart';

Future<void> pumpHome(WidgetTester tester, {String? route}) async {
  tester.view.physicalSize = const Size(1440, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MyApp(initialRoute: route));
  await settle(tester);
}

/// Lets fonts and sheet assets load for real (a sheet shows a spinner until
/// they do, so pumpAndSettle would never return) and the sheet slide in.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump(const Duration(milliseconds: 400));
  }
}

/// Name of the route the sheet showing [finder] lives in.
String? routeOf(WidgetTester tester, Finder finder) =>
    ModalRoute.of(tester.element(finder))?.settings.name;

void main() {
  for (final (label, name) in [
    ('Modernise', '/modernise'),
    ('Stack', '/stack'),
    ('Work', '/work'),
    ('AI', '/ai'),
  ]) {
    testWidgets('$label opens at its own address, $name', (tester) async {
      await pumpHome(tester);
      await tester.tap(find.text(label));
      await settle(tester);
      expect(routeOf(tester, find.byType(ContentSheet)), name);
    });

    testWidgets('arriving at $name opens the $label sheet', (tester) async {
      await pumpHome(tester, route: name);
      expect(routeOf(tester, find.byType(ContentSheet)), name);
    });
  }

  testWidgets('arriving at /fit opens the profile sheet', (tester) async {
    await pumpHome(tester, route: profileSheetName);
    expect(routeOf(tester, find.byType(ProfileSheet)), profileSheetName);
  });

  testWidgets('an unknown address just shows the home page', (tester) async {
    await pumpHome(tester, route: '/nope');
    expect(find.byType(ContentSheet), findsNothing);
    expect(find.text('arilus'), findsOneWidget);
  });

  testWidgets('Esc closes a sheet', (tester) async {
    await pumpHome(tester, route: '/work');
    expect(find.byType(ContentSheet), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await settle(tester);
    expect(find.byType(ContentSheet), findsNothing);
  });

  testWidgets('Tab goes through the bubbles in menu order, then the footer', (
    tester,
  ) async {
    await pumpHome(tester);
    final expected = [
      'LinkedIn: my profile',
      'GitHub: my code',
      'Modernise: how I bring legacy apps up to date',
      'Stack: the languages and tools I use',
      'Work: clients, projects and live sites',
      'AI: how I work with AI coding agents',
    ];
    for (final tooltip in expected) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      final focused = FocusManager.instance.primaryFocus!.context!;
      expect(
        find.ancestor(
          of: find.byElementPredicate((e) => e == focused),
          matching: find.byTooltip(tooltip),
        ),
        findsOneWidget,
        reason: tooltip,
      );
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final focused = FocusManager.instance.primaryFocus!.context!;
    expect(
      find.ancestor(
        of: find.byElementPredicate((e) => e == focused),
        matching: find.widgetWithText(TextButton, Profile.email),
      ),
      findsOneWidget,
    );
  });

  test('the focus ring shows for keyboard focus only', () {
    final ring = MaterialTheme.focusRing(Colors.white);
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    expect(ring.resolve({WidgetState.focused})?.width, 2);
    expect(ring.resolve({}), isNull);
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTouch;
    expect(ring.resolve({WidgetState.focused}), isNull);
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic;
  });

  testWidgets(
    'screen readers hear the brand, the offer, the menu, the footer',
    (tester) async {
      final handle = tester.ensureSemantics();
      await pumpHome(tester);
      expect(
        tester.getSemantics(find.text('arilus')),
        matchesSemantics(label: 'arilus', isHeader: true),
      );
      final order = tester.semantics
          .simulatedAccessibilityTraversal()
          // Flutter web reads a tooltip out as part of the name.
          .map((node) => node.label.isEmpty ? node.tooltip : node.label)
          .where((l) => l.isNotEmpty)
          .toList();
      int at(String label) => order.indexWhere((l) => l.startsWith(label));
      expect(order, contains('Email Marko at ${Profile.email}'));
      expect(order, contains('Am I the right fit?'));
      expect(at('arilus'), lessThan(at('I modernise')));
      expect(at('I modernise'), lessThan(at('LinkedIn')));
      expect(at('LinkedIn'), lessThan(at('GitHub')));
      expect(at('AI:'), lessThan(at(Profile.name)));
      expect(
        at(Profile.name),
        lessThan(at('Email Marko')),
        reason: order.join(' | '),
      );
      handle.dispose();
    },
  );
}
