import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Lets google_fonts finish loading DM Mono from assets and settle the
/// relayout it triggers, so no frame is left scheduled after the test ends.
Future<void> settleFonts(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 50)),
  );
  await tester.pumpAndSettle();
}

/// Records the text of each `Clipboard.setData` call.
List<String> mockClipboard(WidgetTester tester) {
  final copied = <String>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (call) async {
      if (call.method == 'Clipboard.setData') {
        copied.add((call.arguments as Map)['text'] as String);
      }
      return null;
    },
  );
  return copied;
}

/// Records the `url` of each url_launcher `launch` call and answers [result].
List<String> mockUrlLauncher(WidgetTester tester, {bool result = true}) {
  final launched = <String>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/url_launcher'),
    (call) async {
      if (call.method == 'launch') {
        launched.add((call.arguments as Map)['url'] as String);
      }
      return result;
    },
  );
  return launched;
}
