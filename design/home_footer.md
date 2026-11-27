# Home page footer: four lines, a Modernise bubble, and tappable bubble labels

*   **Author:** Marko Filipović (the site's owner; "I" and "the owner" in this document both mean him)
*   **Status:** Proposed
*   **Date:** 2026-11-19

--------------------------------------------------------------------------------

## Overview

arilus is Marko Filipović's one-person software business in Zagreb. arilus.hr is its website, a Flutter web app deployed to GitHub Pages.

The home page (`lib/main.dart`) is one dark screen with:

*   a mountain landscape painted in code (`lib/widgets/hero_scene.dart`)
*   the logo and the "arilus" wordmark
*   six round menu bubbles, each with a short text label beside it

The bubbles have two layouts, both computed in `lib/widgets/menu_layout.dart`:

*   **Peak mode** (wide, tall screens): each bubble sits on its own mountain summit, with its label above it.
*   **Orbit mode** (narrow or short screens: under 1350 px wide for six bubbles, or under 520 px tall): the bubbles sit on a ring around the logo, with each label pointing outward.

At the bottom, the `_WhoIAm` widget (`lib/main.dart:266`) draws a dark gradient. On it sit the offer, three buttons, the name, the role and the legal line. This is "the footer".

This design makes three changes:

1.  The footer shrinks to four lines that say who I am and how to reach me.
2.  The Email bubble is replaced by a **Modernise** bubble, so the offer is reached from the bubbles and no longer stated in the footer.
3.  Each bubble's label becomes part of the bubble's tap target, so tapping the word does the same as tapping the circle.

## The Problem

The footer covers too much of the landscape. I measured it by rendering `MyApp` in a widget test at each screen size and reading the footer's box:

| Screen | Footer height | Share of the screen |
|---|---|---|
| 1440×900 (peak) | 236 px | 26% |
| 1280×720 (orbit) | 236 px | 33% |
| 601×800 (orbit) | 316 px | 40% |
| 412×915 (orbit) | 404 px | 44% |
| 390×844 (orbit) | 404 px | 48% |
| 844×390 (orbit, scrolls) | 236 px | 61% |
| 360×640 (orbit, scrolls) | 432 px | 68% |

The cause is the amount of content, not only the shading. The footer holds five layers:

1. the offer line ("I modernise legacy apps, then keep building on them")
2. three buttons: a filled **Talk about your app**, the email address as a copy button, and **Profile for you & your AI**
3. the name
4. the role line
5. the legal line ("obrt za informatičke usluge · vl. Marko Filipović · Zagreb")

On phones, the offer and the three buttons wrap onto several rows. At 390×844 they take 240 px between the top of the offer and the name. To keep all this readable over the light far ridges, the gradient goes from transparent to 85% black within the top 45% of the footer's height. Because the gradient stops are fractions of the height, a taller footer means more of the landscape is darkened.

The layout's guess for the footer's height is also wrong today. `MenuLayout.footerReserve` reserves 380 px below 600 px wide and 260 px above. The measured footer is 24 px taller at 390×844, 52 px taller at 360×640, and 56 px taller at 601×800.

There are two further problems with what the footer *means*:

*   **One action is mislabelled.** "Talk about your app" opens an 838-word article (`assets/content/modernise.md`), not a conversation.
*   **Email appears in four places, with different behaviour.** The Email bubble opens mail, and copies the address if that fails. The footer button only copies. The Modernise sheet and the profile sheet each have their own.

And one problem with the bubbles: **a bubble's label can't be tapped.** The label is 12 px text drawn outside the 40 px circle. Flutter only passes a tap to a child that lies inside its parent's box, so tapping the word does nothing. On a phone, the word is what people aim at.

**Proposed solution:** give each part of the page one job.

*   **The bubbles are places to go:** LinkedIn, GitHub, **Modernise**, Stack, Work, AI. Modernise takes the Email bubble's slot. There are still six bubbles, so the layout rules that depend on the count stay valid. Each bubble's label opens the same thing as its circle.
*   **The footer says who I am and how to reach me:**
    *   name
    *   role
    *   one row with the email (opens mail, copies if that fails) and "Profile for you & your AI", as text buttons without a fill
    *   the legal line

    The offer line and the "Talk about your app" button leave the home screen. The offer is stated in the Modernise article, and that article keeps its own mail and copy-prompt buttons.
*   **The shading shrinks** to a short fade plus a flat 70% black behind the four lines.

## Goals

*   **Less mountain covered.** At every size in the table above, the new footer is shorter than today's measured height. Its exact heights are measured once the footer is built, and become the new `footerReserve` values.
*   **Four lines, one weight of action.** The footer contains only:
    *   name
    *   role
    *   one row with the email and "Profile for you & your AI" as text buttons without a fill (the row may wrap on phones)
    *   the legal line

    It has no filled button.
*   **The email has one place and one behaviour.** Clicking the footer email opens the visitor's mail app. If that fails, it copies the address and shows "Copied info@arilus.hr".
*   **The offer can be reached from the bubbles.** A Modernise bubble, in the Email bubble's slot, opens the Modernise article. It has its own icon (not the magic wand the AI bubble uses), and its label stays on screen at 360 px wide.
*   **Labels are tappable.** Tapping or clicking a bubble's label does the same as its circle, for all six bubbles. Screen readers still announce each bubble once, and keyboard focus still has one stop per bubble.
*   **The text stays readable.** All footer text has at least 4.5:1 contrast in the worst case. Decisions explains the target and the worst case.
*   **Bubbles never cover the footer.** In both modes, at every size in the table, no bubble or label overlaps the footer's box (fade strip included). In orbit mode, the wordmark ends at least 8 px above the footer's box. The legal line can be seen, or reached by scrolling.
*   **The tests show it.** The existing layout and profile tests are updated and pass, and new tests cover the footer height, contrast, email and label taps. Screenshots at 1440×900, 390×844 and 844×390 are taken before and after.

## Non-Goals

*   **Merging Modernise into Work.** They stay separate pages: Work is past projects, Modernise is the current offer with its own buttons.
*   **Renaming or reordering the other bubbles** (LinkedIn, GitHub, Stack, Work, AI).
*   **Changing the painted scene or the palette** in `hero_scene.dart`.
*   **Rewriting the Modernise article** or its action block (`lib/widgets/modernise_actions.dart`). Its "Talk about your app" heading stays, because there it sits above a mail button that does start a conversation.
*   **Translating the legal line.**
*   **Measuring the footer's height while the page runs.** A fixed height for each breakpoint is enough.
*   **Changing the generated profile files** (`web/profile.md`, `web/llms.txt`, `web/index.html`). `Profile.business` stays, because `Profile`'s markdown builders read it (`lib/data/profile.dart:97`, `:135`). Only the home page stops showing it.
*   **Making the legal line legally complete.** The text stays as it is. Croatia's e-commerce law (*Zakon o elektroničkoj trgovini*, art. 6) may require more: address, OIB, register entry. That is a separate follow-up, to check with an accountant.
*   **A separate copy-to-clipboard control for the email.** The mail fallback already copies.

## Decisions Made While Drafting and Reviewing

*   **The offer leaves the home screen on purpose.** [`design/design-audit.md`](design-audit.md) is the owner's earlier UI/UX audit of this site. Its top finding, F1, is "a first-time visitor can't tell what you sell or what to do next". Its fix 1d closed F1 by putting the offer at the front of the footer. This design reopens F1. The owner accepts this: the offer is reached through the Modernise bubble, and the audit gets a note saying so.
*   **Footer height: a fixed reserve for each breakpoint, guarded by a test.** `MenuLayout.footerReserve` is set to the new footer's measured height. A new test fails if the real footer is ever taller.
*   **Bubble label "Modernise", icon `FontAwesomeIcons.seedling`.** The label length is limited by width:
    *   Labels are 12 px DM Mono with 0.4 letter spacing, so each character is 7.6 px wide, measured. "Modernise" is 68 px.
    *   In orbit mode, bubble index 2's label sits to the right (`orbitLabelSide(2, count: 6)`), starting about 305 px from the left on a 390 px phone.
    *   "Modernise your app" (137 px) would run off the screen.
*   **Contrast target: 4.5:1** (WCAG AA for normal text), measured against the **lightest** colour the footer can sit over: the mist, `HeroScene.mist` = `#C9BCBE`, darkened by the scrim.
    *   The two text colours are `HeroScene.ink` (90% white, `#E6FFFFFF`) and `HeroScene.inkSoft` (60% white, `#99FFFFFF`).
    *   At 70% black, `inkSoft` reaches 5.1:1. At 65% it is 4.5:1, with no margin.
    *   The film-grain overlay painted by `hero_scene.dart` is ignored. It is faint, and the scrim sits on top of it.
*   **The scene is not tied to the gradient.** The uncommitted diff of `lib/widgets/hero_scene.dart` against commit `1d4c7ed` doesn't mention the footer, scrim or gradient. Nothing there needs re-tuning.
*   **No copy icon next to the footer email.** Clicking the address opens mail, or copies when mail can't open. A second control would need its own hover and focus handling for no new capability.
*   **Each bubble is one widget covering its circle and its label.** The badge's box is centred on the bubble and big enough for a label on any side, so the layout maths and the animations stay as they are (Technical Plan, point 4).

## Open Questions

*   None.

## Critical User Journeys (CUJs)

### CUJ 1: A client looks for the offer

*   **Given**: A visitor on a desktop browser (1440×900) opens arilus.hr. All six bubbles sit on peaks, and the third from the left reads "Modernise" with a seedling icon.
*   **When**: They click the Modernise bubble, or the word "Modernise" above it.
*   **Then**: The Modernise sheet opens with the "Modernising legacy apps" article. Its action block ("Talk about your app") offers "Email me about your app" and "Copy a prompt for your AI", as it does today.

### CUJ 2: Someone wants to email me

*   **Given**: A visitor on any screen size, with the footer showing `info@arilus.hr` as text.
*   **When**: They click or tap the address.
*   **Then**: Their mail app opens a new message to `info@arilus.hr`. If no mail app can open (for example, a desktop with no mail client set up), the address is copied and a snackbar says "Copied info@arilus.hr".

### CUJ 3: A hiring manager hands the profile to their AI

*   **Given**: A visitor on a portrait phone (390×844). The bubbles circle the logo, and the footer shows name, role, the email and profile row, and the legal line.
*   **When**: They tap "Profile for you & your AI".
*   **Then**: The profile sheet opens ("Am I the right fit?"), as it does today.

### CUJ 4: Landscape phone

*   **Given**: A visitor on a landscape phone (844×390), too short for the brand and the footer together.
*   **When**: The page loads.
*   **Then**: The page scrolls. The wordmark ends at least 8 px above the top of the footer's box (the top of the fade strip). The legal line can be reached by scrolling.

### CUJ 5: Tapping a label on a phone

*   **Given**: A visitor on a portrait phone (390×844), with the bubbles in orbit mode.
*   **When**: They tap the word "Work" next to the briefcase bubble.
*   **Then**: The Work sheet opens, the same as tapping the circle.

## Technical Plan (Architecture)

### What the page looks like after the change

```text
 ┌──────────────────────────────────────────────────────────────┐
 │                 (sky, logo, "arilus")                        │
 │  LinkedIn    GitHub   Modernise      Stack     Work     AI   │ ← labels, tappable
 │   (in)       (gh)      (🌱)          (st)     (wk)    (ai)   │ ← bubbles on peaks
 │  /\/\    /\/\/\   /\  /\/\    /\/\/\/\   /\/\/\   /\/\       │   (peak mode)
 │ ░░ 32 px fade: transparent → 70% black ░░░░░░░░░░░░░░░░░░░░ │ ← footer's box starts
 │▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ 70% black from here down ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓│
 │                    Marko Filipović                           │  titleSmall, ink
 │   Senior software engineer · Flutter · Django · AI-native    │  bodyMedium, inkSoft
 │        info@arilus.hr        ↓ Profile for you & your AI     │  text buttons, 48 px tall
 │   obrt za informatičke usluge · vl. Marko Filipović · Zagreb │  12 px, inkSoft
 └──────────────────────────────────────────────────────────────┘
```

### Component changes

```text
 lib/main.dart
 ├─ MyHomePage.build
 │   ├─ badges[2]: ContactBadge(Email → _email)  ──►  ContactBadge(seedling, "Modernise" → _showModernise)
 │   ├─ badge AnimatedPositioned: 40×40 box at anchor  ──►  ContactBadge.boxSize box centred on anchor
 │   └─ Align(bottom): _WhoIAm(key: footerKey, onEmail: _email, onProfile)    (onModernise, onCopyEmail removed)
 ├─ _WhoIAm            5 layers → 4 lines; gradient → fade strip + flat scrim
 └─ _CopyEmail         replaced by a plain TextButton calling onEmail

 lib/utils/widgets.dart
 └─ ContactBadge       40×40 + label overflowing  ──►  fixed box holding circle + label slot; label tappable

 lib/widgets/menu_layout.dart
 └─ footerReserve(size)   380 / 260  ──►  new measured heights
```

**1. The Email bubble becomes Modernise.** In `MyHomePage.build`, the third entry of `badges` (index 2) changes:

*   from: the envelope icon, label "Email", `onPressed: _email`
*   to: `FontAwesomeIcons.seedling`, label "Modernise", `onPressed: _showModernise`

The list keeps six entries in the same order. `MenuLayout.peakAnchors`, `orbitAnchors`, `orbitLabelSide` and `useOrbit(count: 6)` behave as they do now. `_showModernise` is unchanged and gets a new caller.

**2. The footer becomes four lines.** `_WhoIAm` drops the offer `Text`, the `FilledButton` and the spacing around them. Its content `Column` becomes:

| Row | Widget | Style | Notes |
|---|---|---|---|
| 1 | `Text(Profile.name)` | `titleSmall`, `HeroScene.ink` | unchanged |
| 2 | `Text(Profile.roleUnbreakable)` | `bodyMedium`, `HeroScene.inkSoft` | unchanged; wraps only between "·" items |
| gap | 8 px (`Insets.medium`) | | was 16 px |
| 3 | `Wrap` (centred, spacing 8, run spacing 0) of the email `TextButton` and the "Profile for you & your AI" `TextButton.icon` | the existing `quiet` style: no fill, `HeroScene.ink`, 48 px minimum height | one row on desktop; may wrap to two rows on narrow phones |
| gap | 4 px (`Insets.small`) | | |
| 4 | `Text(_WhoIAm.legal)` | the existing `small` style (12 px, `inkSoft`) | text unchanged |

The content padding changes from 48 px on top to 0. The 48 px was the fade zone, and the fade becomes its own strip (point 3). The 720 px maximum width stays.

**3. The gradient becomes a fade strip plus a flat scrim.** Today one `LinearGradient` covers the whole footer. Its stops are fractions, so it stretches with the footer. The new version is a `Column` of two parts:

*   a full-width strip 32 px tall, with a vertical gradient from transparent (`0x0007070A`) to the scrim colour, so the mountains fade out instead of being cut off
*   the four rows on a flat background of the scrim colour

The scrim colour is `0xB307070A`: the sky colour `skyTop` at 70% opacity. Decisions gives the reason (5.1:1 worst case).

**4. A bubble and its label become one widget.** `ContactBadge` (`lib/utils/widgets.dart`) is today a 40×40 box with the label drawn outside it. It becomes a fixed-size box:

*   **Size.** `ContactBadge.boxSize` is 212×92 px, with the circle at its centre.
    *   The label goes in a slot of `labelSlot` = 80×20 px, placed 6 px (the existing `labelGap`) from the circle, on the side given by `labelSide`: above, below, left or right.
    *   The box is wide and tall enough for the slot on any side: 40 + 2 × (6 + 80) = 212, and 40 + 2 × (6 + 20) = 92.
    *   80 px holds 10 characters at 7.6 px each. The longest label, "Modernise", is 9.
*   **Position.** `main.dart` centres the box on the bubble's anchor, at the anchor minus half of `boxSize`. The box never changes size, and the circle is always at its centre. So:
    *   the `AnimatedPositioned` moves between peak and orbit mode exactly as today
    *   the circle doesn't jump when the label switches sides
    *   `tester.getCenter(find.byType(ContactBadge))` in the tests is still the bubble's centre
*   **Taps.**
    *   The circle stays an `IconButton` with `tooltip: label`. That gives the one semantics node, the one focus stop, and the hover highlight.
    *   The label `Text` is wrapped in a `GestureDetector` (`onTap`: the same action as the circle, `behavior: opaque`) and a `MouseRegion` showing the click cursor. It stays inside `ExcludeSemantics`, so screen readers announce the bubble once, by its tooltip.
    *   The label's tap area is the text's own box. The rest of the slot doesn't respond.
*   **Overlapping boxes.** In peak mode, neighbouring boxes can overlap, because bubbles can be under 212 px apart. In orbit mode they overlap too, because the ring is 84 px in radius. This is harmless: the box's `Stack` has no tap handler of its own. A tap on an empty part of a box falls through to whatever lies underneath: another bubble, the footer or the scene. Only the circles and the label texts take taps, and the existing tests already keep those from overlapping.

**5. The email is one text button.** `_CopyEmail` and its state class are deleted. The footer's email is a `TextButton`:

*   style: `quiet`
*   label: `Text(Profile.email)`
*   `onPressed: onEmail`, where `MyHomePage` passes its existing `_email` method: `openUrl('mailto:…')`, then `copyEmail` if that returns false
*   wrapped in `Semantics(label: 'Email Marko at ${Profile.email}', button: true, excludeSemantics: true)`

**6. `footerReserve` gets the new measured numbers.** The 600 px breakpoint stays. After the footer is built, its height is measured at:

*   narrow: 390×844, 360×640, 412×915
*   wide (orbit mode): 601×800, 844×390, 1280×720

The largest value in each group, rounded up to the next multiple of 4 px, becomes the reserve for that group. Rounding keeps the constant stable against sub-pixel changes in text layout. Rough estimates: about 300 px narrow (today 380) and about 230 px wide (today 260). 601×800 is the widest-wrapping case that uses the wide value. `pageHeight` and `logoCenter` don't change, because they already read `footerReserve`.

The test `footer fits its reserve` pumps `MyApp` at those six sizes, with fonts loaded (`settleFonts`). It checks that the footer's box, found by `MyHomePage.footerKey`, is no taller than `footerReserve(size)`. If footer text, fonts or padding grow, the test fails and names the size.

**7. Peak mode needs no reserve.** In peak mode the footer sits at the bottom of the viewport, and the bubbles sit on the peaks. Measured today at 1440×900, the lowest bubble ends at 651 px and the footer's box starts at 664 px. A shorter footer only makes that gap larger. The existing test `perched bubbles stay clear of the footer` (1440×900, 1366×768, 1920×1080) keeps guarding it, measured from the top of the footer's box.

### Data flow

```text
 Modernise bubble or label ──► _showModernise() ──► showContentSheet(modernise.md, footer: ModerniseActions)
 any bubble label          ──► same onPressed as its circle
 footer email              ──► _email() ──► openUrl(mailto) ──false──► copyEmail() ──► SnackBar
 footer profile            ──► showProfileSheet()
```

### Things this plan affects outside the footer

*   **Tests**:
    *   `test/menu_layout_test.dart` and `test/profile_test.dart` use `find.text(Profile.business)` to find the footer, and tap "Talk about your app".
    *   `test/widget_test.dart` counts six `ContactBadge`s. It still passes.
*   **README**: `README.md:12` lists "Email" among the bubbles, and line 20 describes the footer.
*   **Audit**: `design/design-audit.md` gets a row noting that F1's footer fix is reversed on purpose.

## Alternatives Considered

### Alternative A: Only lighten the gradient

*   **Pros**: A one-line change in `_WhoIAm`'s `BoxDecoration`. No changes to layout, tests or bubbles.
*   **Cons**: All five layers stay (404 px, 48% of a 390×844 phone). Below 65% black over the mist, `inkSoft` text drops under 4.5:1.
*   **Reason for Rejection**: It treats the shading as the problem when the amount of content is the problem.

### Alternative B: Two-tier footer (offer and one button, then name · role · legal on one line)

*   **Pros**: Keeps the offer and a primary action on the home screen, so audit finding F1 stays closed. Fewer layers than today.
*   **Cons**: It is still a sales block over the mountains. The name · role · legal line is long, and on phones it wraps to three or four lines, which cancels most of the saving.
*   **Reason for Rejection**: Moving the offer behind a bubble removes more text and gives each part of the page one job. The owner accepted reopening F1 for this.

### Alternative C: Offer and button moved up under the wordmark

*   **Pros**: Frees the most mountain. The footer shrinks to a corner line with the name and legal text, closest to the micro1.ai look the hero is modelled on.
*   **Cons**: `MenuLayout.brandRect` and `orbitBrandHeight` must grow, so in peak mode bubbles have less room and may fall back to `_slotted`. Text in the sky can collide with labels. Portrait phones get taller and scroll sooner.
*   **Reason for Rejection**: It changes the bubble layout. Swapping one bubble keeps `MenuLayout` as it is, apart from `footerReserve`.

### Alternative D: A seventh "Modernise" bubble, keeping Email

*   **Pros**: Email keeps its bubble, and the offer gets its own.
*   **Cons**: `_slotted` asserts an even count (`lib/widgets/menu_layout.dart:102`). `useOrbit` needs 7 × 225 = 1575 px for peak mode, so a 1440×900 desktop would switch to orbit mode. The orbit label sides and the tests are written for six.
*   **Reason for Rejection**: Replacing Email keeps the count at six. Email already has a place in the footer.

### Alternative E: Merge the Modernise article into Work

*   **Pros**: One fewer page, and no new bubble.
*   **Cons**: Work is past projects plus the live-sites list. Modernise is the current offer with its own buttons. Merged, the page would be about 1,300 words plus the list, with the "Email me about your app" button in the middle or at the end.
*   **Reason for Rejection**: It mixes two kinds of page and buries the action.

### Alternative F: Name, role, profile link and legal only, with no email in the footer

*   **Pros**: The shortest footer.
*   **Cons**: With the Email bubble gone, the footer is the only place on the home screen with the address.
*   **Reason for Rejection**: It leaves no direct contact on the home screen.

### Alternative G: Measure the footer's height while the page runs

*   **Pros**: `footerReserve` could never be wrong. Today it is 24–56 px too small at three sizes.
*   **Cons**: `pageHeight` and `logoCenter` would need the measured height as an input. That means replacing the `LayoutBuilder` + `Stack` in `main.dart` with a `CustomMultiChildLayout` or a custom render object. The `AnimatedPositioned` moves between modes would also need rework, with a risk of flicker on the first frame.
*   **Reason for Rejection**: A fixed reserve plus a test that fails when the footer outgrows it catches the same drift. It changes two lines in `menu_layout.dart`, instead of rebuilding the page layout.

### Alternative H: Compute the footer height from constants

*   **Pros**: No measured number in the code.
*   **Cons**: Text wrapping depends on font metrics and text length. A sum of line heights and an assumed number of wrapped rows can still be wrong at widths such as 360 or 601 px.
*   **Reason for Rejection**: It is no more accurate than a measured reserve, and harder to read.

### Alternative I: Show the full legal details (address, OIB, register) in the footer

*   **Pros**: It may be what the Croatian e-commerce law asks for.
*   **Cons**: It adds one or two lines on phones, which works against the main goal.
*   **Reason for Rejection**: The owner kept the legal text as it is. Legal completeness is a separate follow-up.

### Alternative J: A longer bubble label, "Modernise your app"

*   **Pros**: It says more clearly what is on offer.
*   **Cons**: At 137 px it runs past a 390 px screen in orbit mode, and doesn't fit the 80 px label slot.
*   **Reason for Rejection**: It doesn't fit.

### Alternative K: A copy icon next to the footer email

*   **Pros**: People without a mail app can copy the address without trying to open mail first.
*   **Cons**:
    *   It needs its own hover and keyboard-focus state, because `IconButton` has no `onFocusChange`.
    *   Its visibility rule is unclear on touch laptops and tablets.
    *   It adds a second screen-reader node and a test.
    *   The mail fallback already copies.
*   **Reason for Rejection**: It adds a control and its state without adding anything the visitor can't already do.

### Alternative L: Bubble box sized to the circle plus its label, per side

*   **Pros**: The tap area matches exactly what is drawn.
*   **Cons**:
    *   The box's size and its offset from the anchor would change whenever the label switches sides (peak ↔ orbit). The circle would jump at the start of each animation unless every `AnimatedPositioned` gained per-side offset maths.
    *   Tests that read `getCenter(ContactBadge)` as the bubble's centre would break.
*   **Reason for Rejection**: A fixed box centred on the circle gives the same tap areas, because empty parts of the box don't take taps, and it needs no offset maths.

### Alternative M: The label as a separate tappable widget next to the bubble

*   **Pros**: The bubble's box and the anchor maths stay untouched.
*   **Cons**: The label placement code moves out of `ContactBadge` into `main.dart`, and the circle and label become two `AnimatedPositioned` widgets that must animate in step.
*   **Reason for Rejection**: It splits one visual element in two. The fixed box keeps it one widget.

## Risks & Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| The footer grows past `footerReserve` after a text, font or padding change | In orbit mode the wordmark or bubbles overlap the footer | The test `footer fits its reserve` at six sizes, including the worst wide case (601×800) |
| The scrim is too light for some background | Footer text below 4.5:1 | The test `footer text meets 4.5:1 over the mist` checks the lightest colour in the scene. Fallback scrim: 75% |
| A label longer than 10 characters | The text is clipped in its 80 px slot | The test `every label fits its slot` |
| Visitors don't find the offer behind the Modernise bubble (F1 reopened) | Fewer enquiries from clients with legacy apps | Watch "Modernising my app" email subjects (set by the Modernise sheet's mail button). If they stop, see Future Improvements |

