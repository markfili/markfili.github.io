import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/data/pages_repository.dart';
import 'package:showcase/widgets/pages_sheet.dart';

const metalhop = PagesSite(name: 'metalhop', url: 'https://arilus.hr/metalhop/');
const parkSuma = PagesSite(
  name: 'park-suma',
  url: 'https://arilus.hr/park-suma/',
  description: 'Park šuma',
);

Future<void> pumpSheet(
  WidgetTester tester, {
  required PagesLoader loadSites,
  ValueChanged<String>? onOpen,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: PagesSheet(loadSites: loadSites, onOpen: onOpen ?? (_) {}),
      ),
    ),
  );
}

void main() {
  testWidgets('shows a spinner while loading', (tester) async {
    final pending = Completer<List<PagesSite>>();
    await pumpSheet(tester, loadSites: ({forceRefresh = false}) => pending.future);

    expect(find.text('Projects'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('lists sites and opens the tapped one', (tester) async {
    final opened = <String>[];
    await pumpSheet(
      tester,
      loadSites: ({forceRefresh = false}) async => [parkSuma, metalhop],
      onOpen: opened.add,
    );
    await tester.pump();

    expect(find.text('park-suma'), findsOneWidget);
    // Description wins over the URL as the subtitle.
    expect(find.text('Park šuma'), findsOneWidget);
    expect(find.text('arilus.hr/metalhop/'), findsOneWidget);

    await tester.tap(find.text('metalhop'));
    expect(opened, ['https://arilus.hr/metalhop/']);
  });

  testWidgets('says so when there are no sites', (tester) async {
    await pumpSheet(tester, loadSites: ({forceRefresh = false}) async => []);
    await tester.pump();

    expect(find.text('No projects yet'), findsOneWidget);
  });

  testWidgets('offers a GitHub link and a retry that refetches', (tester) async {
    final refreshes = <bool>[];
    final opened = <String>[];
    await pumpSheet(
      tester,
      loadSites: ({forceRefresh = false}) async {
        refreshes.add(forceRefresh);
        if (!forceRefresh) throw const PagesFetchException(403);
        return [metalhop];
      },
      onOpen: opened.add,
    );
    await tester.pump();

    expect(find.text("Couldn't load projects."), findsOneWidget);

    await tester.tap(find.text('See all repositories on GitHub'));
    expect(opened, ['https://github.com/markfili?tab=repositories']);

    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump();

    expect(refreshes, [false, true]);
    expect(find.text('metalhop'), findsOneWidget);
  });
}
