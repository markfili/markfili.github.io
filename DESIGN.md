---
name: arilus
description: A night ridge painted in code, with one warm red ring above it.
colors:
  ember-ring: "#9F0000"
  ember-shadow: "#5D0101"
  night-sky: "#07070A"
  dusk-floor: "#1B1517"
  horizon-glow: "#8A4232"
  valley-mist: "#C9BCBE"
  sunlit-ridge: "#B0695A"
  far-ridge: "#7D4D47"
  slate-forest: "#3B4555"
  night-forest: "#151B23"
  moon-ink: "#FFFFFFE6"
  soft-ink: "#FFFFFF99"
  glass: "#FFFFFF1F"
  footer-scrim: "#07070AB3"
  sheet-surface-legacy: "#13140C"
  sheet-accent-legacy: "#C6CC79"
typography:
  display:
    fontFamily: "DM Mono, monospace"
    fontSize: "56px"
    fontWeight: 300
    letterSpacing: "-2px"
  headline:
    fontFamily: "DM Mono, monospace"
    fontSize: "28px"
    fontWeight: 300
  title:
    fontFamily: "DM Mono, monospace"
    fontSize: "14px"
    fontWeight: 500
  body:
    fontFamily: "DM Mono, monospace"
    fontSize: "14px"
    fontWeight: 400
    lineHeight: 1.55
  label:
    fontFamily: "DM Mono, monospace"
    fontSize: "12px"
    fontWeight: 400
    letterSpacing: "0.4px"
rounded:
  sm: "8px"
  full: "9999px"
spacing:
  sm: "4px"
  md: "8px"
  lg: "16px"
  sheet: "24px"
components:
  menu-bubble:
    backgroundColor: "{colors.glass}"
    textColor: "{colors.soft-ink}"
    rounded: "{rounded.full}"
    size: "40px"
  menu-label:
    textColor: "{colors.moon-ink}"
    typography: "{typography.label}"
  footer-action:
    textColor: "{colors.moon-ink}"
    typography: "{typography.body}"
  footer-band:
    backgroundColor: "{colors.footer-scrim}"
    padding: "0 16px 16px"
  content-sheet:
    backgroundColor: "{colors.sheet-surface-legacy}"
    padding: "0 24px 32px"
---

# Design System: arilus

## Overview

**Creative North Star: "The Night Ridge"**

arilus is dusk over a mountain range. The whole first screen is a landscape painted in code: a near-black sky that warms toward the horizon, still clouds, layered ridges from sunlit red-brown to slate-blue forest, and film grain over everything. Above it hangs a single red ring. That ring is the one warm light in a cold scene, and nothing else competes with it.

The mood is quiet and patient. Controls are glassy and low-contrast so the landscape stays the subject. Type is DM Mono throughout, with a precise engineer's voice, set light and loose. There are no images other than the logo. Every ridge, cloud and grain is generated, and that is part of the point: the scene itself shows the craft.

The content sheets currently use an olive Material 3 theme that is **not** part of this world. It is recorded below as legacy debt, to be rethemed into the Night Ridge palette.

**Key Characteristics:**
- One warm focal point (the ember ring) on a cold, dark field.
- Procedural landscape: no stock imagery, no photography.
- Film grain over every pixel of the hero.
- Monospace type only, set light.
- Glassy, translucent controls that sit inside the scene rather than on top of it.

## Colors

Cold night neutrals and dusk red-browns, lit by one saturated red.

### Primary
- **Ember Ring**: the logo's red. It is reserved for the mark. It is the only saturated colour on screen.
- **Ember Shadow**: the ring's shaded side. Use it only inside the mark or for a deep ember tint.

### Secondary
- **Horizon Glow**: a radial glow low in the sky (50% alpha at its centre) that warms the scene behind the ridges and the ring.
- **Sunlit Ridge / Far Ridge**: the front, red-brown ridges, which catch the last light.

### Tertiary
- **Slate Forest / Night Forest**: the cool blue-grey treeline layers that close the scene at the bottom.

### Neutral
- **Night Sky**: the top of the sky, the browser `theme-color`, and the base of the footer scrim.
- **Dusk Floor**: the bottom of the sky gradient.
- **Valley Mist**: the mist between ridges.
- **Moon Ink** (90% white): primary text on the scene, including the wordmark, name and labels.
- **Soft Ink** (60% white): secondary text, such as the role line and icons.
- **Glass** (12% white): bubble fills and the faint orbit ring.
- **Footer Scrim** (70% Night Sky): the band behind the footer. It is tuned so that Soft Ink reaches 5.1:1 over Valley Mist.

### Legacy (debt)
- **Olive Sheet Surface / Olive Accent**: the Material 3 dark scheme in `lib/utils/theme.dart`, used by the content and profile sheets. It is off-world. Replace it with Night Ridge values when the sheets are rethemed.

### Named Rules
**The One Ember Rule.** Ember Ring is the only saturated colour on the page, and it belongs to the mark. Every other colour is a dusk or night tone.

**The Ink Not Grey Rule.** Text on the scene is white at a fixed alpha (Moon Ink or Soft Ink), never a solid grey, so it takes on the sky behind it.

## Typography

**Display Font:** DM Mono (bundled in `assets/fonts`, never fetched at runtime)
**Body Font:** DM Mono
**Label Font:** DM Mono

