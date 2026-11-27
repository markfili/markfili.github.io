import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:showcase/data/profile.dart';
import 'package:showcase/main.dart';
import 'package:showcase/widgets/content_sheet.dart';
import 'package:showcase/widgets/modernise_actions.dart';
import 'package:showcase/widgets/profile_sheet.dart';

import 'test_utils.dart';

const contentPages = [
  'assets/content/modernise.md',
  'assets/content/stack.md',
  'assets/content/toolbox.md',
  'assets/content/work.md',
  'assets/content/ai.md',
];

void main() {
  group('generated files', () {
    test('web/profile.md is up to date (run tool/build_profile.dart)', () {
      final expected = Profile.buildProfileMarkdown([
        for (final p in contentPages) File(p).readAsStringSync(),
      ]);
      expect(File('web/profile.md').readAsStringSync(), expected);
    });

    test('web/llms.txt is up to date (run tool/build_profile.dart)', () {
      expect(File('web/llms.txt').readAsStringSync(), Profile.buildLlmsTxt());
    });
  });

  group('buildProfileMarkdown', () {
    final md = Profile.buildProfileMarkdown([
      '<!-- secret note -->\n# Stack\n\n## Flutter\n\nDart',
    ]);

    test('starts with name, draft notice, role and contact', () {
      expect(md, startsWith('# ${Profile.name}\n'));
      expect(md, contains(Profile.draftNotice!));
      expect(md, contains(Profile.role));
      expect(md, contains(Profile.email));
    });

    test('nests pages under the name and drops editing notes', () {
      expect(md, contains('\n## Stack\n'));
      expect(md, contains('\n### Flutter\n'));
      expect(md, isNot(contains('secret note')));
    });
  });

  test('role only wraps between its items', () {
    expect(Profile.roleUnbreakable.split(' · '), hasLength(4));
    expect(
      Profile.roleUnbreakable.split(' · ').every((i) => !i.contains(' ')),
      isTrue,
    );
    expect(Profile.roleUnbreakable, isNot(contains('-')));
  });

  test('every content page says it is an unreviewed AI draft', () {
    for (final p in contentPages) {
      expect(
        File(p).readAsStringSync(),
        contains('Work in progress'),
        reason: p,
      );
    }
  });

  testWidgets('footer shows name, role, contact row, then legal', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    await settleFonts(tester);

    final name = tester.getTopLeft(find.text(Profile.name)).dy;
    final role = tester.getTopLeft(find.text(Profile.roleUnbreakable)).dy;
    final email = tester.getTopLeft(find.text(Profile.email)).dy;
    final legal = tester
        .getTopLeft(find.textContaining('obrt za informatičke usluge'))
        .dy;
    expect(role, greaterThan(name));
    expect(email, greaterThan(role));
    expect(legal, greaterThan(email));
    expect(find.text(Profile.business), findsNothing);
    expect(find.text('Talk about your app'), findsNothing);

    await tester.tap(find.text('Am I the right fit?'));
    await tester.pumpAndSettle();
    expect(find.text('Am I the right fit?'), findsNWidgets(2));
    expect(find.text('Download profile (.md)'), findsOneWidget);
  });

  testWidgets('the Modernise bubble opens the Modernise page', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    await settleFonts(tester);

    await tester.tap(
      find.byTooltip('Modernise: how I bring legacy apps up to date'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Modernising legacy apps'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Email me about your app'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Copy a prompt for your AI'), findsOneWidget);
  });

  testWidgets('tapping a label does the same as its bubble', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    await settleFonts(tester);

    await tester.tap(find.text('Work'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Live sites'),
      300,
      scrollable: find
          .descendant(
            of: find.byType(ContentSheet),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('Live sites'), findsOneWidget);
  });

  testWidgets('the footer email opens mail', (tester) async {
    final launched = mockUrlLauncher(tester, result: true);
    final copied = mockClipboard(tester);
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    await settleFonts(tester);

    await tester.tap(find.text(Profile.email));
    await tester.pump();
    expect(launched, ['mailto:${Profile.email}']);
    expect(copied, isEmpty);
  });

  testWidgets('the footer email falls back to copying', (tester) async {
    final launched = mockUrlLauncher(tester, result: false);
    final copied = mockClipboard(tester);
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    await settleFonts(tester);

    await tester.tap(find.text(Profile.email));
    await tester.pump();
    expect(launched, ['mailto:${Profile.email}']);
    expect(copied, [Profile.email]);
    expect(find.text('Copied ${Profile.email}'), findsOneWidget);
  });

  testWidgets('Modernise actions email me or copy the legacy prompt', (
    tester,
  ) async {
    final opened = <String>[];
    final clip = mockClipboard(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ModerniseActions(
            profileUrl: 'https://arilus.hr/profile.md',
            onOpen: opened.add,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Email me about your app'));
    expect(opened.single, startsWith('mailto:${Profile.email}?subject='));

    await tester.tap(find.text('Copy a prompt for your AI'));
    await tester.pump();
    expect(clip.last, contains('https://arilus.hr/profile.md'));
    expect(clip.last, contains('Modernising legacy apps'));
  });

  testWidgets('profile sheet downloads the profile and copies a prompt', (
    tester,
  ) async {
    final opened = <String>[];
    final clip = mockClipboard(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileSheet(
            url: 'https://arilus.hr/profile.md',
            onOpen: opened.add,
          ),
        ),
      ),
    );

    expect(find.textContaining('Work in progress'), findsOneWidget);

    await tester.tap(find.text('Download profile (.md)'));
    expect(opened, ['https://arilus.hr/profile.md']);

    await tester.tap(find.text('Copy a prompt for your AI'));
    await tester.pump();
    expect(clip.last, contains('https://arilus.hr/profile.md'));
    expect(clip.last, contains('Job description'));
    expect(find.text('Prompt copied. Paste it into your AI.'), findsOneWidget);
  });
}