## Non-Functional Requirements

*   **Accessibility**:
    *   All footer text has at least 4.5:1 contrast in the worst case.
    *   Every footer control has a touch target of at least 48 px tall.
    *   Bubbles keep one semantics node and one focus stop each, named by their tooltip. The labels are tappable but hidden from screen readers.
*   **Performance**: No change. One fewer button, one fewer stateful widget, and a flat colour where there was a gradient. No new layout passes.
*   **Rollout & Rollback**: This is a static site deployed to GitHub Pages. Rollback is reverting the commit and redeploying. No stored data or generated files change.

## Future Improvements

*   **Legal completeness**: check with an accountant whether the site must show the address, OIB and register entry (*Zakon o elektroničkoj trgovini*, art. 6). If so, add a "Business details" sheet opened from a short footer line.
*   **F1 follow-up**: if visitors don't find the offer, put the offer sentence in the Modernise bubble's tooltip, or replace the role line with it.
*   **Copy control for the email**, if visitors ask for it (see Alternative K).

--------------------------------------------------------------------------------

## Detailed Implementation Plan

### Order of work

1.  **Before any edit:** run the measuring test and the snapshot test (see Verification Plan). Save the footer heights at the six sizes and PNGs at 1440×900, 390×844 and 844×390.
2.  Change `lib/utils/widgets.dart` (the bubble box) and `lib/main.dart` (the bubble swap, box positioning and the footer).
3.  Run the measuring test again and note the new footer heights.
4.  Set `footerReserve` in `lib/widgets/menu_layout.dart` from those heights.
5.  Update the tests: `test/test_utils.dart`, `test/menu_layout_test.dart` and `test/profile_test.dart`. Run `flutter test`.
6.  Take the "after" PNGs and compare them with the "before" ones.
7.  Update `README.md` and `design/design-audit.md`.

