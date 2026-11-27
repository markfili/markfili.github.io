# Hero: realistic mountains, still clouds, labelled bubbles. Implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give the hero jagged, realistic far mountains, still clouds, and visible bubble labels at every screen size. Keep the mountain playground as a permanent tuning page that drives the same code.

**Architecture:**
- The midpoint-displacement outline moves into `Ridge`, so `MenuLayout.skylineAt` and bubble perching keep working unchanged.
- The animated sky machinery (`SkyEffect`, ticker, `?sky=`, band shader) is replaced by one still clouds layer.
- Labels are part of `ContactBadge`. `MenuLayout` decides which side of the bubble each label sits on.

**Tech Stack:** Flutter web (FVM 3.50.0), `CustomPainter`, Flutter fragment shaders, `flutter_test`.

**Spec:** `design/superpowers/specs/2026-11-17-hero-mountains-clouds-labels-design.md`

## Global Constraints

- Chosen outline: midpoint displacement, `jaggedness: 0.82`, `height: 0.84`, `seed: 183`. These apply to the two `peaked` ridges only; the forest rows are unchanged.
- Variation seed formula, as in the playground: `effectiveSeed = ridge.seed + variation * 101`.
- No animation anywhere in the hero. No frames are scheduled while the page is idle.
- Labels: "LinkedIn", "GitHub", "Email", "Stack", "Work", "AI", in 12px `HeroScene.ink`. They go above the bubble in peak mode and radially outward in orbit mode.
- Contrast floors: wordmark and labels ≥ 4.5:1, bubble icons ≥ 3:1.
- The playground stays at `?playground=mountains`.
- **Don't commit.** Marko commits on request. Every "commit" point below is "leave the change in the working tree".

## Review Focus

1. **Ultra-wide screens (width > 4 × height):** the midpoint profile spans 4 canvas heights. Beyond that it must continue (mirrored), not flatline. Test in Task 1.
2. **Jagged crest vs summit-finding:** small bumps must not each count as a summit, and bubbles must stay well apart and clear of the brand. Covered by the existing `menu_layout` tests, run at 1440×900 and 1920×1080 in Task 1.
3. **Labels leaving the screen in orbit mode at 360px:** every label rect lies within the screen. Test in Task 3.
4. **Labels colliding with the wordmark or rock:** orbit bottom labels must stay above the wordmark, and peak labels must sit entirely above the skyline at their x. Test in Task 3.
5. **The playground drifting from the hero:** its default dials must equal the hero's ridge parameters. Test in Task 4.

---

### Task 1: Midpoint outline in `Ridge`

**Files:**
- Modify: `lib/widgets/hero_scene.dart` (`Ridge`, `HeroScene.ridges`)
- Test: `test/hero_scene_test.dart`, `test/menu_layout_test.dart`

