// Dev page for tuning the far mountains by hand, opened with
// ?playground=mountains. It paints [HeroScene.ridges] rebuilt from the dials,
// so what is tuned here is what the hero draws.
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../widgets/hero_scene.dart';

enum Outline { today, ridged, midpoint }

class Dials {
  Outline outline = Outline.midpoint;

  // Ridged fractal noise.
  double roughness = 0.48; // how strongly each finer layer shows
  double farPeaks = 1.9; // big mountains per screen height, far range
  double nearPeaks = 2.6; // same, nearer range
  double crestCling = 2.0; // how much detail sticks to the high ground

  // Midpoint displacement.
  double jaggedness = 0.82; // lower = rougher

  // Shared.
  double height = 0.84; // multiplies each range's height band
  int seed = 183; // shifts every range to a different variation
  bool clouds = true;

  Dials();

  /// The dials the hero itself was tuned with.
  factory Dials.fromHero() => Dials();

  /// Heights of the peaked ridges at `height: 1`, far range first.
  static const _baseAmplitudes = [0.12, 0.08];

  /// [HeroScene.ridges] with the peaked ones rebuilt from these dials.
  List<Ridge> ridges() {
    var peaked = 0;
    return [
      for (final r in HeroScene.ridges)
        if (r.peaked)
          _peaked(r, _baseAmplitudes[peaked] * height, far: peaked++ == 0)
        else
          r,
    ];
  }

  Ridge _peaked(Ridge r, double amplitude, {required bool far}) =>
      switch (outline) {
        Outline.ridged => _RidgedRidge(r, amplitude, this, far: far),
        _ => Ridge(
          seed: r.seed,
          horizon: r.horizon,
          amplitude: amplitude,
          peaked: true,
          jaggedness: outline == Outline.midpoint ? jaggedness : null,
          variation: seed,
          top: r.top,
          bottom: r.bottom,
        ),
      };

  String describe() => switch (outline) {
    Outline.today => 'outline: today, height: ${_f(height)}',
    Outline.ridged =>
      'outline: ridged, roughness: ${_f(roughness)}, farPeaks: ${_f(farPeaks)}, '
          'nearPeaks: ${_f(nearPeaks)}, crestCling: ${_f(crestCling)}, '
          'height: ${_f(height)}, seed: $seed',
    Outline.midpoint =>
      'outline: midpoint, jaggedness: ${_f(jaggedness)}, height: ${_f(height)}, '
          'seed: $seed',
  };

  static String _f(double v) => v.toStringAsFixed(2);
}

double _hash(int seed, int i) {
  var h = seed * 374761393 + i * 668265263;
  h = (h ^ (h >> 13)) * 1274126177;
  h = h ^ (h >> 16);
  return (h & 0xffff) / 0xffff * 2 - 1;
}

double _noise(int seed, double x) {
  final i = x.floor();
  final f = x - i;
  final u = f * f * (3 - 2 * f);
  return _hash(seed, i) * (1 - u) + _hash(seed, i + 1) * u;
}

/// Playground-only outline: ridged fractal noise, sampled once across
/// [span] canvas heights and normalised to [0, 1] (1 = summit).
class _RidgedRidge extends Ridge {
  static const span = 4.0;
  static const samples = 4000;

  final List<double> _values;

  _RidgedRidge(Ridge base, double amplitude, Dials d, {required bool far})
    : _values = _profile(base.seed + d.seed * 101, d, far: far),
      super(
        seed: base.seed,
        horizon: base.horizon,
        amplitude: amplitude,
        peaked: true,
        top: base.top,
        bottom: base.bottom,
      );

  static List<double> _profile(int seed, Dials d, {required bool far}) {
    final raw = [
      for (var i = 0; i <= samples; i++)
        _ridged(seed, i / samples * span, d, far: far),
    ];
    var lo = raw.first, hi = raw.first;
    for (final v in raw) {
      if (v < lo) lo = v;
      if (v > hi) hi = v;
    }
    return [for (final v in raw) (v - lo) / (hi - lo)];
  }

  static double _ridged(int seed, double t, Dials d, {required bool far}) {
    var freq = far ? d.farPeaks : d.nearPeaks;
    var amp = 1.0, weight = 1.0, sum = 0.0;
    for (var o = 0; o < 7; o++) {
      var n = 1 - _noise(seed * 31 + o, t * freq).abs();
      n = n * n * weight;
      weight = (n * d.crestCling).clamp(0.0, 1.0);
      sum += n * amp;
      freq *= 2.2;
      amp *= d.roughness;
    }
    return sum;
  }

  @override
  double elevationAt(double t) {
    final x = (t / span).clamp(0.0, 1.0) * (_values.length - 1);
    final i = x.floor().clamp(0, _values.length - 2);
    final h = _values[i] * (1 - (x - i)) + _values[i + 1] * (x - i);
    return horizon - amplitude * (2 * h - 1);
  }
}

class MountainPlayground extends StatefulWidget {
  const MountainPlayground({super.key});

  @override
  State<MountainPlayground> createState() => _MountainPlaygroundState();
}

class _MountainPlaygroundState extends State<MountainPlayground> {
  final _dials = Dials.fromHero();
  ui.FragmentShader? _clouds;
  ui.FragmentShader? _grain;
  List<Ridge> _ridges = const [];