### Target Files to Create/Modify

#### 1. `lib/utils/widgets.dart` (Modify)

*   **Type / Scope**: Shared widgets (`ContactBadge`).
*   **Proposed Changes**:
    *   Add constants to `ContactBadge`:
        *   `static const labelSlot = Size(80, 20)`
        *   `static const boxSize = Size(_size + 2 * (labelGap + 80), _size + 2 * (labelGap + 20))`, which is 212×92
    *   Comment: the box is centred on the circle so it can hold the label on any side without moving the circle. Empty parts of the box don't take taps.
    *   `build`: the root `Stack(clipBehavior: Clip.none)` now fills `boxSize`. It holds:
        1. the existing `CircleAvatar` + `IconButton`, in a `Positioned` 40×40 at the box centre: left `(boxSize.width − 40) / 2`, top `(boxSize.height − 40) / 2`
        2. the label
    *   `_label`: place the label's `Positioned` in the slot on `labelSide`, measured from the circle's edges inside the box:
        *   **above:** bottom edge 6 px above the circle's top, centred horizontally, width `labelSlot.width`, height `labelSlot.height`
        *   **below:** mirrored
        *   **left / right:** vertically centred on the circle, 6 px from its side, width `labelSlot.width`, aligned toward the circle

        The text stays `softWrap: false`, `maxLines: 1`, with the same style.
    *   Wrap the label `Text`:
        *   in `GestureDetector(behavior: HitTestBehavior.opaque, onTap: onPressed ?? () => openUrl(url!))`
        *   in `MouseRegion(cursor: SystemMouseCursors.click)`, inside the existing `ExcludeSemantics`
        *   inside an `Align`, so the tap area is the text's box and not the whole slot

        Move the press action into a private `_press()` method that both the `IconButton` and the label call.
    *   Update the class doc comment: the label is tappable and does the same as the circle.

