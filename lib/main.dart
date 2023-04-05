import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'utils/assets.dart';
import 'utils/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arilus',
      theme: ThemeData(
        textTheme: GoogleFonts.dmMonoTextTheme(
          ThemeData.dark().textTheme,
        ),
        brightness: Brightness.dark,
        primaryColor: AColors.primaryColor,
        primaryColorDark: AColors.primaryDarkColor,
        primaryColorLight: AColors.primaryLightColor,
      ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                colors: [
                  Colors.black38,
                  Colors.black38,
                  Colors.black38,
                  Colors.black54,
                  Colors.black38,
                  Colors.black38,
                  Colors.black38,
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OnHover(child: Image.asset(Assets.logo)),
                const Text(
                  "arilus",
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
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
                  )
                ],
              ),
            ),
          )
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
