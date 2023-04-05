import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OnHover extends StatefulWidget {
  final Widget? child;

  const OnHover({Key? key, this.child}) : super(key: key);

  @override
  State<OnHover> createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHover> {
  final hovered = Matrix4.identity()..translate(0, -5, 0);
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final transform = isHovered ? hovered : Matrix4.identity();
    return MouseRegion(
      onEnter: (_) => setHovered(true),
      onExit: (_) => setHovered(false),
      child: AnimatedContainer(
        child: widget.child,
        transform: transform,
        duration: const Duration(
          milliseconds: 100,
        ),
      ),
    );
  }

  void setHovered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}

class ContactBadge extends StatelessWidget {
  final IconData icon;
  final String url;

  const ContactBadge({required this.icon, required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnHover(
      child: CircleAvatar(
        child: IconButton(tooltip: url,
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
      ),
    );
  }
}
