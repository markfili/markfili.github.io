import 'package:material_ui/material_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/pages_repository.dart';
import 'utils/assets.dart';
import 'utils/theme.dart';
import 'utils/widgets.dart';
import 'widgets/hero_scene.dart';
import 'widgets/menu_layout.dart';
import 'data/profile.dart';
import 'widgets/content_sheet.dart';
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
      title: 'Arilus',
      theme: theme.light(),
      darkTheme: theme.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final small = textTheme.bodySmall?.copyWith(
      fontSize: 11,
      color: HeroScene.inkSoft,
      letterSpacing: 0.4,
    );
    final badges = [
      const ContactBadge(
        icon: FontAwesomeIcons.linkedinIn,
        tooltip: "LinkedIn",
        url: "https://www.linkedin.com/in/marko-filipovi%C4%87-63a3987b/",
      ),
      const ContactBadge(
        icon: FontAwesomeIcons.githubAlt,
        tooltip: "GitHub",
        url: "https://github.com/markfili",
      ),
      const ContactBadge(
        icon: FontAwesomeIcons.envelope,
        tooltip: "Email",
        url: "mailto:info@arilus.hr",
      ),
      ContactBadge(
        icon: FontAwesomeIcons.layerGroup,
        tooltip: "Stack",
        onPressed: () => showContentSheet(
          context,
          assets: const [ContentAssets.stack, ContentAssets.toolbox],
        ),
      ),
      ContactBadge(
        icon: FontAwesomeIcons.briefcase,
        tooltip: "Work",
        onPressed: _showWork,
      ),
      ContactBadge(
        icon: FontAwesomeIcons.wandMagicSparkles,
        tooltip: "AI",
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
            final size = constraints.biggest;
            final orbit = MenuLayout.useOrbit(size, count: badges.length);
            final logo = MenuLayout.logoCenter(size, orbit: orbit);
            final anchors = orbit
                ? MenuLayout.orbitAnchors(logo, count: badges.length)
                : MenuLayout.peakAnchors(size, count: badges.length);
            const move = Duration(milliseconds: 650);
            const curve = Curves.easeInOutCubic;
            const r = MenuLayout.bubbleRadius;
            const ring = MenuLayout.orbitRadius;
            return Stack(
              children: [
                const Positioned.fill(child: HeroScene()),
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("obrt za informatičke usluge", style: small),
                        Text("vl. Marko Filipović", style: small),
                        Text("Zagreb", style: small),
                        Insets.medium.h,
                        Text(
                          Profile.roleUnbreakable,
                          textAlign: TextAlign.center,
                          style: small?.copyWith(color: HeroScene.ink),
                        ),
                        Text(
                          Profile.business,
                          textAlign: TextAlign.center,
                          style: small,
                        ),
                        TextButton.icon(
                          onPressed: () => showProfileSheet(context),
                          style: TextButton.styleFrom(
                            foregroundColor: HeroScene.ink,
                            textStyle: small,
                            visualDensity: VisualDensity.compact,
                          ),
                          icon: const Icon(Icons.download, size: 14),
                          label: const Text("Profile for you & your AI"),
                        ),
                      ],
                    ),
                  ),
                ),
                for (var i = 0; i < badges.length; i++)
                  AnimatedPositioned(
                    duration: move,
                    curve: curve,
                    left: anchors[i].dx - r,
                    top: anchors[i].dy - r,
                    width: r * 2,
                    height: r * 2,
                    child: badges[i],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AColors {
  static const Color primaryColor = Color(0xFF263238);
  static const Color primaryLightColor = Color(0xFF4f5b62);
  static const Color primaryDarkColor = Color(0xFF000a12);
  static const Color secondaryColor = Color(0xFFb71c1c);
  static const Color secondaryLightColor = Color(0xFFf05545);
  static const Color secondaryDarkColor = Color(0xFF7f0000);
  static const Color primaryTextColor = Color(0xFFffffff);
  static const Color secondaryTextColor = Color(0xFFffffff);
}
