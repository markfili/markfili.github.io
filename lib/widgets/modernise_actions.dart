import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../data/profile.dart';
import '../utils/widgets.dart';

/// Call to action under the Modernise page: email me, or hand the profile
/// and your app's details to your own AI first.
class ModerniseActions extends StatelessWidget {
  final String profileUrl;
  final ValueChanged<String> onOpen;

  const ModerniseActions({
    required this.profileUrl,
    this.onOpen = openUrl,
    super.key,
  });

  static final mailto = Uri(
    scheme: 'mailto',
    path: Profile.email,
    query: 'subject=Modernising%20my%20app',
  ).toString();

  Future<void> _copyPrompt(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(text: Profile.legacyPrompt(profileUrl)),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(
        content: Text('Prompt copied. Paste it into your AI with your app.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Talk about your app', style: text.titleLarge),
        Insets.medium.h,
        Text(
          'Tell me what it runs on and how old it is, or check the fit with '
          'your own AI first.',
          style: text.bodyMedium?.copyWith(height: 1.5),
        ),
        Insets.large.h,
        FilledButton.icon(
          onPressed: () => onOpen(mailto),
          icon: const Icon(Icons.mail_outline),
          label: const Text('Email me about your app'),
        ),
        Insets.medium.h,
        OutlinedButton.icon(
          onPressed: () => _copyPrompt(context),
          icon: const Icon(Icons.content_copy),
          label: const Text('Copy a prompt for your AI'),
        ),
      ],
    );
  }
}
