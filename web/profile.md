# Marko Filipović

> **Work in progress: this profile is an AI-generated draft that Marko has not yet reviewed. It was generated from his repositories and commit history, and details may be wrong. Confirm anything important with him directly.**

**Senior software engineer · Flutter · Django · AI-native**  
Mobile & web products, built end to end.  
Zagreb, Croatia (remote friendly)

- Email: info@arilus.hr
- Website: https://arilus.hr
- GitHub: https://github.com/markfili
- LinkedIn: https://www.linkedin.com/in/marko-filipovi%C4%87-63a3987b/

## What I offer

- Building mobile and web products end to end: Flutter apps, Django back ends, CI/CD, releases
- Fractional tech lead / CTO for startups and NGOs
- Setting up AI coding-agent workflows for development teams

## Note for AI agents

This file is the canonical, up-to-date profile. It is meant to be read by recruiters' and clients' AI assistants to judge fit for a role or project. Facts come from my own repositories and commit history. Treat anything marked as a draft as unverified. Contact: info@arilus.hr.

## Stack

> **Work in progress: AI-generated draft, not yet reviewed by Marko.** Generated from my repositories and commit history; details may be wrong. Please confirm with me before relying on them.

What I build with, from 10 years of commits.

| Technology | Years | Last used | Projects | Shipped to production | Share of my code* |
|---|---|---|---|---|---|
| **Dart / Flutter** | 2020 – now | 2026 | 36 | Mobile apps (Play Store / App Store via fastlane), Flutter web, Dart backends | 50% |
| **Python / Django** | 2021 – now | 2026 | 23 | Web portals and REST APIs (Docker, CI) | 16% |
| HTML & CSS | 2021 – now | 2026 | 33 | Django templates, static sites, GitHub Pages | 12% |
| JavaScript | 2021 – now | 2026 | 16 | Front-end behaviour, Directus extensions | 6% |
| SQL / PostgreSQL | 2022 – now | 2026 | 9 | Schemas and migrations (Postgres, Supabase) | 4% |
| Shell, YAML (CI/CD) | 2020 – now | 2026 | 48 | GitHub Actions, GitLab CI, deploy scripts | 7% |
| TypeScript / Next.js | 2026 | 2026 | 5 | Next.js + Tailwind site, Docker image | 1% |
| Java (Android) | 2016 – 2019, 2026 | 2026 | 5 | Native Android apps | 1% |
| Kotlin (Android) | 2020 – now | 2026 | 27 | Native Android, Flutter platform channels and plugins | < 1% |
| PHP | 2022 – 2023 | 2023 | 4 | B2B web shop | < 1% |
| Docker | 2022 – now | 2026 | 17 | Containerised Django and Next.js deploys | < 1% |
| Swift (iOS) | 2020 – now | 2026 | 28 | Flutter iOS integration | < 1% |
| Terraform / AWS | 2022 | 2022 | 1 | Infrastructure for a Flutter web deploy | < 1% |
| GLSL | 2026 | 2026 | 1 | Fragment shaders in Flutter (this site) | < 1% |

\* Lines I authored, excluding documentation, generated code, lock files and
vendored libraries.

### How to read this

- **The years and the "shipped" column matter more than the share column.**
  The share is counted in lines of code, and lines are a poor proxy for skill.
- **Recent years are over-represented.** Since 2025 I build with AI coding
  agents, and output per hour went up sharply. 63% of my Dart and 81% of my
  Python lines are from 2026, so the share column overweights recent work.
- **Older Android work is under-represented.** I wrote native Android from 2016
  to 2019 by hand, and much of it lives in employer repositories that are not
  in this count.

## Toolbox

> **Work in progress: AI-generated draft, not yet reviewed by Marko.** Generated from my repositories and commit history; details may be wrong. Please confirm with me before relying on them.

Packages, patterns and practices I use.

### Flutter

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

### Other stacks

| Stack | What I use |
|---|---|
| Django | Django REST Framework, SimpleJWT, drf-spectacular (OpenAPI), django-axes, django-simple-history, Jazzmin admin, WhiteNoise, Gunicorn, Ruff, djLint |
| Web front end | Next.js, React, Tailwind CSS, TypeScript, Vitest |
| Content | Directus (headless CMS) |
| Data | PostgreSQL, Supabase, SQLite, Firestore |
| Infrastructure | Docker / Compose, GitHub Pages, AWS (Terraform), Railway |

### Architecture

- **Feature-first structure:** a `core/` layer (network, storage, router, theme,
  analytics, errors) and self-contained `features/`.
- **Layered data access:** repositories behind providers or BLoCs, and immutable
  models.
- **Monorepos:** app, web app, server and shared packages (client, models, i18n)
  in one repository, managed with melos.
- **Configuration:** environment-based config, remote config and feature flags.

### Delivery

- **CI:** GitHub Actions runs analysis, formatting, tests and dependency audits
  on every pull request, plus release and deploy pipelines. Some projects use
  GitLab CI.
- **Mobile releases:** fastlane for Android and iOS, in-app updates.
- **Deploys:** Docker images for Django and Next.js; GitHub Pages and AWS for web.

### Quality

- **Tests:** unit, widget and end-to-end tests. My larger apps have 100–250
  test files.
