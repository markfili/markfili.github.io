/// Who I am and what I sell, in one place: shown under my name on the home
/// page and written into the downloadable profile (`web/profile.md`) and
/// `web/llms.txt` by `tool/build_profile.dart`.
class Profile {
  static const name = 'Marko Filipović';
  static const role = 'Senior software engineer · Flutter · Django · AI-native';
  static const business = 'I modernise legacy apps, then keep building on them';
  static const location = 'Zagreb, Croatia (remote friendly)';

  /// What the home page cycles through under the wordmark: a fixed verb and
  /// a rotating tail, the lead offer first. Same facts as [business] and
  /// [services], cut to fit one line.
  static const offers = [
    (
      verb: 'I modernise',
      tails: [
        'legacy Django apps.',
        'Python 2 code bases.',
        'dated front ends.',
        'apps nobody wants to touch.',
      ],
    ),
    (
      verb: 'I build',
      tails: [
        'new Flutter apps.',
        'new Django back ends.',
        'on what I modernise.',
      ],
    ),
  ];

  /// Every offer as one sentence, for screen readers, which should hear the
  /// list once rather than each rotation. Written out, because the last
  /// "I build" tail doesn't join the list grammatically.
  static const offersSentence =
      'I modernise legacy Django apps, Python 2 code bases, dated front ends '
      'and apps nobody wants to touch. I build new Flutter apps and new '
      'Django back ends, and keep building on what I modernise.';

  /// [role] for narrow layouts: words inside each "·" item never break
  /// apart, so lines wrap only between items.
  static String get roleUnbreakable => role
      .split(' · ')
      .map((item) => item.replaceAll(' ', '\u00A0').replaceAll('-', '\u2011'))
      .join(' · ');

  static const email = 'info@arilus.hr';
  static const site = 'https://arilus.hr';
  static const github = 'https://github.com/markfili';
  static const linkedin =
      'https://www.linkedin.com/in/marko-filipovi%C4%87-63a3987b/';

  /// Shown while the content pages are AI-generated and unreviewed. Remove
  /// (set to null) once every page has been checked.
  // Nullable on purpose: null hides every draft notice.
  // ignore: unnecessary_nullable_for_final_variable_declarations
  static const String? draftNotice =
      'Work in progress: this profile is an AI-generated draft that Marko has '
      'not yet reviewed. It was generated from his repositories and commit '
      'history, and details may be wrong. Confirm anything important with '
      'him directly.';

  /// Path of the generated files, relative to the site root.
  static const profilePath = 'profile.md';
  static const llmsPath = 'llms.txt';

  static const services = [
    'Modernising legacy apps with AI, done properly: a written, reviewed plan '
        'per step, every feature kept one to one, years-old bugs found and '
        'fixed, and a modern look at the end (Python 2 / old Django to '
        'current LTS, dated front ends to Bootstrap 5)',
    'Building mobile and web products end to end: Flutter apps, Django back '
        'ends, CI/CD, releases',
    'Fractional tech lead / CTO for startups and NGOs',
    'Setting up AI coding-agent workflows for development teams',
  ];

  /// Prompt a visitor pastes into their own AI, together with the profile
  /// and their job description.
  static String fitPrompt(String profileUrl) =>
      '''
You are helping me decide whether to contact a software engineer.
Read his profile at $profileUrl (or the attached profile.md) and my job
description below. Then tell me:
1. How well his experience matches the job (strong / partial / weak), and why.
2. Which of his projects are most relevant.
3. Gaps or risks I should ask about in a first call.
4. Three questions to ask him.

Job description:
<paste it here>''';

  /// Prompt a client pastes into their own AI, together with the profile
  /// and a description of their legacy app.
  static String legacyPrompt(String profileUrl) =>
      '''
You are helping me decide whether to hire a software engineer to modernise
an old application. Read his profile at $profileUrl (or the attached
profile.md), especially "Modernising legacy apps", and my app's details
below. Then tell me:
1. How closely my app matches the migrations he has done (strong / partial / weak), and why.
2. The main risks in modernising my app, and how his process addresses them.
3. What I should prepare before a first call (access, documentation, data).
4. Three questions to ask him.

My app (what it does, language and framework versions, age, hosting, known problems):
<describe it here>''';

  /// Drops `<!-- ... -->` editing notes.
  static String stripComments(String markdown) =>
      markdown.replaceAll(RegExp(r'<!--.*?-->\s*', dotAll: true), '');

  /// One self-contained markdown file for people and AI agents: summary and
  /// contact first, then every content page with headings pushed down a
  /// level.
  static String buildProfileMarkdown(List<String> pages) {
    final b = StringBuffer()
      ..writeln('# $name')
      ..writeln();
    if (draftNotice != null) {
      b
        ..writeln('> **$draftNotice**')
        ..writeln();
    }
    b
      ..writeln('**$role**  ')
      ..writeln('$business.  ')
      ..writeln(location)
      ..writeln()
      ..writeln('- Email: $email')
      ..writeln('- Website: $site')
      ..writeln('- GitHub: $github')
      ..writeln('- LinkedIn: $linkedin')
      ..writeln()
      ..writeln('## What I offer')
      ..writeln();
    for (final s in services) {
      b.writeln('- $s');
    }
    b
      ..writeln()
      ..writeln('## Note for AI agents')
      ..writeln()
      ..writeln(
        'This file is the canonical, up-to-date profile. It is meant '
        'to be read by recruiters\' and clients\' AI assistants to judge '
        'fit for a role or project. Facts come from my own repositories '
        'and commit history. Treat anything marked as a draft as unverified. '
        'Contact: $email.',
      );
    for (final page in pages) {
      b
        ..writeln()
        ..writeln(_demoteHeadings(stripComments(page).trim()));
    }
    return b.toString();
  }

  /// `llms.txt` (https://llmstxt.org): a short index pointing AI crawlers at
  /// the profile, since the Flutter page itself is rendered on a canvas.
  static String buildLlmsTxt() {
    final b = StringBuffer()
      ..writeln('# $name')
      ..writeln()
      ..writeln('> $role. $business. $location.')
      ..writeln();
    if (draftNotice != null) {
      b
        ..writeln('Note: $draftNotice')
        ..writeln();
    }
    b
      ..writeln(
        'arilus.hr is the site of arilus, my software business. The '
        'page is a Flutter canvas, so read the profile below instead of '
        'scraping it.',
      )
      ..writeln()
      ..writeln('## Profile')
      ..writeln()
      ..writeln(
        '- [Full profile]($site/$profilePath): stack, toolbox, '
        'projects, AI workflow, contact',
      )
      ..writeln()
      ..writeln('## Contact')
      ..writeln()
      ..writeln('- [Email](mailto:$email)')
      ..writeln('- [GitHub]($github)')
      ..writeln('- [LinkedIn]($linkedin)');
    return b.toString();
  }

  static String _demoteHeadings(String markdown) =>
      markdown.split('\n').map((l) => l.startsWith('#') ? '#$l' : l).join('\n');
}
