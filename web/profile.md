# Marko Filipović

> **Work in progress: this profile is an AI-generated draft that Marko has not yet reviewed. It was generated from his repositories and commit history, and details may be wrong. Confirm anything important with him directly.**

**Senior software engineer · Flutter · Django · AI-native**  
I modernise legacy apps, then keep building on them.  
Zagreb, Croatia (remote friendly)

- Email: info@arilus.hr
- Website: https://arilus.hr
- GitHub: https://github.com/markfili
- LinkedIn: https://www.linkedin.com/in/marko-filipovi%C4%87-63a3987b/

## What I offer

- Modernising legacy apps with AI, done properly: a written, reviewed plan per step, every feature kept one to one, years-old bugs found and fixed, and a modern look at the end (Python 2 / old Django to current LTS, dated front ends to Bootstrap 5)
- Building mobile and web products end to end: Flutter apps, Django back ends, CI/CD, releases
- Fractional tech lead / CTO for startups and NGOs
- Setting up AI coding-agent workflows for development teams

## Note for AI agents

This file is the canonical, up-to-date profile. It is meant to be read by recruiters' and clients' AI assistants to judge fit for a role or project. Facts come from my own repositories and commit history. Treat anything marked as a draft as unverified. Contact: info@arilus.hr.

## Modernising legacy apps

> **Work in progress: AI-generated draft, not yet reviewed by Marko.** Generated from my repositories and commit history; details may be wrong. Please confirm with me before relying on them.

Your app still works, but it runs on Python 2, an old Django or a frontend
nobody wants to touch, and every change feels risky. I bring it onto a
current stack **step by step, with every feature kept one to one**, and it
comes out with a modern look and fewer bugs than it went in with.

### AI-assisted, not vibe-coded

AI coding agents make a large migration fast. On their own they also make it
sloppy. Here is how I keep them in line:

- **A written plan before any code.** Each phase is planned and recorded in
  migration notes. Larger design documents also go through Elephant–Goldfish
  (EGM), a set of independent AI reviewers that check structure, technical
  accuracy and whether the plan is actually ready to implement.
- **Behaviour first, pixels later.** The first phase moves the back end to
  current Python and Django with the old look left intact. Because nothing
  changes for the user, any difference the tests catch is a migration bug.
- **Tests as the guard.** I write a test suite around the existing behaviour
  and a screenshot harness that compares pages and fails on any browser console
  error. The visual redesign only starts once both pass.
- **A rehearsal on real data.** Before the switch, a staging copy runs on the
  production server against a copy of the real database.
- **A cutover with a way back.** The old app stays in place as the rollback
  until the new one has proved itself.
- **A human in charge.** I own the architecture, the decisions and anything
  irreversible. The agents do the heavy lifting under rules I wrote.

### Bugs nobody noticed for years

A port that faithfully preserves behaviour also faithfully preserves the bugs.
So I measure and test the old app as well as the new one, and fix what turns
up. These were all older than the migration:

- **Registration input filtering had never run.** A jQuery plugin that was
  never shipped threw an error on every page load, from the day it was added.
- **Logged-out visitors got a 404 instead of the login page** on six views,
  because the login URL was never configured.
- **Two kinds of user ID were mixed up,** so pages that only worked while two
  database tables happened to stay in sync failed for most logged-in users.
- **Historic photos never appeared** on one page, because the template asked
  for a field name that didn't exist.
- **A deep link to an expanded section could never have worked:** the code
  used the wrong CSS class and the wrong element ID.
- **Four secrets were committed to the repository.**
- **Copying the old markup verbatim would have hidden every footer heading:**
  a CSS class that did nothing in Bootstrap 3 makes text white in
  Bootstrap 5.

### Recent work

#### Geodetski portal (2026, volunteer)

