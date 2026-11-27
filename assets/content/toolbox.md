# Toolbox

> **Work in progress: AI-generated draft, not yet reviewed by Marko.** Generated from my repositories and commit history; details may be wrong. Please confirm with me before relying on them.

Packages, patterns and practices I use.

## Flutter

| Area | What I use |
|---|---|
| State management | **Riverpod** (with code generation and riverpod_lint), **BLoC** (hydrated_bloc, bloc_test), signals |
| Dependency injection | Riverpod providers, get_it + injectable |
| Networking | **dio** with retrofit, http, gRPC / protobuf, Serverpod client |
| Models & codegen | **freezed**, json_serializable, build_runner, equatable, dartz (`Either`), envied |
| Navigation | **go_router**, beamer |
| Firebase | Auth, Firestore, Cloud Messaging, Crashlytics, Analytics, Remote Config, Functions, Storage |
| Monitoring | Sentry, Crashlytics |
| Storage | shared_preferences, flutter_secure_storage, Hive CE, Firestore |
| Localisation | intl, easy_localization, slang |
| Maps & location | flutter_map (clustering, animations), Google Maps, geolocator, Nominatim geocoding |
| Device features | camera, CameraX (my own plugin), barcode/QR scanning, sensors, home-screen widgets, in-app updates, video |
| Real-time & chat | Stream Chat |
| Graphics | Flame, fragment shaders, `CustomPainter` |
| UI workflow | Widgetbook, flutter_animate, skeletonizer |
| Dart beyond Flutter | **Serverpod** and dart_frog backends, **Jaspr** for server-rendered web |

## Other stacks

| Stack | What I use |
|---|---|
| Django | Django REST Framework, SimpleJWT, drf-spectacular (OpenAPI), django-axes, django-simple-history, Jazzmin admin, WhiteNoise, Gunicorn, Ruff, djLint |
| Web front end | Next.js, React, Tailwind CSS, TypeScript, Vitest |
| Content | Directus (headless CMS) |
| Data | PostgreSQL, Supabase, SQLite, Firestore |
| Infrastructure | Docker / Compose, GitHub Pages, Railway |

## Architecture

- **Feature-first structure:** a `core/` layer (network, storage, router, theme,
  analytics, errors) and self-contained `features/`.
- **Layered data access:** repositories behind providers or BLoCs, and immutable
  models.
- **Monorepos:** app, web app, server and shared packages (client, models, i18n)
  in one repository, managed with melos.
- **Configuration:** environment-based config, remote config and feature flags.

## Delivery

- **CI:** GitHub Actions runs analysis, formatting, tests and dependency audits
  on every pull request, plus release and deploy pipelines. Some projects use
  GitLab CI.
- **Mobile releases:** fastlane for Android and iOS, in-app updates.
- **Deploys:** Docker images for Django and Next.js; GitHub Pages for web.

## Quality

- **Tests:** unit, widget and end-to-end tests. The largest of my apps has
  more than 300 test files.
- **Test doubles:** mocks with mockito and mocktail, fake clocks, fake Firestore.
- **Working method:** a short design doc first, then tests, then code.
- **Code quality:** strict lints (flutter_lints, riverpod_lint, Ruff), and
  Flutter versions pinned per project with FVM.
