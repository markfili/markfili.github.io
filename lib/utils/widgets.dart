import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../widgets/hero_scene.dart';
import '../widgets/menu_layout.dart';

/// Opens [url]; false when nothing could handle it (e.g. `mailto:` on a
/// machine without a mail app).
Future<bool> openUrl(String url) async {
  try {
    final launched = await launchUrlString(url);
    if (!launched && kDebugMode) {
      debugPrint('Could not launch $url');
    }
    return launched;
  } on Exception catch (e) {
    if (kDebugMode) {
      debugPrint("$e");
    }
    return false;
  }
}

/// Copies [email] to the clipboard and says so.
Future<void> copyEmail(BuildContext context, String email) async {
  await Clipboard.setData(ClipboardData(text: email));
  if (!context.mounted) return;
  ScaffoldMessenger.maybeOf(context)
      ?.showSnackBar(SnackBar(content: Text('Copied $email')));
}

/// Round icon button that opens [url], or runs [onPressed] when given, with
/// a [label] beside it. Tapping the label does the same as tapping the circle.
///
/// The widget is a fixed [boxSize] box with the 40x40 circle at its centre, so
/// the label can sit on any [labelSide] without moving the circle. Empty parts
/// of the box don't take taps: only the circle (with a 48x48 target around
/// it) and the label text do.
class ContactBadge extends StatelessWidget {
  /// Gap between the bubble and its label.
  static const labelGap = MenuLayout.labelGap;
  static const _size = MenuLayout.bubbleRadius * 2;

  /// Tap target around the circle: the 48px minimum for touch.
  static const _target = 48.0;

  /// Room for one label (11 characters of 14 px DM Mono).
  static const labelSlot = Size(96, MenuLayout.labelHeight);

  /// Box holding the circle at its centre and a label slot on any side.
  static const boxSize = Size(
    _size + 2 * (labelGap + 96),
    _size + 2 * (labelGap + MenuLayout.labelHeight),
  );

  final FaIconData icon;
  final String label;

  /// Tooltip and screen-reader name: what's behind the bubble, starting
  /// with [label] so the spoken name matches the visible one.
  final String? description;
  final Alignment labelSide;
  final String? url;
  final VoidCallback? onPressed;

  const ContactBadge({
    required this.icon,
    required this.label,
    this.description,
    this.labelSide = Alignment.topCenter,
    this.url,
    this.onPressed,
    super.key,
  }) : assert(url != null || onPressed != null);

  /// This badge with its label moved to [side].
  ContactBadge withLabelSide(Alignment side) => ContactBadge(
    icon: icon,
    label: label,
    description: description,
    labelSide: side,
    url: url,
    onPressed: onPressed,
    key: key,
  );

  void _press() {
    if (onPressed != null) {
      onPressed!();
    } else {
      openUrl(url!);
    }
  }

  Widget _label(BuildContext context) {
    final text = ExcludeSemantics(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _press,
          child: Text(
            label,
            softWrap: false,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 14,
              color: HeroScene.ink,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
    final cx = (boxSize.width - labelSlot.width) / 2; // slot left, centred
    final cy = (boxSize.height - labelSlot.height) / 2; // slot top, centred
    if (labelSide.x != 0) {
      final right = labelSide.x > 0;
      return Positioned(
        left: right
            ? boxSize.width / 2 + _size / 2 + labelGap
            : boxSize.width / 2 - _size / 2 - labelGap - labelSlot.width,
        top: cy,
        width: labelSlot.width,
        height: labelSlot.height,
        child: Align(
          alignment: right ? Alignment.centerLeft : Alignment.centerRight,
          child: text,
        ),
      );
    }
    final above = labelSide.y < 0;
    return Positioned(
      left: cx,
      top: above
          ? boxSize.height / 2 - _size / 2 - labelGap - labelSlot.height
          : boxSize.height / 2 + _size / 2 + labelGap,
      width: labelSlot.width,
      height: labelSlot.height,
      child: Align(alignment: Alignment.center, child: text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: boxSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: (boxSize.width - _target) / 2,
            top: (boxSize.height - _target) / 2,
            width: _target,
            height: _target,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox.square(
                  dimension: _size,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HeroScene.glass,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: description ?? label,
                  icon: FaIcon(icon, color: Colors.white70, size: 20),
                  onPressed: _press,
                  style: IconButton.styleFrom(
                    fixedSize: const Size.square(_target),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          _label(context),
        ],
      ),
    );
  }
}

extension SizedSpacers on num {
  SizedBox get w {
    return SizedBox(width: toDouble());
  }

  SizedBox get h {
    return SizedBox(height: toDouble());
  }
}

class Insets {
  static const double small = 4.0;
  static const double medium = 8.0;
  static const double large = 16.0;
}
