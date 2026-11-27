import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../data/profile.dart';
import '../utils/widgets.dart';

/// Absolute URL of the generated profile: next to the running page on the
/// web (so it also works locally), the public site elsewhere.
String profileUrl() => kIsWeb
    ? Uri.base.resolve(Profile.profilePath).toString()
    : '${Profile.site}/${Profile.profilePath}';

/// Address of the profile sheet; see [showContentSheet].
const profileSheetName = '/fit';

Future<void> showProfileSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    routeSettings: const RouteSettings(name: profileSheetName),
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    constraints: const BoxConstraints(maxWidth: 640),
    builder: (context) => ProfileSheet(url: profileUrl()),
  );
}

/// "Am I the right fit?": download the profile, or copy a prompt to hand it
/// to your own AI together with a job description.
class ProfileSheet extends StatelessWidget {
  final String url;
  final ValueChanged<String> onOpen;

  const ProfileSheet({required this.url, this.onOpen = openUrl, super.key});

  Future<void> _copyPrompt(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: Profile.fitPrompt(url)));
    if (!context.mounted) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(content: Text('Prompt copied. Paste it into your AI.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Am I the right fit?', style: text.headlineSmall),
          Insets.medium.h,
          Text(
            'Get my whole profile (stack, projects, how I work with AI and '
            'contact) as one Markdown file. Read it yourself, or give it to '
            'your AI together with your job description.',
            style: text.bodyMedium?.copyWith(height: 1.5),
          ),
          if (Profile.draftNotice != null) ...[
            Insets.medium.h,
            Text(
              'Work in progress: the profile is an AI-generated draft I '
              'haven\'t fully reviewed yet. Please confirm details with me.',
              style: text.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
          Insets.large.h,
          FilledButton.icon(
            onPressed: () => onOpen(url),
            icon: const Icon(Icons.download),
            label: const Text('Download profile (.md)'),
          ),
          Insets.medium.h,
          OutlinedButton.icon(
            onPressed: () => _copyPrompt(context),
            icon: const Icon(Icons.content_copy),
            label: const Text('Copy a prompt for your AI'),
          ),
          Insets.large.h,
          Text(
            'AI agents: the same profile is linked from '
            '${Profile.site}/${Profile.llmsPath}.',
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }
}
