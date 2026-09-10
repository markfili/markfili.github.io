import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:showcase/data/pages_repository.dart';

Map<String, Object?> repo(
  String name, {
  bool hasPages = true,
  String pushedAt = '2026-01-01T00:00:00Z',
  String? homepage,
  String? description,
}) =>
    {
      'name': name,
      'has_pages': hasPages,
      'pushed_at': pushedAt,
      'homepage': homepage,
      'description': description,
    };

PagesRepository repositoryReturning(
  List<Map<String, Object?>> repos, {
  void Function(http.Request request)? onRequest,
  List<PagesSite> extraSites = const [],
}) {
  return PagesRepository(
    client: MockClient((request) async {
      onRequest?.call(request);
      return http.Response(jsonEncode(repos), 200);
    }),
    extraSites: extraSites,
  );
}

void main() {
  test('appends the extra sites after the Pages repos', () async {
    const extra = PagesSite(name: 'Extra', url: 'https://extra.example');
    final sites = await repositoryReturning(
      [repo('metalhop')],
      extraSites: [extra],
    ).fetchSites();

    expect(sites.map((site) => site.name), ['metalhop', 'Extra']);
  });

  test('links drinkup, spaces and uradisad by default', () async {
    final sites = await PagesRepository(
      client: MockClient((_) async => http.Response('[]', 200)),
    ).fetchSites();

    expect(sites.map((site) => site.url), [
      'https://zagreb-developers.github.io/drinkup/',
      'https://zagreb-developers.github.io/spaces/',
      'https://uradisad.vercel.app/',
    ]);
  });

  test('requests the owner repos of markfili', () async {
    late Uri requested;
    await repositoryReturning(
      [],
      onRequest: (request) => requested = request.url,
    ).fetchSites();

    expect(requested.host, 'api.github.com');
    expect(requested.path, '/users/markfili/repos');
    expect(requested.queryParameters['per_page'], '100');
    expect(requested.queryParameters['type'], 'owner');
  });

  test('keeps Pages repos except the user site, newest push first', () async {
    final sites = await repositoryReturning([
      repo('old', pushedAt: '2024-05-01T00:00:00Z'),
      repo('no-pages', hasPages: false),
      repo('markfili.github.io'),
      repo('new', pushedAt: '2026-08-01T00:00:00Z'),
    ]).fetchSites();

    expect(sites.map((site) => site.name), ['new', 'old']);
  });

  test('uses homepage when set, otherwise the arilus.hr project path', () async {
    final sites = await repositoryReturning([
      repo('metalhop', pushedAt: '2026-02-01T00:00:00Z'),
      repo('custom', homepage: 'https://custom.example'),
      repo('blank', homepage: '', pushedAt: '2025-01-01T00:00:00Z'),
    ]).fetchSites();

    expect(sites.map((site) => site.url), [
      'https://arilus.hr/metalhop/',
      'https://custom.example',
      'https://arilus.hr/blank/',
    ]);
  });

  test('treats an empty description as missing', () async {
    final sites = await repositoryReturning([
      repo('a', description: '', pushedAt: '2026-02-01T00:00:00Z'),
      repo('b', description: 'testing ground'),
    ]).fetchSites();

    expect(sites.map((site) => site.description), [null, 'testing ground']);
  });

  test('throws PagesFetchException on a non-200 response', () {
    final repository = PagesRepository(
      client: MockClient((_) async => http.Response('rate limited', 403)),
    );

    expect(
      repository.fetchSites(),
      throwsA(
        isA<PagesFetchException>().having((e) => e.statusCode, 'statusCode', 403),
      ),
    );
  });
}
