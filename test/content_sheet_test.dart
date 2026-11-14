import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:showcase/widgets/content_sheet.dart';

/// Serves markdown from memory instead of the real asset bundle.
class FakeBundle extends CachingAssetBundle {
  final Map<String, String> files;

  FakeBundle(this.files);

  @override
  Future<ByteData> load(String key) async {
    final text = files[key];
    if (text == null) throw FlutterError('missing $key');
    return ByteData.sublistView(utf8.encode(text));
  }
}

Future<void> pumpContent(
  WidgetTester tester, {
  required Map<String, String> files,
  Widget? footer,
  ValueChanged<String>? onOpen,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ContentSheet(
          assets: files.keys.toList(),
          bundle: FakeBundle(files),
          footer: footer,
          onOpen: onOpen ?? (_) {},
        ),
      ),
    ),
  );
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  await tester.pumpAndSettle();
}

void main() {
  test('stripComments removes editing notes, single and multi-line', () {
    expect(
      ContentSheet.stripComments('<!--\nTODO: x\n-->\n# Title <!-- y -->ok'),
      '# Title ok',
    );
  });

  testWidgets('renders every document in order, then the footer', (
    tester,
  ) async {
    await pumpContent(
      tester,
      files: {'a.md': '# Stack\n\nDart', 'b.md': '# Toolbox\n\n- Riverpod'},
      footer: const Text('Live sites'),
    );

    final stack = tester.getTopLeft(find.text('Stack')).dy;
    final toolbox = tester.getTopLeft(find.text('Toolbox')).dy;
    expect(stack, lessThan(toolbox));
    expect(find.text('Riverpod'), findsOneWidget);
    expect(find.text('Live sites'), findsOneWidget);
  });

  testWidgets('hides HTML comments from visitors', (tester) async {
    await pumpContent(tester, files: {'w.md': '<!-- TODO: verify -->\n# Work'});

    expect(find.text('Work'), findsOneWidget);
    expect(find.textContaining('TODO'), findsNothing);
  });

  testWidgets('renders tables', (tester) async {
    await pumpContent(
      tester,
      files: {'t.md': '| Tech | Years |\n|---|---|\n| Dart | 2020 – now |'},
    );

    expect(find.byType(Table), findsOneWidget);
    expect(find.text('2020 – now'), findsOneWidget);
  });

  testWidgets('says so when a document cannot be loaded', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ContentSheet(
            assets: const ['missing.md'],
            bundle: FakeBundle(const {}),
          ),
        ),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't load this page."), findsOneWidget);
  });

  testWidgets('the real content assets all load and render', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ContentSheet(
            assets: [
              ContentAssets.stack,
              ContentAssets.toolbox,
              ContentAssets.work,
              ContentAssets.ai,
            ],
          ),
        ),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Stack'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