#### 2. `lib/main.dart` (Modify)

*   **Type / Scope**: Flutter home page.
*   **Proposed Changes**:
    *   `MyHomePage`: add `static const footerKey = ValueKey('who-i-am-footer');`. Tests use it to find the footer's box, including the fade strip.
    *   `MyHomePage`: add `static const footerScrim = Color(0xB307070A);`, with the comment "70% of skyTop: inkSoft reaches 5.1:1 over HeroScene.mist (4.5:1 needed)". It's public so the contrast test can read it.
    *   `badges`, index 2: replace `ContactBadge(icon: FontAwesomeIcons.envelope, label: "Email", onPressed: _email)` with `ContactBadge(icon: FontAwesomeIcons.seedling, label: "Modernise", onPressed: _showModernise)`.
    *   The badge loop's `AnimatedPositioned` (currently `left: anchors[i].dx - r`, `top: anchors[i].dy - r`, `width/height: r * 2`) becomes:
        *   `left: anchors[i].dx - ContactBadge.boxSize.width / 2`
        *   `top: anchors[i].dy - ContactBadge.boxSize.height / 2`
        *   `width: ContactBadge.boxSize.width`, `height: ContactBadge.boxSize.height`

        Duration and curve are unchanged.
    *   `_WhoIAm` constructor: becomes `const _WhoIAm({required this.small, required this.onEmail, required this.onProfile, super.key})`. `onModernise` and `onCopyEmail` are removed. Call site: `_WhoIAm(key: MyHomePage.footerKey, small: small, onEmail: _email, onProfile: () => showProfileSheet(context))`.
    *   `_WhoIAm.build`:
        *   The root becomes `Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch)` with:
            1. `SizedBox(height: 32, child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: topCenter, end: bottomCenter, colors: [Color(0x0007070A), MyHomePage.footerScrim]))))`
            2. `ColoredBox(color: MyHomePage.footerScrim)` holding the existing `Padding` → `Center` → `ConstrainedBox(maxWidth: 720)` → `Column`
        *   Padding: `EdgeInsets.fromLTRB(Insets.large, 0, Insets.large, Insets.large)`.
        *   Inner `Column` children, in order:
            1. name `Text`
            2. role `Text`
            3. `Insets.medium.h`
            4. `Wrap(alignment: center, crossAxisAlignment: center, spacing: Insets.medium, runSpacing: 0)` containing the email button and the existing "Profile for you & your AI" `TextButton.icon`
            5. `Insets.small.h`
            6. legal `Text`
        *   The email button is `Semantics(label: 'Email Marko at ${Profile.email}', button: true, excludeSemantics: true, child: TextButton(onPressed: onEmail, style: quiet, child: const Text(Profile.email)))`.
        *   Remove the `Profile.business` `Text`, the `FilledButton.icon` and the old `BoxDecoration`.
    *   Delete `_CopyEmail` and `_CopyEmailState`.
    *   `_WhoIAm` doc comment becomes: "Who I am and how to reach me, over a dusk scrim at the foot of the hero: name and role, the email and the profile for AI, then the business registration."

