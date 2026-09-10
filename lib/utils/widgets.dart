import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> openUrl(String url) async {
  try {
    final launched = await launchUrlString(url);
    if (!launched && kDebugMode) {
      print('Could not launch $url');
    }
  } on Exception catch (e) {
    // sadly, Url couldn't be launched...
    if (kDebugMode) {
      print(e);
    }
  }
}

/// Round icon button that opens [url], or runs [onPressed] when given.
class ContactBadge extends StatelessWidget {
  final FaIconData icon;
  final String? url;
  final String? tooltip;
  final VoidCallback? onPressed;

  const ContactBadge({
    required this.icon,
    this.url,
    this.tooltip,
    this.onPressed,
    Key? key,
  })  : assert(url != null || onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: IconButton(
        tooltip: tooltip ?? url,
        icon: FaIcon(
          icon,
          color: Colors.white70,
        ),
        onPressed: onPressed ?? () => openUrl(url!),
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