  @override
  void initState() {
    super.initState();
    _rebuild();
    _load();
  }

  Future<void> _load() async {
    try {
      final c = await ui.FragmentProgram.fromAsset('shaders/sky_clouds.frag');
      final g = await ui.FragmentProgram.fromAsset('shaders/grain.frag');
      if (!mounted) return;
      setState(() {
        _clouds = c.fragmentShader();
        _grain = g.fragmentShader();
      });
    } on Object catch (_) {}
  }

  void _rebuild() => _ridges = _dials.ridges();

  void _set(VoidCallback change) => setState(() {
    change();
    _rebuild();
  });

  Widget _slider(
    String label,
    String help,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(2)}'),
        Text(help, style: Theme.of(context).textTheme.bodySmall),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = _dials;
    final panel = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Mountain dials', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SegmentedButton<Outline>(
          segments: const [
            ButtonSegment(value: Outline.today, label: Text('Today')),
            ButtonSegment(value: Outline.ridged, label: Text('Ridged')),
            ButtonSegment(value: Outline.midpoint, label: Text('Midpoint')),
          ],
          selected: {d.outline},
          onSelectionChanged: (s) => _set(() => d.outline = s.first),
        ),
        const SizedBox(height: 16),
        if (d.outline == Outline.ridged) ...[
          _slider(
            'Roughness',
            'Higher = craggier, lower = calmer',
            d.roughness,
            0.3,
            0.7,
            (v) => _set(() => d.roughness = v),
          ),
          _slider(
            'Far peaks',
            'Big mountains in the far range',
            d.farPeaks,
            0.8,
            5,
            (v) => _set(() => d.farPeaks = v),
          ),
          _slider(
            'Near peaks',
            'Big mountains in the nearer range',
            d.nearPeaks,
            0.8,
            5,
            (v) => _set(() => d.nearPeaks = v),
          ),
          _slider(
            'Crest cling',
            'Higher = detail only on the summits, smoother valleys',
            d.crestCling,
            0.5,
            4,
            (v) => _set(() => d.crestCling = v),
          ),
        ],
        if (d.outline == Outline.midpoint)
          _slider(
            'Jaggedness',
            'Lower = rougher, higher = smoother',
            d.jaggedness,
            0.4,
            1.2,
            (v) => _set(() => d.jaggedness = v),
          ),
        _slider(
          'Height',
          'How tall the mountains rise',
          d.height,
          0.5,
          1.8,
          (v) => _set(() => d.height = v),
        ),
        if (d.outline != Outline.today)
          Row(
            children: [
              Text('Variation: ${d.seed}'),
              const Spacer(),
              IconButton(
                tooltip: 'Previous variation',
                onPressed: () => _set(() => d.seed--),
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                tooltip: 'Next variation',
                onPressed: () => _set(() => d.seed++),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Clouds'),
          value: d.clouds,
          onChanged: (v) => setState(() => d.clouds = v),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: d.describe()));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Values copied. Paste them to me.')),
            );
          },
          icon: const Icon(Icons.content_copy),
          label: const Text('Copy values'),
        ),
        const SizedBox(height: 8),
        SelectableText(d.describe()),
      ],
    );
    final scene = RepaintBoundary(
      child: CustomPaint(
        painter: _ScenePainter(
          ridges: _ridges,
          clouds: d.clouds ? _clouds : null,
          grain: _grain,
          version: Object(),
        ),
        size: Size.infinite,
      ),
    );
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, c) => c.maxWidth >= 900
            ? Row(
                children: [
                  Expanded(child: scene),
                  SizedBox(width: 340, child: panel),
                ],
              )
            : Column(
                children: [
                  Expanded(flex: 3, child: scene),
                  Expanded(flex: 2, child: panel),
                ],
              ),
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  final List<Ridge> ridges;
  final ui.FragmentShader? clouds;
  final ui.FragmentShader? grain;
  final Object version;

  _ScenePainter({
    required this.ridges,
    required this.clouds,
    required this.grain,
    required this.version,
  });

  @override
  void paint(Canvas c, Size s) {
    final rect = Offset.zero & s;
    c.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [HeroScene.skyTop, HeroScene.skyBottom],
        ).createShader(rect),
    );
    c.drawRect(
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
    final cl = clouds;
    if (cl != null) {
      final far = ridges.first;
      cl
        ..setFloat(0, s.width)
        ..setFloat(1, s.height)
        ..setFloat(2, 65)
        ..setFloat(3, far.horizon - far.amplitude)
        ..setFloat(4, 0.22);
      for (final (i, col) in [(5, HeroScene.mist), (8, HeroScene.glow)]) {
        cl
          ..setFloat(i, col.r)
          ..setFloat(i + 1, col.g)
          ..setFloat(i + 2, col.b);
      }
      c.drawRect(rect, Paint()..shader = cl);
    }
    for (final r in ridges) {
      final path = r.path(s);
      c.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [r.top, r.bottom],
          ).createShader(path.getBounds()),
      );
    }
    final g = grain;
    if (g != null) {
      g.setFloat(0, 0.07);
      c.drawRect(rect, Paint()..shader = g);
    }
  }

  @override
  bool shouldRepaint(_ScenePainter old) => old.version != version;
}