#### 3. `lib/widgets/menu_layout.dart` (Modify)

*   **Type / Scope**: Layout maths.
*   **Proposed Changes**: In `footerReserve(Size size)`, replace `380` and `260` with the measured values from step 3 of the order of work, following Technical Plan point 6. Update its doc comment: the numbers are the measured footer heights, rounded up to a multiple of 4, and `footer fits its reserve` fails if the footer outgrows them.

#### 4. `test/test_utils.dart` (Modify)

*   **Type / Scope**: Test helpers.
*   **Proposed Changes**: Add two helpers, both returning a record that the test reads after tapping:
    *   `mockClipboard(WidgetTester tester)`: installs a `SystemChannels.platform` handler that records `Clipboard.setData` text. It replaces the three copies of this handler already in `test/profile_test.dart`.
    *   `mockUrlLauncher(WidgetTester tester, {bool result = true})`: installs a handler on `MethodChannel('plugins.flutter.io/url_launcher')` that records the `url` argument of each `launch` call and returns `result`.

    Facts this relies on, checked against the locked `url_launcher` 6.3.3 / `url_launcher_platform_interface` 2.3.2:
    *   `launchUrlString` sends `launch` on that channel, with no `canLaunch` call first.
    *   When nothing handles the channel, the call throws `MissingPluginException`, which `openUrl` catches, returning `false`.

    No new dependency is needed.

