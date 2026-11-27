# arilus.hr

Source of [arilus.hr](https://arilus.hr), the one-screen home page of
Marko Filipović's software business. It's a Flutter web app with a
procedurally painted landscape, deployed to GitHub Pages.

## What's on the page

- **Hero scene:** a dark, grainy sky with misty mountain ridges, painted in
  code with `CustomPainter` and a grain fragment shader. It uses no image
  assets apart from the logo (`lib/widgets/hero_scene.dart`).
- **Offer line:** under the wordmark, "I modernise legacy Django apps." and
  the rest of `Profile.offers` rotate one at a time. The verb stays put and
  the tail drifts in. Reduced motion shows only the first line, and screen
  readers hear every offer once (`lib/widgets/offer_ticker.dart`).
- **Menu bubbles:** LinkedIn, GitHub, Modernise, Stack, Work and AI. Tapping a label does the
  same as its bubble.
  - On wide screens each bubble sits on its own mountain summit.
  - On narrow screens the bubbles circle the logo, and they animate between
    the two layouts.
  - Placement is in `lib/widgets/menu_layout.dart`.
- **Content pages:** Modernise, Stack, Work and AI open markdown pages from
  `assets/content/` in a bottom sheet. Work also lists my live GitHub Pages
  sites, fetched from the GitHub API.
- **Profile for people and AI:** a footer button opens a sheet with two
  actions. One downloads a single-file profile (`profile.md`); the other
  copies a prompt for checking fit against a job description.
- **Footer:** name, role, the email (opens mail, or copies it), the profile
  button, and the business registration.

## Making the site readable to crawlers and AI agents

The page is drawn on a canvas, so crawlers see almost no text. The site
publishes the same information in plain formats as well:

- `web/profile.md`: the full profile (contact, services, stack, work, AI
  workflow).
- `web/llms.txt`: an [llms.txt](https://llmstxt.org) index that points to the
  profile.
- `web/index.html`: a meta description, schema.org `Person` data, links to
  the profile, and a `<noscript>` fallback.

The content is a **work-in-progress, AI-generated draft** and says so
everywhere it appears. Remove the notice at the top of each page in
`assets/content/` once that page has been reviewed. Set
`Profile.draftNotice` to `null` in `lib/data/profile.dart` once all of them
have been.

## Development

The Flutter version is pinned with [FVM](https://fvm.app) in `.fvmrc`
(currently 3.50.0).

```sh
fvm flutter pub get
fvm flutter run -d chrome        # run locally
fvm flutter test                 # unit and widget tests
fvm flutter analyze
```

After editing anything in `assets/content/` or `lib/data/profile.dart`,
regenerate the plain-text profile. A test fails while it is out of date.

```sh
fvm dart run tool/build_profile.dart
```

## Deploy

GitHub Pages serves the `docs/` folder on `main`, with the custom domain in
`docs/CNAME`.

```sh
fvm dart run tool/build_profile.dart
fvm flutter build web --release --wasm --no-web-resources-cdn -o docs
git add docs && git commit -m "deploy …" && git push
```

`--wasm` gives Chromium browsers the faster wasm build; others fall back to
`main.dart.js`. `--no-web-resources-cdn` serves the renderer from the site
instead of gstatic, so the preloads in `web/index.html` are the files Flutter
actually uses.

## Layout

| Path | Contents |
|---|---|
| `lib/main.dart` | Home page: scene, logo, bubbles, footer |
| `lib/widgets/` | Hero scene, menu layout, content, profile and Pages sheets |
| `lib/data/` | GitHub Pages repository, profile text and generators |
| `assets/content/` | Markdown pages behind the bubbles |
| `tool/build_profile.dart` | Writes `web/profile.md` and `web/llms.txt` |
| `design/` | Design notes written before implementation |
| `docs/` | Built site (generated, deployed) |
