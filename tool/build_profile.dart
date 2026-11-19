// Regenerates web/profile.md and web/llms.txt from assets/content/*.md.
//
//   fvm dart run tool/build_profile.dart
//
// Run it after editing any content page; test/profile_test.dart fails while
// the generated files are stale.
import 'dart:io';

import 'package:showcase/data/profile.dart';

const pages = [
  'assets/content/modernise.md',
  'assets/content/stack.md',
  'assets/content/toolbox.md',
  'assets/content/work.md',
  'assets/content/ai.md',
];

void main() {
  final profile = Profile.buildProfileMarkdown([
    for (final p in pages) File(p).readAsStringSync(),
  ]);
  File('web/${Profile.profilePath}').writeAsStringSync(profile);
  File('web/${Profile.llmsPath}').writeAsStringSync(Profile.buildLlmsTxt());
  stdout.writeln(
    'Wrote web/${Profile.profilePath} and web/${Profile.llmsPath}',
  );
}