#### 5. `test/menu_layout_test.dart` (Modify)

*   **Type / Scope**: Widget and unit tests.
*   **Proposed Changes**:
    *   Line 131: `names` becomes `['LinkedIn', 'GitHub', 'Modernise', 'Stack', 'Work', 'AI']`. The existing tests `every label is visible and on screen` and `peak labels sit in the sky` then cover the new label.
    *   Lines 187, 223, 235: replace `tester.getRect(find.text(Profile.business))` with `tester.getRect(find.byKey(MyHomePage.footerKey))`. The reference point becomes the top of the footer's box (the fade strip), which sits higher than the old offer text.
    *   `pumpAt` (line 22) keeps reading `getCenter` of each `ContactBadge`. The box is centred on the circle, so this is still the bubble's centre. No change.
    *   New test group `footer fits its reserve`: for each of 390×844, 360×640, 412×915, 601×800, 844×390 and 1280×720, call `pumpAt`, then `expect(tester.getSize(find.byKey(MyHomePage.footerKey)).height, lessThanOrEqualTo(MenuLayout.footerReserve(size)), reason: '$size')`.
    *   New test `footer text meets 4.5:1 over the mist`, with no widgets:
        1. `bg = Color.alphaBlend(MyHomePage.footerScrim, HeroScene.mist)`
        2. for `ink` and `inkSoft`: `fg = Color.alphaBlend(ink, bg)`
        3. ratio `(max(L1, L2) + 0.05) / (min(L1, L2) + 0.05)`, with `L = computeLuminance()`
        4. expect at least 4.5

        The ratio is the only hand-written line.
    *   New test `every label fits its slot`: at 1440×900 and 390×844, for each name, `tester.getSize(find.text(name)).width <= ContactBadge.labelSlot.width`.

