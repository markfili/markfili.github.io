import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:showcase/data/profile.dart';
import 'package:showcase/widgets/content_sheet.dart';
import 'package:showcase/widgets/years_timeline.dart';

void main() {
  test('reads open, closed, single and split year ranges', () {
    final groups = parseTimeline('''
## Stack

| Technology | Years | Last used |
|---|---|---|
| **Dart / Flutter** | 2020 – now | 2026 |
| Java (Android) | 2016 – 2019, 2026 | 2026 |
| GLSL | 2026 | 2026 |
| Broken | sometime | 2026 |
''', now: 2026);
    expect(groups, hasLength(1));
    expect(groups.single.title, 'Stack');
    final rows = {for (final r in groups.single.rows) r.label: r.spans};
    expect(rows['Dart / Flutter'], [(2020, 2026)]);
    expect(rows['Java'], [(2016, 2019), (2026, 2026)]);
    expect(rows['GLSL'], [(2026, 2026)]);
    expect(rows.containsKey('Broken'), isFalse);
  });

  test('labels drop brackets and anything after a colon', () {
    expect(
      shortLabel('Online trail stamp books (HPK, HPO): hikers log points'),
      'Online trail stamp books',
    );
    expect(shortLabel('**Python / Django**'), 'Python / Django');
  });

  test('every year on the Stack and Work pages parses', () {
    for (final page in ['stack', 'work']) {
      final md = File('assets/content/$page.md').readAsStringSync();
      expect(md, contains(ContentSheet.timelineMarker), reason: page);
      final tableRows = RegExp(
        r'^\| (?!Project|Technology|---)',
        multiLine: true,
      ).allMatches(md).length;
      final parsed = parseTimeline(
        md,
        now: 2026,
      ).fold<int>(0, (n, g) => n + g.rows.length);
      expect(parsed, tableRows, reason: '$page: a row lost its years');
    }
  });

  test('the plain-text profile carries no timeline marker', () {
    expect(
      Profile.buildProfileMarkdown([
        File('assets/content/work.md').readAsStringSync(),
      ]),
      isNot(contains('timeline')),
    );
  });

  for (final width in [880.0, 390.0]) {
    testWidgets('draws one bar per row and stays inside $width px', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final groups = parseTimeline(
        File('assets/content/work.md').readAsStringSync(),
        now: 2026,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: YearsTimeline(groups),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      final rows = groups.fold<int>(0, (n, g) => n + g.rows.length);
      expect(find.byType(Tooltip), findsNWidgets(rows));
      expect(find.text('Hauztor'), findsOneWidget);
      expect(find.text('Volunteer — mountaineering'), findsOneWidget);
    });
  }
}
