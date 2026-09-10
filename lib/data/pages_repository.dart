import 'dart:convert';

import 'package:http/http.dart' as http;

class PagesSite {
  final String name;
  final String? description;
  final String url;

  const PagesSite({
    required this.name,
    required this.url,
    this.description,
  });
}

class PagesFetchException implements Exception {
  final int statusCode;

  const PagesFetchException(this.statusCode);

  @override
  String toString() => 'PagesFetchException: GitHub API responded $statusCode';
}

/// Lists the GitHub repositories of [_user] that have GitHub Pages enabled,
/// followed by [extraSites].
class PagesRepository {
  static const _user = 'markfili';
  // The user site is arilus.hr itself, so it is not listed.
  static const _userSite = '$_user.github.io';
  // Project Pages sites are served under the user site's custom domain.
  static const _pagesOrigin = 'https://arilus.hr';

  /// Projects the user endpoint can't return: org repos and sites hosted
  /// outside GitHub Pages.
  static const defaultExtraSites = [
    PagesSite(
      name: 'Zagreb Developers Drinkup',
      url: 'https://zagreb-developers.github.io/drinkup/',
    ),
    PagesSite(
      name: 'Zagreb Developers Spaces',
      url: 'https://zagreb-developers.github.io/spaces/',
    ),
    PagesSite(
      name: 'Uradi sad',
      url: 'https://uradisad.vercel.app/',
    ),
  ];

  final http.Client _client;
  final List<PagesSite> extraSites;

  PagesRepository({
    http.Client? client,
    this.extraSites = defaultExtraSites,
  }) : _client = client ?? http.Client();

  Future<List<PagesSite>> fetchSites() async {
    final response = await _client.get(
      Uri.https('api.github.com', '/users/$_user/repos', {
        'per_page': '100',
        'type': 'owner',
      }),
      headers: {'Accept': 'application/vnd.github+json'},
    );
    if (response.statusCode != 200) {
      throw PagesFetchException(response.statusCode);
    }

    final repos = (jsonDecode(response.body) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .where((repo) => repo['has_pages'] == true && repo['name'] != _userSite)
        .toList()
      // ISO 8601 timestamps sort chronologically as strings.
      ..sort((a, b) => _pushedAt(b).compareTo(_pushedAt(a)));

    return [
      for (final repo in repos)
        PagesSite(
          name: repo['name'] as String,
          description: _nonEmpty(repo['description'] as String?),
          url: _nonEmpty(repo['homepage'] as String?) ??
              '$_pagesOrigin/${repo['name']}/',
        ),
      ...extraSites,
    ];
  }

  static String _pushedAt(Map<String, dynamic> repo) =>
      repo['pushed_at'] as String? ?? '';

  static String? _nonEmpty(String? value) =>
      value == null || value.isEmpty ? null : value;
}
