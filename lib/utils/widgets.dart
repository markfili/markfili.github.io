import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactBadge extends StatelessWidget {
  final FaIconData icon;
  final String url;

  const ContactBadge({
    required this.icon,
    required this.url,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: IconButton(
        tooltip: url,
        icon: FaIcon(
          icon,
          color: Colors.white70,
        ),
        onPressed: () {
          try {
            launchUrlString(url);
          } on Exception catch (e) {
            // sadly, Url couldn't be launched...
            if (kDebugMode) {
              print(e);
            }
          }
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}

extension SizedSpacers on num {
  SizedBox get w {
    return SizedBox(
      width: toDouble(),
    );
  }

  SizedBox get h {
    return SizedBox(
      height: toDouble(),
    );
  }
}

class Insets {
  static const double small = 4.0;
  static const double medium = 8.0;
  static const double large = 16.0;
}
