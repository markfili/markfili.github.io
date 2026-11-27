# Hero: realistic mountains, still clouds, labelled bubbles

Date: 2026-11-17 · Branch: `modernise` · Size: small change

## Intent

The mountain outline reads as fake because it is too smooth. The animated
sky was too heavy on CPU (measured by Marko in Brave's task manager), but
clouds as still scenery are a fun addition. The menu bubbles should get
text labels. The mood is unchanged: the warm, grainy, procedurally painted
night scene modelled on micro1.ai.

## Decisions (Marko's)

- **Mountains:** midpoint displacement, tuned in the playground to
  `jaggedness: 0.82, height: 0.84, seed: 183`.
- **Clouds:** still, not animated.
- **Labels:** every visitor sees every name. On wide screens each label goes
  above its bubble. On phones, labels radiate outward from the circle.
  (This replaces the earlier "wide screens only": phones would otherwise
  show six unlabelled circles, which is audit finding F1.)
- **Playground:** keep it at `?playground=mountains`. It's fun.

## Approaches considered (mountains)

1. Ridged fractal noise: craggy, Dolomites-like spires.
2. **Midpoint displacement (chosen):** a continuous jagged crest, like an
   Alpine panorama. The shape is fixed in canvas-height units, so
   resizing never reshapes it.
3. Tracing a real skyline: dropped, because it repeats on wide screens and
   raises copyright questions about tracing photos.

## Design

- **Mountains:**
  - The two far ranges (`peaked` ridges) use midpoint displacement with the
    chosen values.
  - The forest rows keep today's outline.
  - The outline lives in `Ridge` itself, so `MenuLayout.skylineAt` and the
    bubble perching keep working unchanged.
  - The playground drives the same `Ridge` code, so what you tune is what
    ships.
- **Clouds:**
  - The existing `sky_clouds.frag` is painted once at a fixed moment inside
    its own repaint boundary.
  - There is no ticker. The clouds redraw only on resize.
- **Removed:** the animated band effect, `sky_band.frag`, the `?sky=` switch
  and the ticker. With no motion left, audit findings F10 and WCAG 2.2.2 no
  longer apply to the sky.
- **Labels:** each bubble shows its name ("LinkedIn", "GitHub", "Email",
  "Stack", "Work", "AI") in 12px `ink`.
  - **Wide screens (bubbles on the summits):** the label goes *above* the
    bubble, in the sky. A bubble perches 6px above its summit, so a label
    underneath would sit on the pink rock, where the audit measured text
    failing contrast (2.5–2.9:1).
  - **Phones (bubbles circling the logo):** each label sits outward from
    the circle along its bubble's direction. Top bubbles get labels above,
    side bubbles beside, bottom bubbles below. The wordmark moves down
    enough to clear the bottom labels (about 10px). At 360px wide, the
    longest label ("LinkedIn") lands on an upper bubble, so it fits.
  - The layout animates between the two modes as it does now, with the
    labels moving along with their bubbles.
  - The tooltips stay, so screen readers still get each name.

## Constraints and checks

- **Contrast:** wordmark ≥ 4.5:1, labels ≥ 4.5:1, bubble icons ≥ 3:1. I'll
  re-measure in renders at 1440×900, 1280×720, 390×844 and 360×640.
- **Bubbles:** the new jagged crest has many small bumps, so summit-finding
  must still pick big, well-separated summits. The `menu_layout` tests must
  pass, re-tuned if needed.
- **Performance:** no frames are scheduled while the page is idle. A test
  covers this.

## Left to the builder

- The exact label spacing, and the label offset per angle on phones.
- Whether the far range's `amplitude` absorbs the 0.84 height factor or
  keeps it as a separate parameter.
