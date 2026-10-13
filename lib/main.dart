import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/pages_repository.dart';
import 'utils/assets.dart';
import 'utils/theme.dart';
import 'utils/widgets.dart';
import 'widgets/hero_scene.dart';
import 'widgets/pages_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = MaterialTheme(
      GoogleFonts.dmMonoTextTheme(
        ThemeData.dark().textTheme,
      ),
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
  const MyHomePage({Key? key}) : super(key: key);

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

  void _showPages() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => PagesSheet(loadSites: _loadSites),
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
    return Scaffold(
      backgroundColor: HeroScene.skyTop,
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 1400),
        curve: Curves.easeOut,
        builder: (context, opacity, child) =>
            Opacity(opacity: opacity, child: child),
        child: Stack(
          children: [
            const Positioned.fill(child: HeroScene()),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(Assets.logo),
                  Text(
                    "arilus",
                    style: textTheme.displaySmall?.copyWith(
                      fontSize: 56,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -2,
                      color: HeroScene.ink,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text("obrt za informatičke usluge", style: small),
                    ),
                    Flexible(
                      child: Text("vl. Marko Filipović", style: small),
                    ),
                    Flexible(
                      child: Text("Zagreb", style: small),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ContactBadge(
                          icon: FontAwesomeIcons.linkedinIn,
                          url:
                              "https://www.linkedin.com/in/marko-filipovi%C4%87-63a3987b/",
                        ),
                        8.w,
                        const ContactBadge(
                          icon: FontAwesomeIcons.githubAlt,
                          url: "https://github.com/markfili",
                        ),
                        8.w,
                        const ContactBadge(
                          icon: FontAwesomeIcons.envelope,
                          url: "mailto:info@arilus.hr",
                        ),
                        8.w,
                        ContactBadge(
                          icon: FontAwesomeIcons.layerGroup,
                          tooltip: "Projects",
                          onPressed: _showPages,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
