import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/pages_repository.dart';
import 'utils/assets.dart';
import 'utils/theme.dart';
import 'utils/widgets.dart';
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
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(Assets.logo),
                const Text(
                  "arilus",
                  style: TextStyle(
                    fontSize: 40,
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
                    child: Text(
                      "obrt za informatičke usluge",
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "vl. Marko Filipović",
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "Zagreb",
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ContactBadge(
                        icon: FontAwesomeIcons.linkedinIn,
                        url: "https://www.linkedin.com/in/marko-filipovi%C4%87-63a3987b/",
                      ),
                      8.w,
                      ContactBadge(
                        icon: FontAwesomeIcons.githubAlt,
                        url: "https://github.com/markfili",
                      ),
                      8.w,
                      ContactBadge(
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
