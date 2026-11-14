import 'package:flutter_test/flutter_test.dart';

/// Lets google_fonts finish loading DM Mono from assets and settle the
/// relayout it triggers, so no frame is left scheduled after the test ends.
Future<void> settleFonts(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 50)),
  );
  await tester.pumpAndSettle();
}