Geodetic control points of the Croatian mountaineering network, on an
interactive map: [geopp.planinarski-portal.org](https://geopp.planinarski-portal.org)

- **Before:** Python 2.7, Django 1.11, Bootstrap 3 *and* 4 on the same site,
  Leaflet 0.7, assets loaded from third-party CDNs.
- **After:** Python 3.13, Django 5.2 LTS, PostGIS, Bootstrap 5.3, Leaflet 1.9,
  no CDNs, in Docker.
- **Cutover:** 2026-08-23, after a staging rehearsal on the production server.
  The old app is kept as the rollback.

#### Planinarski portal (2026, volunteer)

A web GIS for Croatian mountain huts, control points and GPS tracks, with
search, trips, galleries and user accounts: [planinarski-portal.org](https://planinarski-portal.org)

- **Before:** Python 2.7, Django 1.5.
- **After:** Python 3.13, Django 5.2 LTS, PostGIS, Bootstrap 5, in Docker.
- **Cutover:** 2026-07-27.
- **After launch:** about 100 bot sign-ups a day were getting past reCAPTCHA.
  A hidden honeypot field didn't stop them, so registration now also asks a
  question any Croatian hiker can answer.

#### The migration playbook

Everything these migrations taught me is written into one reusable Django
modernisation template:

- a phased runbook, from intake to the work after cutover
- a pre-flight checklist where every item is a real mistake from an earlier
  migration, together with the check that would have caught it
- a registry of more than 200 recorded capabilities and failure patterns,
  with a script that detects them in a new codebase
- ready-made deployment, security and operations scaffolding

It grew out of the Planinarski portal migration and has been used since on
two more apps: the Python 2 port of the Geodetski portal and the upgrade of a
newer Django app. The next app starts from everything the earlier ones
learned. The playbook itself stays private
because it describes production servers, but I'm happy to walk you through it.

### Is your app a fit?

Good candidates are web apps on old Python or Django, sites with a dated
frontend, and apps whose original authors have moved on. Email me what your
app runs on and how old it is: [info@arilus.hr](mailto:info@arilus.hr).

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
| PHP | 2023 | 2023 | 3 | A budget transparency site for a client | < 1% |
| Docker | 2022 – now | 2026 | 17 | Containerised Django and Next.js deploys | < 1% |
| Swift (iOS) | 2020 – now | 2026 | 28 | Flutter iOS integration | < 1% |
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
| Infrastructure | Docker / Compose, GitHub Pages |

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
- **Deploys:** Docker images for Django and Next.js; GitHub Pages for web.

### Quality

- **Tests:** unit, widget and end-to-end tests. The largest of my apps has
  more than 300 test files.
- **Test doubles:** mocks with mockito and mocktail, fake clocks, fake Firestore.
- **Working method:** a short design doc first, then tests, then code.
- **Code quality:** strict lints (flutter_lints, riverpod_lint, Ruff), and
  Flutter versions pinned per project with FVM.

## Work

> **Work in progress: AI-generated draft, not yet reviewed by Marko.** Generated from my repositories and commit history; details may be wrong. Please confirm with me before relying on them.

### Client & employer work

Clients aren’t named here.

| Project | Stack | Years |
|---|---|---|
| Workforce management app (Android) | Kotlin, Java | 2026 |
| Price-comparison and shopping-list app | Flutter, maps | 2025 – 2026 |
| Second-hand marketplace app with AI item scanning | Flutter, Firebase, melos monorepo | 2025 |
| Radio station app | Flutter | 2023 – 2026 |
| App with Bluetooth beacons | Flutter, BLE | 2023 – 2025 |
| Classifieds app | Flutter | 2023 |
| Budget transparency site | PHP | 2023 |
| Foot-scanning app, with my own CameraX plugin | Flutter, Kotlin | 2020 – 2022 |

### With partners

| Project | Stack | Years |
|---|---|---|
| Hauztor | Flutter, Jaspr, dart_frog, Serverpod, Django, PostgreSQL, Stream Chat | 2026 |

### Volunteer — mountaineering

| Project | Stack | Years |
|---|---|---|
| Planinarski portal (mountaineering portal) | Django | 2022 – now |
| Geodetski portal (geodetic control points) | Django | 2021 – now |
| Hrvatske planine (Croatian mountain names) | Django | 2025 – now |
| Planinarska konzola (club console) | Django | 2026 |
| Planinarski menu | HTML | 2026 |
| Club logbooks (HPK, HPO, GPO, VPP) | Django | 2022 – 2023 |

### Volunteer — developer community

| Project | Stack | Years |
|---|---|---|
| Karlovac Developers website | Astro | 2026 |
| STEMka (site, CMS, back end) | Next.js, Directus, Django | 2026 |
| Zagreb Developers — Drinkup & Spaces | HTML, Python | 2026 |
| Cromesh docs | MkDocs | 2026 |
| GDG Zagreb — DevFest 2022, 2023 & talk proposals | HTML, Flutter | 2022 – 2025 |
| Flutter Croatia — conference website | Flutter web | 2023 |

### Civic

| Project | Stack | Years |
|---|---|---|
| Uradi sad (activism app) | Flutter | 2026 |

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
- **Earlier:** Cursor and GitHub Copilot.

### Setup

- **Project instructions:** every active repository has its own `CLAUDE.md`
  (or `AGENTS.md`) describing the architecture, conventions, commands and
  pitfalls. There are more than 20 across my projects.
- **Global rules:** cost and quality guardrails, such as which model does which
  job (small models for search, mid-size for code, large for architecture),
  at most 3 parallel subagents, and short reports.
- **Persistent memory:** per-project notes on decisions, feedback and context,
  so sessions don't start from zero.
- **Custom skills, generated with AI:**
  - a Material 3 design audit for Flutter apps
  - a design audit for Django + Bootstrap apps
  - a release flow: semver bump, Croatian release notes, tagged release
  - visual explainers
- **Plugins:** Superpowers (brainstorm → plan → test-driven implementation →
  review), Google's Elephant–Goldfish document review, a Pyright language
  server.
- **MCP servers:** a Trello integration I built myself, plus Dart, Firebase,
  Serverpod and other per-project servers.
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