- **Test doubles:** mocks with mockito and mocktail, fake clocks, fake Firestore.
- **Working method:** a short design doc first, then tests, then code.
- **Code quality:** strict lints (flutter_lints, riverpod_lint, Ruff), and
  Flutter versions pinned per project with FVM.

## Work

> **Work in progress: AI-generated draft, not yet reviewed by Marko.** Generated from my repositories and commit history; details may be wrong. Please confirm with me before relying on them.

### Client & employer work

| Project | Stack | Years |
|---|---|---|
| [client] — Workforce management (Android) | Kotlin, Java | 2026 |
| Hauztor [?] | Flutter, Jaspr, dart_frog, PostgreSQL | 2026 |
| Geodetski portal [?] | Django | 2021 – now |
| [client] [?] | Flutter, Firebase, melos monorepo | 2025 |
| [client] — [app] & beacons | Flutter, BLE | 2023 – 2025 |
| [client] [?] | Flutter | 2023 – 2026 |
| [client] app | Flutter | 2023 |
| B2B web shop ([client]) | PHP, Docker | 2022 – 2023 |
| [client] — [app] (foot-scanning app, CameraX plugin) | Flutter, Kotlin | 2020 – 2022 |

### Volunteer — mountaineering

| Project | Stack | Years |
|---|---|---|
| Planinarski portal (mountaineering portal) | Django | 2022 – now |
| Hrvatske planine (Croatian mountain names) | Django | 2025 – now |
| Planinarska konzola (club console) | Django | 2026 |
| Planinarski menu | HTML | 2026 |
| [client] [?] | Flutter, maps | 2025 – 2026 |
| Club logbooks (HPK, HPO, GPO, VPP) | Django | 2022 – 2023 |

### Volunteer — developer community

| Project | Stack | Years |
|---|---|---|
| Karlovac Developers website | HTML | 2026 |
| STEMka (site, CMS, back end) | Next.js, Directus, Django | 2026 |
| Zagreb Developers — Drinkup & Spaces | HTML, Python | 2026 |
| Cromesh docs | HTML | 2026 |
| GDG Zagreb — DevFest 2022, 2023 & talk proposals | HTML, Flutter | 2022 – 2025 |
| Flutter Croatia — conference website | Flutter web | 2023 |

### Civic

| Project | Stack | Years |
|---|---|---|
| Uradi sad (activism app) | Flutter | 2026 |
| Susjed (neighbourhood app) [?] | Flutter, Django, Serverpod, Stream Chat | 2026 |
| [client] [?] | PHP | 2023 |

### Personal & R&D

| Project | Stack | Years |
|---|---|---|
| arilus.hr (this site) | Flutter web, shaders | 2023 – now |
| Satellite pet | Flutter, Flame | 2026 |
| CAD cleaner | Flutter desktop | 2026 |
| Django migration template | Django | 2026 |
| RelQuiz, Hackl, Jenzinema, RetroBloc, Materijali, PlanBee | Flutter | 2020 – 2026 |

## How I work with AI

> **Work in progress: AI-generated draft, not yet reviewed by Marko.** Generated from my repositories and commit history; details may be wrong. Please confirm with me before relying on them.

I build with AI coding agents every day, set up so they follow my engineering
standards instead of guessing.

### Tools

- **Claude Code** in the terminal: my main tool for design, coding, review and
  releases.
- **Claude** on the web and desktop: research, writing and documents.
- **Ollama**: local models for offline experiments.
- **Earlier:** Cursor rules and GitHub Copilot instructions on a few projects.

### Setup

- **Project instructions:** every active repository has its own `CLAUDE.md`
  (or `AGENTS.md`) describing the architecture, conventions, commands and
  pitfalls. There are about 20 across my projects.
- **Global rules:** cost and quality guardrails, such as which model does which
  job (small models for search, mid-size for code, large for architecture),
  at most 3 parallel subagents, and short reports.
- **Persistent memory:** per-project notes on decisions, feedback and context,
  so sessions don't start from zero.
- **Custom skills I wrote:**
  - a Material 3 design audit for Flutter apps
  - a design audit for Django + Bootstrap apps
  - a release flow: semver bump, Croatian release notes, tagged release
  - Railway infrastructure operations
  - visual explainers
- **Custom subagents:** a go_router navigation specialist and a UX/UI reviewer
  for Flutter.
- **Plugins:** Superpowers (brainstorm → plan → test-driven implementation →
  review), Google's Elephant–Goldfish document review, a Pyright language
  server.
- **MCP servers:** a Trello integration I built myself, plus Serverpod, Railway
  and per-project servers.
- **Hooks:** deterministic automation around the agent, such as terminal status,
  notifications when it needs me, and context reminders.

### Workflow

1. **Design first:** a short written design (`design/*.md`) before any code.
2. **Tests first:** failing tests, then the implementation, then the full
   suite, analyzer and formatter.
3. **Visual checks:** the agent renders the UI to images and inspects them
   before calling UI work done.
4. **Review:** an independent review pass before merging. Releases are scripted
   as skills.
5. **Human in charge:** I own architecture, product decisions and anything
   irreversible. The agent asks before deploys, pushes and deletions.

### Scale

- 340+ agent sessions in five months of 2026.
- Most of my 2025–2026 output was built this way.
