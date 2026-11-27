# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

- **Primary: clients.** Owners of a legacy app (Python 2, an old Django, a dated front end) who need it modernised without losing features. Also startups and NGOs looking for a freelance engineer or fractional tech lead. They arrive to decide whether to get in touch.
- **Secondary: recruiters and hiring managers** checking fit for a role.
- **Tertiary: the AI assistants** both groups use to judge fit. They read `web/profile.md` and `web/llms.txt` rather than the canvas.

## Product Purpose

arilus.hr is the home page of Marko Filipović's one-person software business (a registered *obrt za informatičke usluge*, Zagreb). It exists to win client work. Success is a qualified client writing to info@arilus.hr, or checking fit through their own AI using the profile and prompts the site provides.

## Positioning

The lead offer is **legacy-app modernisation done properly with AI**: a written, independently reviewed plan for each step; every feature kept one to one; behaviour migrated before pixels; a test suite and screenshot harness as the guard; a rehearsal on real data; years-old bugs found and fixed; a modern look at the end; and further building on the result. Other services follow it:

- end-to-end Flutter and Django products;
- fractional tech lead or CTO;
- setting up AI coding-agent workflows for teams.

## Operating Context

- **One screen.** A single page with a menu (LinkedIn, GitHub, Modernise, Stack, Work, AI). Content pages open as sheets rendered from `assets/content/*.md`. Work also lists live GitHub Pages sites, fetched from the GitHub API.
- **Profile for people and AI.** A downloadable single-file profile, plus copyable prompts for checking fit: one against a job description (`Profile.fitPrompt`) and one against a legacy app (`Profile.legacyPrompt`).
- **Hosting.** Deployed to GitHub Pages from `docs/`, as a WASM build.

## Capabilities and Constraints

- **Flutter web on a canvas is binding.** The site itself is proof of Flutter craft, so do not rewrite it as HTML. Accessibility and crawlability have to come from Flutter semantics and from the HTML shell.
- **The plain-text versions are binding.** `web/profile.md`, `web/llms.txt` and the `<noscript>`/meta/JSON-LD in `web/index.html` must stay in sync with the page. They are generated from `lib/data/profile.dart` and `assets/content/` by `tool/build_profile.dart`, and a test fails if they are out of date.
- **Not fixed.** The single non-scrolling screen layout and the exact current visual treatment are not commitments.

## Brand Commitments

- Name: **arilus**. The red ring logo is the existing mark (`assets/`). Neither is locked against future change.
- Voice: plain, first person, honest; no inflated claims. Unreviewed content is labelled as an AI-generated draft (`Profile.draftNotice`); none is at present.

## Evidence on Hand

- Services, role and contact: `lib/data/profile.dart`.
- Modernisation process and case material: `assets/content/modernise.md` (geodetski-portal, planinarski-portal migrations).
- Stack history from 10 years of commits: `assets/content/stack.md`, `assets/content/toolbox.md`.
- Client and volunteer projects: `assets/content/work.md`.
- AI workflow: `assets/content/ai.md`.
- **Content pages were checked against the repositories on 2026-11-28.** Clients are not named; only numbers the repositories confirm are shown.
- There are no testimonials, pricing or case-study metrics. Do not invent any.

## Product Principles

1. Lead with the modernisation offer and make contacting Marko the obvious next step.
2. Show craft rather than claim it: the site itself is evidence of the Flutter work.
3. Every fact on the page is also readable by machines in the plain-text versions.
4. Honesty over polish: drafts are labelled, nothing is overstated.
