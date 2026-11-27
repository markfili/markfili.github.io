import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';

/// One silhouette of hills, drawn as a filled path anchored to the bottom
/// edge of the canvas.
///
/// The profile is a fixed sum of waves seeded by [seed], so the same ridge
/// renders identically on every load and at every size.
class Ridge {
  /// Seed for the phases of the profile.
  final int seed;

  /// Average elevation as a fraction of the canvas height, measured from the
  /// top (0 is the top edge, 1 is the bottom edge).
  final double horizon;

  /// How far above and below [horizon] the profile may swing, as a fraction
  /// of the canvas height.
  final double amplitude;

  /// 0 gives a clean edge, 1 adds a fine jagged treeline.
  final double roughness;

  /// Sharp mountain peaks instead of rolling hills.
  final bool peaked;

  /// When set, the outline is a midpoint-displacement profile instead of the
  /// sum of waves. Higher values give a rougher, more jagged skyline.
  final double? jaggedness;

  /// Picks another midpoint profile for the same [seed]; ignored without
  /// [jaggedness].
  final int variation;

  /// Fill color at the crest of the ridge.
  final Color top;

  /// Fill color at the bottom edge of the canvas.
  final Color bottom;

  const Ridge({
    required this.seed,
    required this.horizon,
    required this.amplitude,
    required this.top,
    required this.bottom,
    this.roughness = 0,
    this.peaked = false,
    this.jaggedness,
    this.variation = 0,
  });

  /// Width of one midpoint profile in canvas heights. Beyond it the profile
  /// is mirrored back and forth, so it never ends.
  static const double midpointSpan = 4.0;

  static const _midpointLevels = 11;

  static final _midpointCache = <(int, double), List<double>>{};

  /// Midpoint displacement over 2^11 + 1 points, normalised to [0, 1].
  static List<double> _midpointProfile(int seed, double jaggedness) {
    return _midpointCache.putIfAbsent((seed, jaggedness), () {
      const n = 1 << _midpointLevels;
      final a = List<double>.filled(n + 1, 0);
      final rng = math.Random(seed);
      a[0] = rng.nextDouble();
      a[n] = rng.nextDouble();
      var step = n;
      var scale = 0.6;
      while (step > 1) {
        final half = step ~/ 2;
        for (var i = half; i < n; i += step) {
          a[i] =
              (a[i - half] + a[i + half]) / 2 +
              (rng.nextDouble() * 2 - 1) * scale;
        }
        scale *= math.pow(2, -jaggedness).toDouble();
        step = half;
      }
      final lo = a.reduce(math.min), hi = a.reduce(math.max);
      return [for (final v in a) (v - lo) / (hi - lo)];
    });
  }

  double _midpointElevation(double t, double jaggedness) {
    final a = _midpointProfile(seed + variation * 101, jaggedness);
    // Ping-pong: fold t / span into [0, 1].
    var u = (t / midpointSpan) % 2;
    if (u < 0) u += 2;
    if (u > 1) u = 2 - u;
    final x = u * (a.length - 1);
    final i = math.min(x.floor(), a.length - 2);
    final h = a[i] + (a[i + 1] - a[i]) * (x - i);
    return horizon - amplitude * (2 * h - 1);
  }

  // Octave weights sum to 1 so the profile never leaves the amplitude band.
  // The last octave is the treeline and is scaled by [roughness].
  static const _weights = [0.42, 0.22, 0.12, 0.06, 0.18];

  // Cycles per canvas height, so wide screens show more peaks rather than
  // stretched ones.
  static const _frequencies = [0.55, 1.3, 2.9, 6.1, 90.0];

  double _phase(int octave) {
    // Tiny integer hash; enough to make seeds look unrelated.
    var h = seed * 374761393 + octave * 668265263;
    h = (h ^ (h >> 13)) * 1274126177;
    h = h ^ (h >> 16);
    return (h & 0xffff) / 0xffff * 2 * math.pi;
  }

