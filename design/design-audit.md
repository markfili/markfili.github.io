# arilus.hr — UI/UX design audit

| | |
|---|---|
| Audited commit | `1d4c7ed` (main, 2026-11-17) |
| Standards | WCAG 2.2 AA, web UX conventions, Material 3 where Flutter-specific |
| Surfaces | Home hero (wide "peaks" and narrow "orbit" layouts), content sheet (Stack, Work, AI), profile sheet, `web/index.html` shell, generated `profile.md` / `llms.txt` |
| Evidence | Code reading; contrast computed with a script; home page rendered to PNG at 1440×900 and 390×844 from a throwaway widget test (Font Awesome glyphs render as boxes there, which doesn't affect the layout or colour checks) |

## Scope (Phase 0 answers, recorded verbatim)

- **Main visitor:** "Both equally" (prospective clients and recruiters / hiring managers).
- **Where 'modernising legacy apps' sits:** "Lead offer". It becomes the headline service, with a dedicated page and a case study, and the business line under the name changes to match.
- **Public proof:** "Yes, in my repos".
- **Appetite for change:** "Keep the hero, fix the rest". The mountain scene and bubbles stay. Content, copy, accessibility and HTML fallbacks can change.

### Decisions (2026-11-17, after the first pass)

1. **Case studies:** "only use Geodetski portal, Planinarski portal and django template as current/latest examples; don't mention [client] and [client], the aim is to use AI to professionaly and with quality modernise legacy apps (no vibe coding but using tools like EGM to process the modernization step by step and leave the page looking modern with 1 to 1 functionalities and many bug fixes that went unnoticed for years)"
2. **URLs:** hash URLs ("works as is").
3. **Offer placement:** in the footer (direction 1).
4. **Legal lines:** stay visible.

### Changelog

| Pass | Fixed | New | Still open |
|---|---|---|---|
| 1 (`1d4c7ed`) | — | F1–F13 | all |
| 1b (uncommitted) | F1 (footer half), F4 (copyable email, mail fallback), F5, F7, F12 (`AColors`), F8 (partly: `index.html` updated by hand) | the orbit layout now reserves room for the footer and scrolls on landscape phones | F2, F3 (except `lang`), F6, F8 (generation), F9, F10, F11, F12 (unused schemes), F13 |
| 1c (uncommitted) | F10 for the sky (the animation is removed and the clouds are still), part of F1 (every bubble now shows a visible label, with a measured contrast of at least 7.6:1 at 1280×720, 1440×900, 1920×1080, 390×844 and 360×640) | jagged midpoint-displacement far ridges; the mountain playground at `?playground=mountains` is now permanent | F2, F3 (except `lang`), F6, F8 (generation), F9, F11, F12 (unused schemes), F13 |
| 1d (uncommitted) | rest of F1 for the footer: it now leads with the offer, has one primary action ("Talk about your app"), and puts the name and role below it (the role line is 14px, 7.3:1); F4 visible address (the email shows as text, with the copy icon on hover or focus and always on phones); F11 for the footer links (48px) | the footer is capped at 720px wide and the actions share one row on wide screens; a test keeps the perched bubbles clear of the footer | F2, F3 (except `lang`), F6, F8 (generation), F9, F11 (bubbles), F12 (unused schemes), F13 |
| 1e (uncommitted) | footer crowding: four lines, 70% scrim (5.1:1 worst case); bubble labels tappable | F1 reopened on purpose: the offer and primary action leave the home screen and move behind a Modernise bubble, which replaces Email. See docs/designs/home_footer.md. | F2, F3 (except `lang`), F6, F8 (generation), F9, F11 (bubbles), F12 (unused schemes), F13, F1 |

Because the hero stays, I spent no findings on replacing the canvas with a conventional scrolling page. I spent that budget on what the canvas costs (accessibility, crawlability, deep links) and on the copy around the hero.

---

## Summary

The hero scene is the best-built part of the site and should stay as it is. Placing the menu on mountain summits, with a fallback to an orbit on narrow screens, is careful, well-tested work (`lib/widgets/menu_layout.dart`), and its colours pass contrast wherever the bubbles actually land.

These are the three biggest problems:

1. **A first-time visitor can't tell what you sell or what to do next.** Six identical icon-only circles are labelled only by hover tooltips, which don't exist on touch screens. The only text offer is an 11px line. The email address is never shown as text. (F1, F4)
2. **The content works against your credibility.** Every page opens with "AI-generated draft, not yet reviewed", and the Work table shows eight `[?]` guess markers to visitors. A client deciding whether to trust you with their legacy system reads that as "he hasn't checked his own facts". (F2)
3. **To assistive technology and crawlers, the page is close to blank.** Flutter's semantics tree is never switched on, `lang="hr"` declares the wrong language for English content, and the sheets have no URLs. (F3, F6)

The fix with the most leverage is **one rewritten "who I am" block in the footer, plus one new Modernise page**. It names the lead offer in words, has a visible primary action ("Modernise your app →") and a visible email address, and the same words go into `Profile`, so `profile.md`, `llms.txt` and `index.html` stay in sync automatically. That one change addresses F1, F4, F8 and the whole positioning question.

---

## Phase 1 — Inventory

### Screens and surfaces

| Surface | Reached by | Has a URL | Notes |
|---|---|---|---|
| Home hero | `/` | yes | Single `MaterialApp.home` with no routes (`lib/main.dart:31-36`) |
| Content sheet: Stack + Toolbox | "Stack" bubble | no | `showContentSheet` (`lib/widgets/content_sheet.dart:18`) |
| Content sheet: Work + live sites | "Work" bubble | no | Footer `PagesList` calls the GitHub API |
| Content sheet: AI | "AI" bubble | no | |
| Profile sheet | "Profile for you & your AI" button | no | `lib/widgets/profile_sheet.dart` |
| LinkedIn / GitHub / Email | bubbles | external | `openUrl` |
| `profile.md`, `llms.txt` | `<link rel=alternate>`, profile sheet | yes | Generated by `tool/build_profile.dart` |
| `<noscript>` fallback | JavaScript disabled | yes | 3 lines (`web/index.html:88-92`) |

**Navigation graph:** one level deep, so there are no dead ends. Browser Back on an open sheet leaves the site instead of closing the sheet, because nothing is pushed to browser history.

### Theme

- `useMaterial3` is on (`lib/utils/theme.dart:339`), and the scheme is hand-written from Material Theme Builder (olive seed `#5d621c`).
- `MaterialApp` sets both `theme` (light) and `darkTheme`, with no `themeMode` (`lib/main.dart:33-34`). The sheets therefore follow the visitor's OS setting, while the hero is always dark.
- The medium- and high-contrast schemes, `ExtendedColor` and `ColorFamily` (`theme.dart:63-336, 350-386`) have **0 references**.
- No component themes are set.

### Hardcoded value census

| Value | Where | Role |
|---|---|---|
| `HeroScene.ink` `#E6FFFFFF`, `inkSoft` `#99FFFFFF` | `hero_scene.dart:120-123`, used by `main.dart` | Text on the hero (token) |
| `Colors.white12`, `Colors.white70` | `lib/utils/widgets.dart:38,41` | Bubble fill and icon. Duplicates the ink tokens under different names |
| `Color(0x1FFFFFFF)` | `main.dart:157` | Orbit ring |
| `AColors` (8 colours) | `main.dart:244-253` | **0 references.** Dead code |
| `fontSize: 11`, `56`, icon `14` | `main.dart:78,183,218` | Footer, wordmark, profile icon |
| Paddings `24/0/24/32` ×2, radius `8` | `content_sheet.dart:121`, `profile_sheet.dart:45`, `content_sheet.dart:100` | Sheet gutters (consistent) |

### Component census

| Role | Implementations |
|---|---|
| Primary action | Hero: none. Profile sheet: `FilledButton` (correct). Pages error state: `FilledButton` "Retry" |
| Navigation item | `ContactBadge` = `CircleAvatar` + `IconButton`, with a tooltip as the only label |
| Secondary action | `TextButton.icon` (hero footer), `OutlinedButton` (profile sheet), `TextButton` (pages error) |
| Bottom sheet | `showContentSheet` (max width 880) and `showProfileSheet` (max width 640). Same configuration otherwise |
| Loading | `CircularProgressIndicator` ×2 |
| Error | Plain text ×2. The pages list also has Retry and a fallback link (good) |
| Snackbar | 1 (prompt copied) |

---

## Phase 2–3 — Findings

### [S1] F1 The page doesn't say what you sell or what to do next
- **Where:** `lib/main.dart:82-117` (badges) and `lib/main.dart:190-224` (footer)
- **Evidence:** [verified in code + pixels]
  - The six bubbles are `IconButton`s labelled only by `tooltip` (`lib/utils/widgets.dart:40`). Tooltips appear on hover or long-press, so a phone visitor sees six unlabelled circles.
  - `layerGroup` for "Stack" and `wandMagicSparkles` for "AI" aren't conventional icons for those meanings.
  - The offer, "Mobile & web products, built end to end", is 11px `inkSoft` text, the smallest on the page, placed under three lines of legal business registration.
- **Principle:** Five-second test and value proposition above the fold. NN/g "mystery meat navigation". Every page needs one primary call to action.
- **Impact:** A client has to hover or guess to learn that you do Flutter or Django, and nothing mentions modernisation. A recruiter has to know that a briefcase icon means "Work". The page looks good but converts poorly.
- **Fix:** Rebuild the footer block as a short "who I am" stack: offer headline → one-line proof → primary action → visible email. Visible text labels belong on the bubbles at wide sizes (see the Phase 5 redesign).
- **Effort:** M

### [S1] F2 The draft notices and `[?]` markers undermine trust
- **Where:**
  - `lib/data/profile.dart:28-32` (`draftNotice`)
  - a blockquote at the top of each page in `assets/content/*.md`
  - `assets/content/work.md`, where **8 `[?]` markers** are visible in the tables
  - `lib/widgets/profile_sheet.dart:58-65`
  - `web/index.html:18,91`
- **Evidence:** [verified in code] The `<!-- TODO -->` editing note at the top of `work.md` is stripped before display. The `[?]` markers inside table cells are not, and its own TODO says to "check that each client agrees to be named publicly".
- **Principle:** Credibility (Stanford Web Credibility guidelines; Fogg). Don't publish unverified claims.
- **Impact:** The audience for "I'll modernise your legacy system" is buying care and correctness. A site that tells them five times that it hasn't been checked is a direct counter-signal, and naming clients without consent is a legal and reputational risk.
- **Fix:** Review the pages before shipping the new positioning. Remove the `[?]` rows or resolve them, then set `draftNotice = null`. This is copy work, not code work, and nothing else in the plan depends on it except **the Modernise page, which must not launch as a draft**.
- **Effort:** M (your time, not code)

### [S1] F3 Screen readers and crawlers get almost nothing
- **Where:** `lib/main.dart:16-20`, `web/index.html:2`, `web/index.html:88-92`
- **Evidence:** [verified in code]
  - There is no `SemanticsBinding.instance.ensureSemantics()`. Flutter web only builds its accessibility DOM after the user activates a hidden "Enable accessibility" placeholder, which most screen-reader users never find.
  - `<html lang="hr">` declares Croatian, while every visible string except the business registration lines is English, so screen readers read English text with Croatian pronunciation.
  - The `<noscript>` fallback has 3 lines and doesn't mention the offer.
- **Principle:**
  - WCAG 4.1.2 Name, Role, Value
  - WCAG 3.1.1 Language of Page
  - WCAG 3.1.2 Language of Parts (the Croatian registration lines)
- **Impact:** Blind visitors can't navigate. Search engines index the meta description and JSON-LD but no body copy, so "legacy app modernisation Croatia" can't match anything that is visible to them.
- **Fix:**
  - Call `ensureSemantics()` in `main()` (one line, small cost on a one-screen page).
  - Set `lang="en"`.
  - Wrap the Croatian lines in `Semantics` with `locale`. Flutter's `Text` can't set a language, so use the `Semantics` locale or accept the gap.
  - Grow `<noscript>` into a real HTML summary of the who-I-am block (see F8).
- **Effort:** S

### [S2] F4 The main conversion path (email) can fail silently and the address is never visible
- **Where:** `lib/utils/widgets.dart:6-18`, `lib/main.dart:93-97`
- **Evidence:** [verified in code] `openUrl` swallows failures and only logs them in debug builds. On a machine with no mail client configured, which is common on work laptops, clicking Email does nothing, and `info@arilus.hr` appears nowhere on the page as selectable text.
- **Principle:** Visibility of system status (Nielsen #1). Provide a recovery path for errors.
- **Impact:** Some of the most motivated visitors, the ones who decided to email you, hit a dead end.
- **Fix:** Show the address as text in the footer and make it selectable (`SelectableText`), with a copy action. When `launchUrlString` returns false, show a snackbar: "Couldn't open your mail app. info@arilus.hr copied."
- **Effort:** S

### [S2] F5 Footer text over the pink ridge fails contrast
- **Where:** `lib/main.dart:77-81` (`small`: 11px, `inkSoft` 60% white) and `lib/main.dart:197-209`
- **Evidence:** [verified in pixels] The footer sits on the near ridges, whose colour changes with viewport height.

  | Text | Background (sampled) | Ratio | Needed |
  |---|---|---|---|
  | Wide, "obrt za informatičke usluge" | `#826868` | **2.9:1** | 4.5 |
  | Narrow, the same line | `#9d736d` | **2.5:1** | 4.5 |
  | `ink` 90% on `#9d736d` (worst case for the role line) | | **3.7:1** | 4.5 |
  | Narrow, "Mobile & web…" on the dark ridge `#2a313b` | | 5.7:1 | pass |

- **Principle:** WCAG 1.4.3 Contrast (Minimum). Also, 11px is below the practical minimum for body copy on the web (12–14px).
- **Impact:** The only text that says who you are is the hardest text on the page to read, and which lines pass depends on screen height.
- **Fix:** Put a bottom scrim behind the footer, a vertical gradient from transparent to `skyTop` at about 85% opacity, over the bottom ~180px. It reads as dusk falling on the foreground ridge, so it fits the scene. Raise the text to 13px minimum and use `ink` for anything that matters.
- **Effort:** S

### [S2] F6 Sheets have no URLs: they can't be linked, bookmarked or closed with Back
- **Where:** `lib/main.dart:31-36` (no routes), `lib/widgets/content_sheet.dart:18`
- **Evidence:** [verified in code] Sheets are opened with `showModalBottomSheet` and nothing updates the URL.
- **Principle:** Web conventions: every view has a URL and Back undoes the last navigation (Jakob's Law).
- **Impact:** You can't send a prospect `arilus.hr/modernise`, which matters a lot once there's a lead offer to link from LinkedIn and proposals. On Android, the system Back gesture leaves the site.
- **Fix:** Use `go_router` with `/`, `/stack`, `/work`, `/ai`, `/modernise` and `/profile`, each opening its sheet over the hero via a page-based modal route. GitHub Pages needs either a `404.html` copy of `index.html` or hash URLs. Hash URLs are simpler, while path URLs read better on a business card.
- **Effort:** M

### [S3] F7 Light-mode visitors get cream sheets over a night scene
- **Where:** `lib/main.dart:33-34`
- **Evidence:** [verified in code] The app sets `theme: light()` and `darkTheme: dark()` with no `themeMode`, so the theme follows the OS. The hero is always dark (`HeroScene.skyTop`).
- **Principle:** Visual consistency. The brand direction is a dark, warm night scene.
- **Fix:** Set `themeMode: ThemeMode.dark`, or drop the light theme entirely. The dark sheet colours pass contrast (body text 13.3:1, links 10.1:1).
- **Effort:** S

### [S3] F8 The positioning text is duplicated in four places that can drift apart
- **Where:**
  - `Profile.role` / `business` / `services` (`lib/data/profile.dart`)
  - `web/index.html:8` (meta description), `:18,22` (JSON-LD), `:90` (`<noscript>`)
  - URLs repeated in `lib/main.dart:86-96` instead of using `Profile.linkedin` / `github` / `email`
- **Evidence:** [verified in code] `index.html` is hand-written, while `profile.md` and `llms.txt` are generated. `main.dart` has its own copies of three URLs.
- **Impact:** When the lead offer changes, the canvas, `profile.md` and `llms.txt` update, but Google's snippet and the JSON-LD keep saying "built end to end".
- **Fix:**
  - Have `tool/build_profile.dart` also rewrite marked regions of `index.html`: meta description, `<noscript>` body, and JSON-LD `description` / `knowsAbout` / `makesOffer`.
  - Extend the existing staleness test to cover them.
  - Use `Profile.*` for the badge URLs.
- **Effort:** S–M

### [S3] F9 Keyboard focus order and visibility
- **Where:** `lib/main.dart:139-235`
- **Evidence:** [inferred] In the `Stack`, the footer `TextButton` comes before the badges, so Tab reaches "Profile" before the menu. The default focus highlight on a `white12` circle over the dark sky is probably faint.
- **Principle:**
  - WCAG 2.4.3 Focus Order
  - WCAG 2.4.7 Focus Visible
  - WCAG 2.4.11 Focus Not Obscured (new in 2.2)
- **Fix:** Wrap the content in `FocusTraversalGroup` with an `OrderedTraversalPolicy` (menu, then primary action, then email, then profile). Give `ContactBadge` an explicit focus ring: a 2px `ink` outline.
- **Effort:** S. Needs a check in a real browser.

### [S3] F10 Motion ignores reduced-motion preferences
- **Where:** `lib/main.dart:120-125` (1.4s fade-in of the whole page), `:134` (650ms layout morph), `web/index.html:78` (1.4s splash crossfade)
- **Evidence:** [verified in code] Nothing reads `MediaQuery.disableAnimations` or `prefers-reduced-motion`.
- **Principle:** WCAG 2.3.3 Animation from Interactions (AAA). This is good practice rather than an AA failure.
- **Fix:** When `MediaQuery.disableAnimationsOf(context)` is true, set the durations to zero. Add `@media (prefers-reduced-motion: reduce) { #splash { transition: none } }`.
- **Effort:** S

### [S3] F11 Touch targets are 40×40px
- **Where:** `lib/widgets/menu_layout.dart:13` (`bubbleRadius = 20`), `lib/main.dart:215` (compact `TextButton`, 14px icon)
- **Evidence:** [verified in code] The bubbles pass WCAG 2.2's 2.5.8 Target Size (Minimum) of 24×24 but fall short of the 44–48px platform guideline.
- **Fix:** Raise `bubbleRadius` to 24. Check that the tests in `test/menu_layout_test.dart` still find enough summits.
- **Effort:** S

### [S4] F12 Dead code and duplicated tokens
- **Where:** `lib/main.dart:244-253` (`AColors`), `lib/utils/theme.dart:63-336, 350-386` (four unused contrast schemes and `ExtendedColor`), `lib/utils/widgets.dart:38,41` (`white12` / `white70` next to the `ink` / `inkSoft` tokens)
- **Fix:** Delete them, and move the bubble colours onto `HeroScene` tokens.
- **Effort:** S

### [S4] F13 Table borders are barely visible
- **Where:** `lib/widgets/content_sheet.dart:89`
- **Evidence:** [verified in code] `outlineVariant` on the sheet background is 1.8:1 in dark mode. Table borders are decorative, so this isn't a WCAG failure, but the six-column Stack table is hard to scan on a phone.
- **Fix:** Use `outline` and zebra-stripe the rows.
- **Effort:** S

### What's excellent (keep as the standard)

- **`MenuLayout`** places bubbles on real summits, avoids the brand area, and falls back to an orbit cleanly, all with tests. Bubble contrast measured **5.6–6.7:1** wherever they actually land.
- **The machine-readable profile** (`profile.md`, `llms.txt`, JSON-LD, the fit prompt) is ahead of most portfolio sites, and it's the right place to put the modernisation offer for AI-assisted procurement.
- **`PagesList`** covers loading, error with Retry and a GitHub fallback, and empty. That's complete state handling, and the content sheet should follow it.
- **The HTML splash** matches the first Flutter frame, which hides the canvas load well.

### Screenshots that would close open questions (priority order)

1. **Real Chrome with keyboard Tab** to confirm or rule out F9 (focus order and ring visibility).
2. **VoiceOver or NVDA pass after F3** to confirm the bubble labels and the reading order.
3. **iPhone Safari, light mode** to confirm F7 in the wild and the size of the 40px tap targets.
4. **Wide screen at 1280×720**, where the footer sits on the lightest ridge, to see the worst-case contrast for F5.

---

## Promoting legacy-app modernisation with the current "who I am" setup

Your "who I am" setup is one source of truth, `Profile` in `lib/data/profile.dart`. It feeds the hero footer, `profile.md` and `llms.txt`, and should also feed `index.html` (F8). So promoting the offer is mostly a **content change in `Profile`, plus one new content page and one visible action**.

### 1. Rewrite the positioning in `Profile`

```dart
static const role = 'Senior software engineer · Flutter · Django · AI-native';      // unchanged: recruiters scan this
static const business = 'I modernise legacy apps, then keep building on them';     // was: 'Mobile & web products, built end to end'

static const services = [
  'Modernising legacy apps: old Django and Python 2, aging Android (Java to '
      'Kotlin), outdated Flutter, upgraded in place with tests, without a '
      'risky rewrite',
  'Building mobile and web products end to end: Flutter apps, Django back '
      'ends, CI/CD, releases',
  'Fractional tech lead / CTO for startups and NGOs',
  'Setting up AI coding-agent workflows for development teams',
];
```

The role line stays for recruiters, and the business line now serves clients, which fits the "both equally" answer. "Then keep building on them" matters: it tells a client you don't just migrate and leave, and it ties the modernisation offer to the end-to-end offer.

### 2. Add a Modernise page with case studies from your own repos

Add a new `assets/content/modernise.md`, listed in `ContentAssets` and in `tool/build_profile.dart`. Structure:

1. **Who it's for:** "Your app works, but it's stuck on Python 2, Django 1.x, Java Android or an old Flutter, and every change is scary."
2. **How I do it:** audit → tests around current behaviour → upgrade in small, shippable steps → cutover with rollback. Your AI workflow belongs here as a differentiator: agents with project rules make large mechanical migrations fast, and tests keep them safe.
3. **Case studies.** Evidence found in your repos (confirm each one is publishable):

   > **Correction (pass 1b):** I first proposed five cases, including [client], [client] and [client], and said to leave out the migration template. Per decision 1, the page now uses only Geodetski portal, Planinarski portal and the template. The template is described but not linked or quoted, because its README says it contains server paths.

   | Case | From → to | Source |
   |---|---|---|
   | Geodetski portal | Python 2.7 / Django 1.11, Bootstrap 3+4, Leaflet 0.7 → Python 3.13 / Django 5.2, Bootstrap 5.3, Leaflet 1.9, Docker; cut over 2026-08-23 with the old app kept as the rollback | README, MIGRATION-NOTES.md |
   | Planinarski portal | Python 2.7 / Django 1.5 → Python 3.13 / Django 5.2, PostGIS, Docker; cut over 2026-07-27 | README, BUGS.md, template README |
   | Migration template | runbook, pre-flight checklist, a registry of 200+ upgrades and failure patterns, scaffolding; three apps moved with it | template README |

   The "bugs nobody noticed" section uses pre-existing bugs from geodetski's MIGRATION-NOTES.md §5 and "Bugs the port exposed".
4. **Call to action:** "Tell me what your app runs on → info@arilus.hr", plus a copy-able "legacy-fit" prompt (see §4).

**This page must be reviewed before launch, with no draft notice** (F2).

### 3. Make the offer visible on the hero

Don't add a seventh bubble. `_slotted` asserts an even count (`lib/widgets/menu_layout.dart:102`), and 7 × 225px pushes wide screens below 1575px into orbit mode. Make it the **primary text action in the footer** instead (Phase 5, screen A). That fixes F1 at the same time: the most important thing becomes the most readable thing.

### 4. Extend the AI-readable profile

- Add a second prompt next to `fitPrompt`, called `legacyPrompt`. It asks the visitor's AI to compare *their app's stack and age* with your modernisation cases and draft three questions for a first call. This is the client-side counterpart of the recruiter fit prompt, and it serves the "both equally" audience.
- In JSON-LD, add a `makesOffer` → `Service` named "Legacy application modernisation" to the `worksFor` Organization. Add "Legacy modernisation", "Python 2 to 3 migration", "Django upgrades" and "Java to Kotlin" to `knowsAbout`.
- Change the meta description and `<title>` to `arilus — legacy app modernisation · Marko Filipović`. "Arilus" alone ranks for nothing.

---

## Phase 4 — Design system (small, because the app is small)

**Tokens:** keep `HeroScene` as the hero token source and add:

```dart
// lib/widgets/hero_scene.dart
static const bubbleFill = Color(0x1FFFFFFF);   // replaces Colors.white12 and the ring colour
static const bubbleInk  = Color(0xB3FFFFFF);   // replaces Colors.white70
static const footerScrim = [Color(0x0007070A), Color(0xD907070A)];
```

**Type scale for the hero:** wordmark 56/300 (unchanged), offer headline `titleMedium` (16), body `bodyMedium` (14), legal lines `bodySmall` (12) and nothing smaller. Delete the `fontSize: 11` override.

**Theme:** use `themeMode: ThemeMode.dark`. Delete the unused contrast schemes, `ExtendedColor` and `AColors`.

**Components:**

| Role | Canonical | Replaces |
|---|---|---|
| Hero primary action | `FilledButton.tonal` on the scrim | nothing (it's missing today) |
| Hero secondary | `TextButton` in `ink` | the compact profile button |
| Menu item | `ContactBadge` with radius 24, a focus ring and an optional visible label | the current one |
| Sheet page | `showContentSheet` behind a route | the two `showModalBottomSheet` copies (they share one helper) |

**Rules:**

- The hero has exactly one filled button.
- No text on the hero below 12px.
- Any text on the hero sits on the scrim.
- Every sheet has a URL.

---

## Phase 5 — Redesign proposals

### A. Hero footer: the "who I am" block (direction 1, recommended)

The job of this block is to tell a client or recruiter, in five seconds, who you are, what you sell and how to reach you.

```
              ( bubbles on the summits, unchanged )
░░░░░░░░░░░░░░░░ scrim: dusk over the front ridge ░░░░░░░░░░░░░░░░
            Marko Filipović · Senior software engineer
           Flutter · Django · AI-native        ← role, ink, 14
     I modernise legacy apps, then keep building on them  ← titleMedium, ink
          [ Modernise your app → ]   info@arilus.hr ⧉     ← tonal button + selectable email
                Profile for you & your AI  ↓              ← TextButton
     obrt za informatičke usluge · vl. Marko Filipović · Zagreb   ← 12px, one line
```

- Your name and the offer come before the legal registration. The three legal lines collapse into one line at the bottom.
- On narrow screens it's the same stack and the email wraps under the button. It fits in the ~260px below the orbit (checked against the 390×844 render).

### A′. Direction 2: offer at the top, legal block unchanged

Put a single offer line plus the button in the empty sky *above* the logo, and leave the footer as it is. This gives the offer more prominence and keeps the bottom calm. The trade-off is that it breaks the centred logo-and-wordmark composition and competes with the brand. I prefer direction 1.

### B. Labelled bubbles on wide screens

At peak-mode widths there's room for a 12px label under each bubble ("Stack", "Work", "AI", "Email"…), on the sky and above the ridge. This fixes the mystery-meat problem without changing the scene. Orbit mode stays icon-only, but `ensureSemantics()` gives each bubble an accessible name. **Validate with users** whether the labels clutter the scene. I'm confident they help, but less sure how they look.

### C. Modernise sheet

Use the content sheet as it is, and add a pinned bottom bar inside it with `[Email me about your app]` and `[Copy legacy-fit prompt]`. Long case-study pages should never put the call to action only at the end. The same bar would suit Work.

---

## Phase 6 — Implementation plan

Each step leaves the site shippable.

| # | Step | Files | Effort | Risk | Verify |
|---|---|---|---|---|---|
| 1 | Clean-up: delete `AColors`, the unused schemes and `ExtendedColor`; `themeMode: dark`; badge colours to tokens; `Profile.*` URLs in `main.dart` (F7, F12) | `main.dart`, `theme.dart`, `widgets.dart`, `hero_scene.dart` | S | low | `flutter analyze`, tests, PNG render looks identical |
| 2 | Accessibility baseline: `ensureSemantics()`, `lang="en"`, reduced motion, focus order and ring, bubble radius 24 (F3, F9, F10, F11) | `main.dart`, `widgets.dart`, `menu_layout.dart`, `index.html` | S | low (`menu_layout` tests) | Tab through it in Chrome, VoiceOver pass |
| 3 | Content review: resolve the `[?]` markers, client consent, drop the draft notices (F2) | `assets/content/*`, `profile.dart` | M (your time) | none | Regenerate the profile, profile test passes |
| 4 | Positioning: new `business` and `services`, `modernise.md`, `legacyPrompt` | `profile.dart`, `assets/content/modernise.md`, `content_sheet.dart`, `tool/build_profile.dart` | M | low | `profile.md` / `llms.txt` regenerated |
| 5 | Footer redesign A: scrim, offer, primary action, selectable email, mail fallback (F1, F4, F5) | `main.dart`, `widgets.dart` | M | medium (layout on short screens) | Renders at 1440×900, 1280×720, 390×844 and 360×640; re-sample contrast |
| 6 | Generated HTML: meta, title, `<noscript>`, JSON-LD `makesOffer` from `Profile` (F8) | `tool/build_profile.dart`, `web/index.html`, profile test | S–M | low | Google Rich Results test, `view-source` |
| 7 | Routes: `go_router` with one URL per sheet, plus a `404.html` copy for GitHub Pages (F6) | `main.dart`, new `router.dart`, deploy | M | medium (Pages routing) | Deep link `/modernise` works on the deployed site; Back closes the sheet |
| 8 | Labelled bubbles on wide screens (B), Modernise sheet action bar (C) | `main.dart`, `content_sheet.dart` | S–M | low | Visual check |

Steps 3 and 4 are what promote modernisation, and step 5 makes it visible. If you only do three things, do **3 → 4 → 5**.

### Open questions

1. Can **Geodetski portal**, **Planinarski portal**, **[client]** and the **[client]** null-safety work be named publicly, or should some be anonymised ("a national surveying association portal")?
2. Do you want **path URLs** (`arilus.hr/modernise`, which needs a `404.html` trick on GitHub Pages) or **hash URLs** (`arilus.hr/#/modernise`, which just work)?
3. Should the footer use **direction 1** (offer in the footer) or **direction 2** (offer above the logo)?
4. Should the Croatian legal lines stay, or move into the profile sheet and `profile.md` only? The *obrt* registration may need to stay visible for legal reasons. Please confirm.
