import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../data/profile.dart';
import 'hero_scene.dart';

/// "I modernise legacy Django apps." and the rest of [Profile.offers], one
/// at a time: the verb stays put while the tail drifts in like mist, and
/// the verb only fades when it changes.
///
/// [wide] puts the verb and tail on one line, with the tails in a fixed
/// column so the verb never shifts sideways; otherwise they stack, centred.
/// With reduced motion on, only the lead offer shows. Screen readers hear
/// [Profile.offersSentence] once instead of every rotation.
class OfferTicker extends StatefulWidget {
  final bool wide;

  const OfferTicker({required this.wide, super.key});

  /// Font size of the line; [MenuLayout] reserves room from these.
  static const wideFontSize = 26.0;
  static const narrowFontSize = 20.0;

  /// How long each line stays; the lead offer gets longer.
  static const leadHold = Duration(milliseconds: 5000);
  static const hold = Duration(milliseconds: 3200);
  static const fade = Duration(milliseconds: 900);

  /// Every (verb, tail) pair in order.
  static final lines = [
    for (final o in Profile.offers)
      for (final t in o.tails) (verb: o.verb, tail: t),
  ];

  @override
  State<OfferTicker> createState() => _OfferTickerState();
}

class _OfferTickerState extends State<OfferTicker> {
  var _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // The columns are measured in build; measure again once DM Mono has
    // loaded, or the verb stays clipped to the fallback font's width.
    PaintingBinding.instance.systemFonts.addListener(_fontsChanged);
  }

  void _fontsChanged() => setState(() {});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _timer?.cancel();
      _timer = null;
      _index = 0;
    } else {
      _timer ??= _schedule();
    }
  }

  Timer _schedule() =>
      Timer(_index == 0 ? OfferTicker.leadHold : OfferTicker.hold, () {
        if (!mounted) return;
        setState(() => _index = (_index + 1) % OfferTicker.lines.length);
        _timer = _schedule();
      });

  @override
  void dispose() {
    PaintingBinding.instance.systemFonts.removeListener(_fontsChanged);
    _timer?.cancel();
    super.dispose();
  }

  /// The outgoing line drifts up and fades in the first half; the incoming
  /// one rises into place in the second, so the two never overlap.
  static AnimatedSwitcherTransitionBuilder _drift(Key current) =>
      (child, animation) {
        final incoming = child.key == current;
        final curved = CurvedAnimation(
          parent: animation,
          curve: incoming
              ? const Interval(0.5, 1, curve: Curves.easeOutCubic)
              : const Interval(0.5, 1, curve: Curves.easeInCubic),
        );
        final from = Offset(0, incoming ? 0.35 : -0.35);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(begin: from, end: Offset.zero).animate(curved),
            child: child,
          ),
        );
      };

  Widget _switch(String text, TextStyle style, Alignment alignment) {
    return AnimatedSwitcher(
      duration: OfferTicker.fade,
      transitionBuilder: _drift(ValueKey(text)),
      layoutBuilder: (current, previous) =>
          Stack(alignment: alignment, children: [...previous, ?current]),
      child: Text(
        text,
        key: ValueKey(text),
        style: style,
        maxLines: 1,
        softWrap: false,
      ),
    );
  }

  /// Width of the widest of [texts] in [style], so the line keeps one width
  /// while it rotates.
  double _widest(Iterable<String> texts, TextStyle style) {
    var widest = 0.0;
    for (final t in texts) {
      final painter = TextPainter(
        text: TextSpan(text: t, style: style),
        textDirection: TextDirection.ltr,
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: 1,
      )..layout();
      if (painter.width > widest) widest = painter.width;
      painter.dispose();
    }
    return widest.ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    final line = OfferTicker.lines[_index];
    final base = Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontSize: widget.wide
          ? OfferTicker.wideFontSize
          : OfferTicker.narrowFontSize,
      fontWeight: FontWeight.w300,
      height: 1.3,
      letterSpacing: 0,
    );
    final verbStyle =
        base?.copyWith(color: HeroScene.inkSoft) ?? const TextStyle();
    final tailStyle = base?.copyWith(color: HeroScene.ink) ?? const TextStyle();
    final verbs = Profile.offers.map((o) => o.verb);
    final tails = OfferTicker.lines.map((l) => l.tail);

    final Widget body;
    if (widget.wide) {
      final space = _widest([' '], tailStyle);
      body = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _widest(verbs, verbStyle),
            child: _switch(line.verb, verbStyle, Alignment.centerRight),
          ),
          SizedBox(width: space),
          SizedBox(
            width: _widest(tails, tailStyle),
            child: _switch(line.tail, tailStyle, Alignment.centerLeft),
          ),
        ],
      );
    } else {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _switch(line.verb, verbStyle, Alignment.center),
          _switch(line.tail, tailStyle, Alignment.center),
        ],
      );
    }
    return Semantics(
      label: Profile.offersSentence,
      // Scales down rather than overflowing if a large text size or a
      // fallback font makes the line wider than the screen.
      child: ExcludeSemantics(
        child: FittedBox(fit: BoxFit.scaleDown, child: body),
      ),
    );
  }
}