**Character:** a single monospace face, used light. It reads like an engineer's log: exact, unhurried and plain.

### Hierarchy
- **Display** (300, 56px, −2px tracking): the "arilus" wordmark only.
- **Headline** (300, 28px): the H1 of each content sheet.
- **Offer** (300, 26px on one line from 700px wide, 20px stacked below): the rotating offer line. The verb is in Soft Ink and the tail in Moon Ink.
- **Title** (500, 14px): the name in the footer.
- **Body** (400, 14px, 1.55 line height in sheets): sheet prose, the role line and footer actions.
- **Label** (400, 12px, 0.4px tracking): bubble labels and the business-registration line.

### Named Rules
**The One Face Rule.** DM Mono everywhere. Hierarchy comes from size, weight (300 to 500) and ink alpha, never from a second family.

## Layout

There is one full-height screen and the home page does not scroll; only the smallest phones (around 360×640) scroll a little. The scene fills the viewport. On wide screens the logo sits high in the sky (a fifth of the way down) with the wordmark under it, and the offer line holds the open sky at about 45% of the height, above every summit. The footer is pinned to the bottom over the scrim, capped at 720px wide.

The menu has two arrangements, chosen by the size of the viewport:
- **Peak layout** (at least 760×520 and enough width per bubble): each bubble perches on its own computed ridge summit, 6px above it.
- **Orbit layout** (narrower): the bubbles circle the logo at an 84px radius, on a faint Glass ring, with the offer line 20px under the wordmark.

The bubbles animate between the two arrangements (650ms, ease-in-out cubic). Content opens in modal bottom sheets. Content sheets are up to 880px wide and 90% of the viewport height; the profile sheet is up to 640px wide. The spacing rhythm is 4, 8 and 16px, and sheet content is padded 24px.

## Elevation & Depth

Depth comes from **atmosphere, not shadows**. Ridges recede through colour and value: warm and light at the front, cool and dark at the back. Mist sits between the layers. A 32px gradient fades the front ridge into the footer scrim so nothing is cut off. The hero has no drop shadows. The modal sheets use Material's default elevation, which belongs to the legacy sheet theme.

### Named Rules
**The Aerial Perspective Rule.** Separate layers with colour temperature and mist, never with a shadow.

## Shapes

The shape language is circles on jagged ridges. The ring, the bubbles and the orbit are perfect circles, set against the irregular silhouettes of the ridges. The only other corner radius is 8px, on blockquotes and in-sheet surfaces.

## Components

### Menu Bubble (signature)
- **Character:** a glass bead resting on a summit.
- **Shape:** a 40px circle with a Glass fill and a Soft Ink icon (Font Awesome).
- **Label:** Moon Ink, Label type, placed above, below or to the side of the bubble according to the layout. Tapping the label does the same as tapping the bubble.
- **States:** a Material ripple and a tooltip; there is no custom hover or active treatment yet.

### Offer Line (signature)
- **Character:** the one sentence the page exists to say, drifting like mist.
- **Content:** a fixed verb with a rotating tail, from `Profile.offers`: "I modernise" legacy Django apps, Python 2 code bases, dated front ends, apps nobody wants to touch; then "I build" new Flutter apps, new Django back ends, on what I modernise.
- **Layout:** one line on wide screens, with the tails in a fixed column so the verb never moves. Below 700px, the verb and the tail are stacked and centred.
- **Motion:** the lead line holds for 5s and the others for 3.2s. In a 900ms swap, the old tail drifts up and fades out, then the new one rises in from below. The verb only fades when it changes. With reduce motion on, the lead line shows and nothing moves.
- **Accessibility:** screen readers hear all the offers once, as one sentence (`Profile.offersSentence`).

### Footer Band
- **Character:** dusk settling on the treeline.
- **Content:** Footer Scrim behind the name (Title), the role (Body in Soft Ink), two quiet text buttons (the email, and "Profile for you & your AI" with a download icon), and the registration line (Label).

### Content Sheet (legacy theme)
- A modal bottom sheet with a drag handle that renders markdown.
- Tables use 0.5px outline-variant borders.
- Blockquotes are italic on the tertiary container, with an 8px radius.
- It currently follows the olive Material 3 dark scheme. Retheme it before extending it.

### Loading Splash
- The logo and the "arilus" wordmark on Night Sky (in `web/index.html`). It is removed about 1.5s after Flutter's first frame.

## Do's and Don'ts

### Do:
- **Do** paint new scenery procedurally (`CustomPainter`, fragment shaders) and keep the grain over it.
- **Do** keep Ember Ring for the mark. Warm the scene with Horizon Glow and the ridge tones instead.
- **Do** set text on the scene in Moon Ink or Soft Ink, and keep secondary text at least 4.5:1 against what is actually behind it (the reason for the 70% footer scrim).
- **Do** keep controls glassy and translucent, so the landscape stays the subject.
- **Do** use DM Mono for all text.
- **Do** keep one moving element on the home screen: the offer line. The scene itself stays still.

### Don't:
- **Don't** add photography, stock illustration or image textures to the hero.
- **Don't** introduce a second typeface.
- **Don't** add drop shadows to the scene. Depth comes from aerial perspective.
- **Don't** extend the olive Material 3 sheet theme to new surfaces.
- **Don't** add a second saturated accent colour.
