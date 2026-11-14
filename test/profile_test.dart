import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:showcase/data/profile.dart';
import 'package:showcase/main.dart';
import 'package:showcase/widgets/profile_sheet.dart';

import 'test_utils.dart';

const contentPages = [
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

  testWidgets('home page shows role and business under the name', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    await settleFonts(tester);

    final name = tester.getTopLeft(find.text('vl. Marko Filipović')).dy;
    expect(
      tester.getTopLeft(find.text(Profile.roleUnbreakable)).dy,
      greaterThan(name),
    );
    expect(find.text(Profile.business), findsOneWidget);

    await tester.tap(find.text('Profile for you & your AI'));
    await tester.pumpAndSettle();
    expect(find.text('Am I the right fit?'), findsOneWidget);
  });

  testWidgets('profile sheet downloads the profile and copies a prompt', (
    tester,
  ) async {
    final opened = <String>[];
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
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
    expect(copied, contains('https://arilus.hr/profile.md'));
    expect(copied, contains('Job description'));
    expect(find.text('Prompt copied. Paste it into your AI.'), findsOneWidget);
  });
}