#### 6. `test/profile_test.dart` (Modify)

*   **Type / Scope**: Widget tests for the home page and sheets.
*   **Proposed Changes**:
    *   `home page leads with the offer, then name and role` (line 75) is renamed `footer shows name, role, contact row, then legal`.
        *   It checks the top-to-bottom order: `Profile.name`, then `Profile.roleUnbreakable`, then `Profile.email`, then the `obrt za informatičke usluge` text.
        *   It checks that `find.text(Profile.business)` and `find.text('Talk about your app')` find nothing on the home page.
        *   It still taps "Profile for you & your AI" and expects "Am I the right fit?".
    *   `the primary action opens the Modernise page` (line 95) is renamed `the Modernise bubble opens the Modernise page`. It taps `find.byTooltip('Modernise')`. `find.text('Modernise')` is the label, which would also work now but is covered by the next test. The rest stays.
    *   New test `tapping a label does the same as its bubble`: at 390×844, tap `find.text('Work')` and expect the Work sheet to open (`find.text('Live sites')`).
    *   `the email in the footer copies itself` (line 115) is replaced by:
        *   `the footer email opens mail`: `mockUrlLauncher(result: true)` and `mockClipboard`. Tap `find.text(Profile.email)`. Expect one launch with `url == 'mailto:${Profile.email}'`, and nothing copied.
        *   `the footer email falls back to copying`: only `mockClipboard`. Tap `find.text(Profile.email)`, pump, and expect `Profile.email` to be copied and "Copied ${Profile.email}" to be shown.
    *   `Modernise actions email me or copy the legacy prompt` (line 145) and the profile sheet test switch to `mockClipboard`. Their assertions are unchanged.