  /// Elevation at [t] (horizontal position in canvas heights) as a fraction
  /// of the canvas height from the top. Always within `horizon ± amplitude`.
  double elevationAt(double t) {
    final j = jaggedness;
    if (j != null) return _midpointElevation(t, j);
    var sum = 0.0;
    final last = _weights.length - 1;
    for (var i = 0; i < _weights.length; i++) {
      final x = t * _frequencies[i] * 2 * math.pi + _phase(i);
      final double wave;
      if (i == last) {
        wave = roughness * _triangle(x);
      } else if (peaked && i < 2) {
        wave = _ridged(x);
      } else {
        wave = math.sin(x);
      }
      sum += _weights[i] * wave;
    }
    return horizon + amplitude * sum;
  }

  /// Triangle wave in [-1, 1].
  static double _triangle(double x) {
    final p = (x / (2 * math.pi)) % 1.0;
    return 4 * (p - 0.5).abs() - 1;
  }

  /// Rectified sine in [-1, 1]; its sharp minima become peaks on screen.
  static double _ridged(double x) => 2 * math.sin(x).abs() - 1;

  /// The filled silhouette for a canvas of [size].
  Path path(Size size) {
    final steps = math.max(32, (size.width / 2).round());
    final path = Path()..moveTo(0, size.height);
    for (var i = 0; i <= steps; i++) {
      final x = i / steps * size.width;
      path.lineTo(x, elevationAt(x / size.height) * size.height);
    }
    path
      ..lineTo(size.width, size.height)
      ..close();
    return path;
  }
}

/// Full-screen backdrop: a dark sky with a warm glow on the horizon, layered
/// misty ridges along the bottom, and a film-grain overlay.
class HeroScene extends StatefulWidget {
  /// Asset key of the grain shader. When it cannot be loaded the scene
  /// renders without grain.
  final String grainShader;

  /// Asset key of the cloud shader, painted once and still. `null`, or a
  /// shader that cannot be loaded, leaves the sky clear.
  final String? cloudShader;

  const HeroScene({
    this.grainShader = 'shaders/grain.frag',
    this.cloudShader = 'shaders/sky_clouds.frag',
    super.key,
  });

  static const skyTop = Color(0xFF07070A);
  static const skyBottom = Color(0xFF1B1517);
  static const glow = Color(0xFF8A4232);
  static const mist = Color(0xFFC9BCBE);

  /// Text color over the scene.
  static const ink = Color(0xE6FFFFFF);

  /// Secondary text color over the scene.
  static const inkSoft = Color(0x99FFFFFF);

  /// Translucent fill of the bubbles and the email pill.
  static const glass = Color(0x1FFFFFFF);

  static const ridges = [
    // Far peaks catching the light, dissolving into haze at their base.
    Ridge(
      seed: 11,
      horizon: 0.73,
      amplitude: 0.1008,
      peaked: true,
      jaggedness: 0.82,
      variation: 183,
      top: Color(0xFFB0695A),
      bottom: Color(0xFF6A5A5E),
    ),
    Ridge(
      seed: 23,
      horizon: 0.79,
      amplitude: 0.0672,
      peaked: true,
      jaggedness: 0.82,
      variation: 183,
      top: Color(0xFF7D4D47),
      bottom: Color(0xFF55484D),
    ),
    // Forested hills in front.
    Ridge(
      seed: 37,
      horizon: 0.86,
      amplitude: 0.05,
      roughness: 0.6,
      top: Color(0xFF3B4555),
      bottom: Color(0xFF232A34),
    ),
    Ridge(
      seed: 41,
      horizon: 0.91,
      amplitude: 0.04,
      roughness: 0.9,
      top: Color(0xFF252D39),
      bottom: Color(0xFF151A21),
    ),
    Ridge(
      seed: 53,
      horizon: 0.96,
      amplitude: 0.03,
      roughness: 1,
      top: Color(0xFF151B23),
      bottom: Color(0xFF07090C),
    ),
  ];

  @override
  State<HeroScene> createState() => _HeroSceneState();
}

class _HeroSceneState extends State<HeroScene> {
  ui.FragmentShader? _grain;
  ui.FragmentShader? _clouds;

  @override
  void initState() {
    super.initState();
    _loadGrain();
    _loadClouds();
  }

