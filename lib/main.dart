import 'package:material_ui/material_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/pages_repository.dart';
import 'dev/mountain_playground.dart';
import 'utils/assets.dart';
import 'utils/theme.dart';
import 'utils/widgets.dart';
import 'widgets/hero_scene.dart';
import 'widgets/menu_layout.dart';
import 'data/profile.dart';
import 'widgets/content_sheet.dart';
import 'widgets/modernise_actions.dart';
import 'widgets/offer_ticker.dart';
import 'widgets/pages_list.dart';
import 'widgets/profile_sheet.dart';

void main() {
  // DM Mono ships in assets/fonts, so never go to the network for it.
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = MaterialTheme(
      GoogleFonts.dmMonoTextTheme(ThemeData.dark().textTheme),
    );
    return MaterialApp(
      // Flutter sets the browser tab title from this; keep web/index.html's
      // <title> the same.
      title: 'arilus · Legacy app modernisation · Marko Filipović',
      theme: theme.light(),
      darkTheme: theme.dark(),
      // The hero is a night scene; light sheets over it look out of place.
      themeMode: ThemeMode.dark,
      // ?playground=mountains opens the mountain tuning page.
      home: Uri.base.queryParameters['playground'] == 'mountains'
          ? const MountainPlayground()
          : const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  /// Finds the footer's box (fade strip included) in tests.
  static const footerKey = ValueKey('who-i-am-footer');

  /// 70% of skyTop: inkSoft reaches 5.1:1 over HeroScene.mist (4.5:1 needed).
  static const footerScrim = Color(0xB307070A);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pagesRepository = PagesRepository();
  // Fetched once per session; Retry in the sheet forces a new request.
  Future<List<PagesSite>>? _sites;

  Future<List<PagesSite>> _loadSites({bool forceRefresh = false}) {
    if (forceRefresh || _sites == null) {
      _sites = _pagesRepository.fetchSites();
    }
    return _sites!;
  }

  void _showWork() {
    final title = Theme.of(context).textTheme.titleLarge;
    showContentSheet(
      context,
      assets: const [ContentAssets.work],
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Live sites', style: title),
          PagesList(loadSites: _loadSites),
        ],
      ),
    );
  }

  void _showModernise() {
    showContentSheet(
      context,
      assets: const [ContentAssets.modernise],
      footer: ModerniseActions(profileUrl: profileUrl()),
    );
  }

  Future<void> _email() async {
    if (!await openUrl('mailto:${Profile.email}') && mounted) {
      await copyEmail(context, Profile.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final small = textTheme.bodySmall?.copyWith(
      fontSize: 12,
      color: HeroScene.inkSoft,
      letterSpacing: 0.4,
    );
    final badges = [
      const ContactBadge(
        icon: FontAwesomeIcons.linkedinIn,
        label: "LinkedIn",
        description: "LinkedIn: my profile",
        url: Profile.linkedin,
      ),
      const ContactBadge(
        icon: FontAwesomeIcons.githubAlt,
        label: "GitHub",
        description: "GitHub: my code",
        url: Profile.github,
      ),
      ContactBadge(
        icon: FontAwesomeIcons.seedling,
        label: "Modernise",
        description: "Modernise: how I bring legacy apps up to date",
        onPressed: _showModernise,
      ),
      ContactBadge(
        icon: FontAwesomeIcons.layerGroup,
        label: "Stack",
        description: "Stack: the languages and tools I use",
        onPressed: () => showContentSheet(
          context,
          assets: const [ContentAssets.stack, ContentAssets.toolbox],
        ),
      ),
      ContactBadge(
        icon: FontAwesomeIcons.briefcase,
        label: "Work",
        description: "Work: clients, projects and live sites",
        onPressed: _showWork,
      ),
      ContactBadge(
        icon: FontAwesomeIcons.wandMagicSparkles,
        label: "AI",
        description: "AI: how I work with AI coding agents",
        onPressed: () =>
            showContentSheet(context, assets: const [ContentAssets.ai]),
      ),
    ];
    return Scaffold(
      backgroundColor: HeroScene.skyTop,
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 1400),
        curve: Curves.easeOut,
        builder: (context, opacity, child) =>
            Opacity(opacity: opacity, child: child),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final viewport = constraints.biggest;
            final orbit = MenuLayout.useOrbit(viewport, count: badges.length);
            final size = Size(
              viewport.width,
              MenuLayout.pageHeight(viewport, orbit: orbit),
            );
            final logo = MenuLayout.logoCenter(size, orbit: orbit);
            final anchors = orbit
                ? MenuLayout.orbitAnchors(logo, count: badges.length)
                : MenuLayout.peakAnchors(size, count: badges.length);
            const move = Duration(milliseconds: 650);
            const curve = Curves.easeInOutCubic;
            const ring = MenuLayout.orbitRadius;
            // Scrolls only when the viewport is too short for the brand and
            // the footer (landscape phones).
            return SingleChildScrollView(
              physics: size.height > viewport.height
                  ? null
                  : const NeverScrollableScrollPhysics(),
              child: SizedBox.fromSize(
                size: size,
                child: Stack(
                  children: [
                    Positioned.fill(child: HeroScene()),
                    // Faint ring the bubbles orbit on; only on narrow screens.
                    AnimatedPositioned(
                      duration: move,
                      curve: curve,
                      left: logo.dx - ring,
                      top: logo.dy - ring,
                      width: ring * 2,
                      height: ring * 2,
                      child: IgnorePointer(
                        child: AnimatedOpacity(
                          duration: move,
                          opacity: orbit ? 1 : 0,
                          child: const DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(
                                BorderSide(color: Color(0x1FFFFFFF)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: move,
                      curve: curve,
                      left: logo.dx - MenuLayout.logoRadius,
                      top: logo.dy - MenuLayout.logoRadius,
                      width: MenuLayout.logoRadius * 2,
                      height: MenuLayout.logoRadius * 2,
                      child: Image.asset(Assets.logo),
                    ),
                    AnimatedPositioned(
                      duration: move,
                      curve: curve,
                      left: 0,
                      right: 0,
                      top: MenuLayout.wordmarkTop(size, orbit: orbit),
                      child: Text(
                        "arilus",
                        textAlign: TextAlign.center,
                        style: textTheme.displaySmall?.copyWith(
                          fontSize: 56,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -2,
                          color: HeroScene.ink,
                        ),
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        final ticker = MenuLayout.tickerRect(
                          size,
                          orbit: orbit,
                        );
                        return AnimatedPositioned(
                          duration: move,
                          curve: curve,
                          left: 0,
                          right: 0,
                          top: ticker.top,
                          height: ticker.height,
                          child: Center(
                            child: OfferTicker(
                              wide: MenuLayout.wideTicker(size),
                            ),
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _WhoIAm(
                        key: MyHomePage.footerKey,
                        small: small,
                        onEmail: _email,
                        onProfile: () => showProfileSheet(context),
                      ),
                    ),
                    for (var i = 0; i < badges.length; i++)
                      AnimatedPositioned(
                        duration: move,
                        curve: curve,
                        left: anchors[i].dx - ContactBadge.boxSize.width / 2,
                        top: anchors[i].dy - ContactBadge.boxSize.height / 2,
                        width: ContactBadge.boxSize.width,
                        height: ContactBadge.boxSize.height,
                        child: badges[i].withLabelSide(
                          orbit
                              ? MenuLayout.orbitLabelSide(
                                  i,
                                  count: badges.length,
                                )
                              : Alignment.topCenter,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Who I am and how to reach me, over a dusk scrim at the foot of the hero:
/// name and role, the email and the profile for AI, then the business
/// registration.
class _WhoIAm extends StatelessWidget {
  final TextStyle? small;
  final VoidCallback onEmail;
  final VoidCallback onProfile;

  const _WhoIAm({
    required this.small,
    required this.onEmail,
    required this.onProfile,
    super.key,
  });

  static const legal =
      'obrt za informatičke usluge · vl. Marko Filipović · Zagreb';

  /// Keeps the role at a readable line length on wide screens.
  static const maxWidth = 720.0;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final quiet = TextButton.styleFrom(
      foregroundColor: HeroScene.ink,
      textStyle: small?.copyWith(color: HeroScene.ink),
      minimumSize: const Size(48, 48),
    );
    // The one solid action on the page: a glass pill, brighter on hover.
    final primary = TextButton.styleFrom(
      foregroundColor: HeroScene.ink,
      backgroundColor: HeroScene.glass,
      overlayColor: Colors.white,
      textStyle: text.bodyMedium?.copyWith(letterSpacing: 0.2),
      minimumSize: const Size(48, 48),
      padding: const EdgeInsets.symmetric(horizontal: Insets.large + 4),
      shape: const StadiumBorder(),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Dusk settling on the front ridge, so the mountains fade out
        // instead of being cut off.
        const SizedBox(
          height: 32,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x0007070A), MyHomePage.footerScrim],
              ),
            ),
          ),
        ),
        ColoredBox(
          color: MyHomePage.footerScrim,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Insets.large,
              0,
              Insets.large,
              Insets.large,
            ),
            child: Center(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Profile.name,
                      style: text.titleSmall?.copyWith(color: HeroScene.ink),
                    ),
                    Text(
                      Profile.roleUnbreakable,
                      textAlign: TextAlign.center,
                      style: text.bodyMedium?.copyWith(
                        color: HeroScene.inkSoft,
                      ),
                    ),
                    Insets.medium.h,
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: Insets.large,
                      runSpacing: 0,
                      children: [
                        Semantics(
                          label: 'Email Marko at ${Profile.email}',
                          button: true,
                          excludeSemantics: true,
                          child: TextButton.icon(
                            onPressed: onEmail,
                            style: primary,
                            icon: const Icon(Icons.mail_outline, size: 18),
                            label: const Text(Profile.email),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: onProfile,
                          style: quiet,
                          icon: const Icon(Icons.fact_check_outlined, size: 16),
                          label: const Text('Am I the right fit?'),
                        ),
                      ],
                    ),
                    Insets.small.h,
                    Text(legal, textAlign: TextAlign.center, style: small),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