#### 7. `README.md` (Modify)

*   **Type / Scope**: Documentation.
*   **Proposed Changes**:
    *   Line 12: "LinkedIn, GitHub, Email, Stack, Work and AI" becomes "LinkedIn, GitHub, Modernise, Stack, Work and AI. Tapping a label does the same as its bubble."
    *   Line 17: "Stack, Work and AI open markdown pages" becomes "Modernise, Stack, Work and AI open markdown pages".
    *   After line 22, add: "**Footer:** name, role, the email (opens mail, or copies it), the profile button, and the business registration."

#### 8. `design/design-audit.md` (Modify)

*   **Type / Scope**: Documentation (the audit's changelog table).
*   **Proposed Changes**: Add a row after `1d`:
    *   Pass: `1e`
    *   Fixed: "footer crowding: four lines, 70% scrim (5.1:1 worst case); bubble labels tappable"
    *   New: "F1 reopened on purpose: the offer and primary action leave the home screen and move behind a Modernise bubble, which replaces Email. See docs/designs/home_footer.md."
    *   Still open: the existing list, plus F1.

Files with no edits needed: `lib/data/profile.dart`, `lib/widgets/modernise_actions.dart`, `lib/widgets/hero_scene.dart`, `tool/build_profile.dart`, `test/widget_test.dart`, `pubspec.yaml`, `web/*`, `assets/content/*.md`.

### Verification Plan

*   **Static Analysis & Linting**: `flutter analyze` reports no new issues.
*   **Unit and Widget Tests**: `flutter test` passes. That includes the new tests:
    *   `footer fits its reserve`
    *   `footer text meets 4.5:1 over the mist`
    *   `every label fits its slot`
    *   `tapping a label does the same as its bubble`
    *   `the footer email opens mail`
    *   `the footer email falls back to copying`

    It also includes the updated label, footer and Modernise tests.
*   **Measured numbers**: a throwaway measuring test, not committed, prints the footer's height at the six sizes. It lives in the scratchpad and imports the package and `test/test_utils.dart` by absolute path, run with `flutter test <path>` from the project root. Put the before and after heights in the commit message.
*   **Visual check**: a throwaway snapshot test, also in the scratchpad, renders `MyApp` to PNG at 1440×900, 390×844 and 844×390, before and after. Check:
    *   the front ridge's top edge shows above the fade strip at all three sizes
    *   the footer has no filled button
    *   the "Modernise" label doesn't touch a neighbouring label or circle
*   **Build**: `flutter build web` succeeds.

--------------------------------------------------------------------------------

*Drafted with EGM*
