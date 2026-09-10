import 'package:flutter/material.dart';

import '../data/pages_repository.dart';
import '../utils/widgets.dart';

typedef PagesLoader = Future<List<PagesSite>> Function({bool forceRefresh});

/// Bottom sheet listing the GitHub repositories that have Pages enabled.
class PagesSheet extends StatefulWidget {
  final PagesLoader loadSites;
  final ValueChanged<String> onOpen;

  const PagesSheet({
    required this.loadSites,
    this.onOpen = openUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<PagesSheet> createState() => _PagesSheetState();
}

class _PagesSheetState extends State<PagesSheet> {
  static const _repositoriesUrl = 'https://github.com/markfili?tab=repositories';

  late Future<List<PagesSite>> _sites = widget.loadSites();

  void _retry() {
    setState(() {
      _sites = widget.loadSites(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Insets.large,
          0,
          Insets.large,
          Insets.large,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Projects',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Insets.medium.h,
            Flexible(
              child: FutureBuilder<List<PagesSite>>(
                future: _sites,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const _Placeholder(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return _Placeholder(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Couldn't load projects."),
                          Insets.medium.h,
                          FilledButton(
                            onPressed: _retry,
                            child: const Text('Retry'),
                          ),
                          TextButton(
                            onPressed: () => widget.onOpen(_repositoriesUrl),
                            child: const Text('See all repositories on GitHub'),
                          ),
                        ],
                      ),
                    );
                  }
                  final sites = snapshot.requireData;
                  if (sites.isEmpty) {
                    return const _Placeholder(child: Text('No projects yet'));
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      for (final site in sites)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(site.name),
                          subtitle: Text(
                            site.description ??
                                site.url.replaceFirst(RegExp('^https?://'), ''),
                          ),
                          trailing: const Icon(Icons.open_in_new, size: 18),
                          onTap: () => widget.onOpen(site.url),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final Widget child;

  const _Placeholder({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.large * 2),
      child: Center(child: child),
    );
  }
}
