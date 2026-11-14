import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:material_ui/material_ui.dart';

import '../data/profile.dart';
import '../utils/widgets.dart';

/// Content pages behind the menu bubbles, as markdown asset paths.
class ContentAssets {
  static const stack = 'assets/content/stack.md';
  static const toolbox = 'assets/content/toolbox.md';
  static const work = 'assets/content/work.md';
  static const ai = 'assets/content/ai.md';
}

/// Opens [assets] (rendered one after another) in a tall bottom sheet, with
/// an optional [footer] below them.
Future<void> showContentSheet(
  BuildContext context, {
  required List<String> assets,
  Widget? footer,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    constraints: const BoxConstraints(maxWidth: 880),
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.9,
      child: ContentSheet(assets: assets, footer: footer),
    ),
  );
}

/// Scrollable markdown documents loaded from the asset bundle.
class ContentSheet extends StatefulWidget {
  final List<String> assets;
  final Widget? footer;
  final ValueChanged<String> onOpen;

  /// Defaults to [rootBundle].
  final AssetBundle? bundle;

  const ContentSheet({
    required this.assets,
    this.footer,
    this.onOpen = openUrl,
    this.bundle,
    super.key,
  });

  /// Drops `<!-- ... -->` notes, which are for editing, not for visitors.
  static String stripComments(String markdown) =>
      Profile.stripComments(markdown);

  @override
  State<ContentSheet> createState() => _ContentSheetState();
}

class _ContentSheetState extends State<ContentSheet> {
  late final Future<List<String>> _docs = Future.wait([
    for (final asset in widget.assets)
      (widget.bundle ?? rootBundle).loadString(asset),
  ]);

  MarkdownStyleSheet _styleSheet(ThemeData theme) {
    final text = theme.textTheme;
    final colors = theme.colorScheme;
    final body = text.bodyMedium?.copyWith(height: 1.55);
    final small = text.bodySmall?.copyWith(height: 1.4);
    return MarkdownStyleSheet(
      p: body,
      listBullet: body,
      strong: const TextStyle(fontWeight: FontWeight.w600),
      a: TextStyle(color: colors.primary, decoration: TextDecoration.underline),
      code: small?.copyWith(backgroundColor: colors.surfaceContainerHighest),
      h1: text.headlineMedium?.copyWith(fontWeight: FontWeight.w300),
      h1Padding: const EdgeInsets.only(bottom: 4),
      h2: text.titleLarge,
      h2Padding: const EdgeInsets.only(top: 20),
      h3: text.titleMedium,
      h3Padding: const EdgeInsets.only(top: 12),
      blockSpacing: 12,
      listIndent: 20,
      tableHead: small?.copyWith(fontWeight: FontWeight.w600),
      tableBody: small,
      tableHeadAlign: TextAlign.left,
      tableBorder: TableBorder.all(color: colors.outlineVariant, width: 0.5),
      tableCellsPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      // Intrinsic widths make wide tables scroll sideways on phones.
      tableColumnWidth: const IntrinsicColumnWidth(),
      blockquote: small?.copyWith(fontStyle: FontStyle.italic),
      blockquotePadding: const EdgeInsets.all(12),
      blockquoteDecoration: BoxDecoration(
        color: colors.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final styleSheet = _styleSheet(Theme.of(context));
    return FutureBuilder<List<String>>(
      future: _docs,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Couldn't load this page."));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          children: [
            for (final doc in snapshot.requireData) ...[
              MarkdownBody(
                data: ContentSheet.stripComments(doc),
                styleSheet: styleSheet,
                onTapLink: (text, href, title) {
                  if (href != null) widget.onOpen(href);
                },
              ),
              const SizedBox(height: 40),
            ],
            if (widget.footer != null) widget.footer!,
          ],
        );
      },
    );
  }
}
