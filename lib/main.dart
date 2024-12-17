import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'utils/assets.dart';
import 'utils/widgets.dart';

void main() async {
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
        /*textTheme: GoogleFonts.dmMonoTextTheme(
          ThemeData.dark().textTheme,
        ),*/
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
          // TODO(marko): find a blurry, colorful shader and animate it
          ShaderBuilder(
            (context, shader, child) => CustomPaint(
              size: MediaQuery.of(context).size,
              painter: ShaderPainter(
                shader: shader,
              ),
            ),
            assetKey: 'shaders/simple.frag',
            child: const Center(
              child: CircularProgressIndicator(),
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
                        url:
                            "https://www.linkedin.com/in/marko-filipovi%C4%87-63a3987b/",
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ContactBadge(
                        icon: FontAwesomeIcons.githubAlt,
                        url: "https://github.com/markfili",
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ContactBadge(
                        icon: FontAwesomeIcons.envelope,
                        url: "mailto:mrkfilipovic3@gmail.com",
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

class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.shader}) : _paint = ui.Paint()..shader = shader;
  final ui.FragmentShader shader;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      ui.Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
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