**Interfaces:**
- Produces:
  - `Ridge` gains `final double? jaggedness` (null keeps today's sine outline) and `final int variation` (default 0).
  - `elevationAt(double t) -> double` keeps its contract: it stays within `horizon ± amplitude`.
  - `static const double Ridge.midpointSpan = 4.0` is the span in canvas heights.
  - The two peaked entries in `HeroScene.ridges` get `jaggedness: 0.82, variation: 183`, and their `amplitude` is multiplied by 0.84 (0.12 → 0.1008, 0.08 → 0.0672).

- [ ] **Step 1: Write the failing tests** in `test/hero_scene_test.dart`, group `Ridge`:
  - `midpoint outline stays within the band`: 0.6 ≤ `elevationAt(t)` ≤ 0.8 for `t` in [0, 12] with step 0.003, for a `Ridge(seed: 7, horizon: 0.7, amplitude: 0.1, jaggedness: 0.82, ...)`.
  - `midpoint outline is jagged`: over `t ∈ [0, 1.6]` at step 0.002, the count of local maxima is > 40. Today's sine ridge has fewer than 10, so the test tells them apart.
  - `midpoint outline continues past its span`: the max−min of `elevationAt` over `t ∈ [4.5, 6.0]` is > 0.3 × amplitude, so it doesn't flatline.
  - `variation changes the outline`: `variation: 0` and `variation: 1` differ at some `t`.
- [ ] **Step 2: Run** `fvm flutter test test/hero_scene_test.dart`. Expected: FAIL (`jaggedness` is not a parameter).
- [ ] **Step 3: Implement.** Cache a static profile per `(effectiveSeed, jaggedness)`. Build it exactly like the playground's `_midpoint`:
  - 2¹¹+1 points, `math.Random(effectiveSeed)`, `scale` starts at 0.6 and is multiplied by `2^-jaggedness` per level.
  - Normalise to [0, 1].
  - Sample with linear interpolation at `u = t / midpointSpan`, mirrored for `u` outside [0, 1] (ping-pong).
  - Return `horizon - amplitude * (2 * h - 1)`.
  - Update the two peaked entries in `HeroScene.ridges`.
- [ ] **Step 4: Run** `fvm flutter test`. Expected: all pass, including `test/menu_layout_test.dart`. If the summit tests fail, re-tune in `MenuLayout._highestSummits`: raise `minDrop` from `0.015` toward `0.03` of the height and widen `window` from `0.06` toward `0.09` of the width. Don't change the tests' intent. Also run the desktop perch test at 1920×1080 by adding that size to its existing loop.

### Task 2: Still clouds; remove the animation

**Files:**
- Modify: `lib/widgets/hero_scene.dart`, `lib/main.dart`, `pubspec.yaml`
- Delete: `shaders/sky_band.frag`
- Test: `test/hero_scene_test.dart`

**Interfaces:**
- Produces:
  - `HeroScene({String grainShader = 'shaders/grain.frag', String? cloudShader = 'shaders/sky_clouds.frag'})`. Pass `null` for no clouds.
  - `SkyEffect`, the ticker, `_time`, and the `?sky=` parsing in `main.dart` are removed.
  - The clouds are painted at a fixed time, `cloudTime = 65.0` (as in the playground), with the same uniforms `_SkyEffectPainter` set for clouds.

- [ ] **Step 1: Replace the sky tests.** Remove the `SkyEffect.parse` test and the "keeps moving" / "holds still" tests. Add:
  - `clouds are painted and the scene is idle`: pump `MaterialApp(home: HeroScene())`, `runAsync` delay 200ms, pump. Then `expect(tester.binding.hasScheduledFrame, isFalse)` and `expect(tester.takeException(), isNull)`.
  - `renders without clouds when the shader is unavailable`: `cloudShader: 'shaders/missing.frag'` gives no exception.
- [ ] **Step 2: Run** `fvm flutter test test/hero_scene_test.dart`. Expected: FAIL (`cloudShader` is not a parameter).
- [ ] **Step 3: Implement.** Use a still `_CloudsPainter(shader)` inside its own `RepaintBoundary` between `_SkyPainter` and `_ScenePainter`, with `shouldRepaint` true only when the shader changes. Drop the ticker mixin. Remove `shaders/sky_band.frag` from `pubspec.yaml` and delete the file.
- [ ] **Step 4: Run** `fvm flutter analyze && fvm flutter test`. Expected: no issues, all pass.

### Task 3: Bubble labels

**Files:**
- Modify: `lib/utils/widgets.dart` (`ContactBadge`), `lib/widgets/menu_layout.dart`, `lib/main.dart`
- Test: `test/menu_layout_test.dart`, `test/widget_test.dart`

**Interfaces:**
- Produces:
  - `ContactBadge({required FaIconData icon, required String label, Alignment labelSide = Alignment.topCenter, String? url, VoidCallback? onPressed})`. `label` replaces `tooltip` and is also used as the tooltip. The label is laid out outside the 40×40 bubble on `labelSide` (`Stack` with `clipBehavior: Clip.none`), so `MenuLayout` positions are unchanged.
  - `static Alignment MenuLayout.orbitLabelSide(int index, {required int count})` returns the bubble's outward direction, snapped to one of `topCenter`, `bottomCenter`, `centerLeft` or `centerRight`. It is vertical when the bubble's angle is within 45° of straight up or down, horizontal otherwise.
  - In orbit mode, `MenuLayout.wordmarkTop` adds `labelClearance = 14.0`, and `orbitBrandHeight` grows by the same amount.
  - `main.dart` passes `labelSide: orbit ? MenuLayout.orbitLabelSide(i, count: n) : Alignment.topCenter`.

- [ ] **Step 1: Write the failing tests** in `test/menu_layout_test.dart`:
  - `orbitLabelSide points outward`: with `count: 6`, index 0 → `topCenter`, 2 → `centerRight`, 3 → `bottomCenter`, 5 → `centerLeft`.
  - For each size in `[desktop, phone, Size(360, 640)]`, `every label is visible and on screen`. `pumpAt`, then for each of the six names, `find.text(name)` finds one widget and its rect lies within `Offset.zero & size`.
  - `peak labels sit in the sky` (desktop): for each label rect, `rect.bottom < MenuLayout.skylineAt(rect.center.dx, size)`.
  - `orbit labels clear the wordmark` (phone and 360×640): every label's bottom ≤ the wordmark's top − 4.
  - In `test/widget_test.dart`, update badge construction if it refers to `tooltip`.
- [ ] **Step 2: Run** `fvm flutter test test/menu_layout_test.dart`. Expected: FAIL (`label` is not a parameter).
- [ ] **Step 3: Implement** as in Interfaces. The label is `Text(label, style: bodySmall 12px, color HeroScene.ink, letterSpacing 0.4)` with a 6px gap from the bubble, wrapped in `ExcludeSemantics` so screen readers hear the name once, via the tooltip.
- [ ] **Step 4: Run** `fvm flutter analyze && fvm flutter test`. Expected: all pass.

### Task 4: Playground drives `Ridge`, permanently

**Files:**
- Modify: `lib/dev/mountain_playground.dart`, `lib/main.dart` (drop the THROWAWAY comment)
- Test: `test/mountain_playground_test.dart` (create)

**Interfaces:**
- Consumes: `Ridge(jaggedness:, variation:)` from Task 1, `HeroScene.ridges`.
- Produces:
  - `Dials.fromHero()` returns dials equal to the hero (`outline: midpoint`, `jaggedness: 0.82`, `height: 0.84`, `seed: 183`).
  - `Dials.ridges() -> List<Ridge>` returns `HeroScene.ridges` with the peaked ones rebuilt from the dials (`amplitude = baseAmplitude * height`, where `baseAmplitude` is 0.12 / 0.08).
  - The playground paints those ridges with `Ridge.path`. Remove its private `_Profile` midpoint copy. The ridged option stays playground-only: keep its sampler, but feed it through a `Ridge` subclass or callback rather than a separate painter path.

- [ ] **Step 1: Write the failing tests:**
  - `playground starts at the hero's values`: `Dials.fromHero().describe()` equals `'outline: midpoint, jaggedness: 0.82, height: 0.84, seed: 183'`.
  - `playground ridges match the hero`: for `t` in 0..3 at step 0.01, `Dials.fromHero().ridges()[i].elevationAt(t)` equals `HeroScene.ridges[i].elevationAt(t)` within 1e-9, for all i.
  - `playground renders and responds`: pump, tap "Next variation", find `seed: 184`.
- [ ] **Step 2: Run** `fvm flutter test test/mountain_playground_test.dart`. Expected: FAIL.
- [ ] **Step 3: Implement** as in Interfaces.
- [ ] **Step 4: Run** `fvm flutter analyze && fvm flutter test`. Expected: all pass.

### Task 5: Verify and hand over

- [ ] **Step 1:** Render `MyApp` to PNG at 1440×900, 1280×720, 390×844 and 360×640 with a throwaway test (see memory: visual check via widget test). Measure contrast with `scratchpad/cr.py`: wordmark ≥ 4.5, each label ≥ 4.5 against its sampled background, bubble icons ≥ 3. Delete the throwaway test.
- [ ] **Step 2:** Update `design/design-audit.md`. Add a changelog row noting the sky animation was removed, so F10 no longer applies to the sky, and that F1's phone half is closed by the labels.
- [ ] **Step 3:** Restart the web server on 127.0.0.1:8790 (web-server mode) and open `/` and `/?playground=mountains` for Marko.