  Future<void> _loadGrain() async {
    try {
      final program = await ui.FragmentProgram.fromAsset(widget.grainShader);
      if (!mounted) return;
      setState(() => _grain = program.fragmentShader());
    } on Object catch (_) {
      // No grain is better than no page.
    }
  }

  Future<void> _loadClouds() async {
    final asset = widget.cloudShader;
    if (asset == null) return;
    try {
      final program = await ui.FragmentProgram.fromAsset(asset);
      if (!mounted) return;
      setState(() => _clouds = program.fragmentShader());
    } on Object catch (_) {
      // A clear sky is better than no page.
    }
  }

  @override
  Widget build(BuildContext context) {
    final clouds = _clouds;
    return Stack(
      fit: StackFit.expand,
      children: [
        const RepaintBoundary(child: CustomPaint(painter: _SkyPainter())),
        if (clouds != null)
          RepaintBoundary(child: CustomPaint(painter: _CloudsPainter(clouds))),
        RepaintBoundary(
          child: CustomPaint(
            painter: _ScenePainter(grain: _grain),
            size: Size.infinite,
          ),
        ),
      ],
    );
  }
}

/// The still sky: dark gradient with the warm glow on the horizon.
class _SkyPainter extends CustomPainter {
  const _SkyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [HeroScene.skyTop, HeroScene.skyBottom],
        ).createShader(rect),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, 0.5),
          radius: 0.85,
          colors: [
            HeroScene.glow.withValues(alpha: 0.5),
            HeroScene.glow.withValues(alpha: 0),
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_SkyPainter oldDelegate) => false;
}

/// The clouds: one still frame of the shader, painted once.
class _CloudsPainter extends CustomPainter {
  final ui.FragmentShader shader;

  const _CloudsPainter(this.shader);

  /// Where in the noise the frame is taken from.
  static const cloudTime = 65.0;

  void _setColor(int index, Color c) {
    shader
      ..setFloat(index, c.r)
      ..setFloat(index + 1, c.g)
      ..setFloat(index + 2, c.b);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Fade out just above the highest far peak.
    final far = HeroScene.ridges.first;
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, cloudTime)
      ..setFloat(3, far.horizon - far.amplitude)
      ..setFloat(4, 0.22);
    _setColor(5, HeroScene.mist);
    _setColor(8, HeroScene.glow);
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_CloudsPainter oldDelegate) =>
      oldDelegate.shader != shader;
}

class _ScenePainter extends CustomPainter {
  final ui.FragmentShader? grain;

  const _ScenePainter({this.grain});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final ridges = HeroScene.ridges;
    for (final ridge in ridges.where((r) => r.peaked)) {
      _paintRidge(canvas, size, ridge);
    }
    _paintValleyHaze(canvas, size, ridges);
    for (final ridge in ridges.where((r) => !r.peaked)) {
      _paintRidge(canvas, size, ridge);
    }
    _paintGrain(canvas, rect);
  }

  /// Haze pooled in the valley where the peaks meet the forest. Clipped to
  /// the farthest ridge so it never bleeds into the sky.
  void _paintValleyHaze(Canvas canvas, Size size, List<Ridge> ridges) {
    final forest = ridges.firstWhere((r) => !r.peaked);
    final crest = (forest.horizon - forest.amplitude) * size.height;
    final band = Rect.fromLTRB(
      0,
      crest - size.height * 0.12,
      size.width,
      crest + size.height * 0.06,
    );
    canvas
      ..save()
      ..clipPath(ridges.first.path(size))
      ..drawRect(
        band,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              HeroScene.mist.withValues(alpha: 0),
              HeroScene.mist.withValues(alpha: 0.28),
            ],
          ).createShader(band),
      )
      ..restore();
  }

  void _paintRidge(Canvas canvas, Size size, Ridge ridge) {
    final path = ridge.path(size);
    final bounds = path.getBounds();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ridge.top, ridge.bottom],
        ).createShader(bounds),
    );
  }

  void _paintGrain(Canvas canvas, Rect rect) {
    final shader = grain;
    if (shader == null) return;
    shader.setFloat(0, 0.07);
    canvas.drawRect(rect, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_ScenePainter oldDelegate) => oldDelegate.grain != grain;
}
