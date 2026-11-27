import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// One bar of a [YearsTimeline]: a label and the years it covers, each span
/// inclusive (2020–2022 covers three whole years).
class TimelineRow {
  final String label;
  final List<(int, int)> spans;

  /// The years as written in the table, for the tooltip.
  final String years;

  const TimelineRow(this.label, this.spans, this.years);
}

/// Rows under one `##` heading of a page.
class TimelineGroup {
  final String? title;
  final List<TimelineRow> rows;

  const TimelineGroup(this.title, this.rows);
}

/// Every table row with a "Years" column in [markdown], grouped by the `##`
/// heading above it. "now" means [now]; "2016 – 2019, 2026" gives two spans.
/// Rows whose years don't parse are left out.
List<TimelineGroup> parseTimeline(String markdown, {required int now}) {
  final groups = <TimelineGroup>[];
  String? heading;
  var rows = <TimelineRow>[];
  int? yearsColumn;

  void flush() {
    if (rows.isNotEmpty) groups.add(TimelineGroup(heading, rows));
    rows = <TimelineRow>[];
  }

  for (final line in markdown.split('\n')) {
    if (line.startsWith('## ')) {
      flush();
      heading = line.substring(3).trim();
      yearsColumn = null;
      continue;
    }
    if (!line.startsWith('|')) {
      yearsColumn = null;
      continue;
    }
    final cells = line
        .trim()
        .replaceAll(RegExp(r'^\||\|$'), '')
        .split('|')
        .map((c) => c.trim())
        .toList();
    if (yearsColumn == null) {
      final i = cells.indexOf('Years');
      if (i > 0) yearsColumn = i;
      continue;
    }
    if (cells.every((c) => RegExp(r'^:?-+:?$').hasMatch(c))) continue;
    if (yearsColumn >= cells.length) continue;
    final spans = _spans(cells[yearsColumn], now);
    if (spans.isEmpty) continue;
    rows.add(TimelineRow(shortLabel(cells.first), spans, cells[yearsColumn]));
  }
  flush();
  return groups;
}

List<(int, int)> _spans(String years, int now) {
  final spans = <(int, int)>[];
  for (final part in years.split(',')) {
    final ends = part.split(RegExp(r'[–-]')).map((e) => e.trim()).toList();
    int? year(String s) => s == 'now' ? now : int.tryParse(s);
    final start = year(ends.first);
    final end = year(ends.last);
    if (start == null || end == null || ends.length > 2) return const [];
    spans.add((start, end));
  }
  return spans;
}

/// A table cell cut to a chart label: no bold markers, nothing in brackets
/// and nothing after a colon.
String shortLabel(String cell) => cell
    .replaceAll('**', '')
    .replaceAll(RegExp(r'\s*\([^)]*\)'), '')
    .split(':')
    .first
    .trim();

/// The years of a page's tables as horizontal bars on one shared axis, so
/// how long and how recent read at a glance. Purely visual: the tables
/// below it carry the same facts for screen readers and the plain-text
/// profile.
class YearsTimeline extends StatelessWidget {
  final List<TimelineGroup> groups;

  const YearsTimeline(this.groups, {super.key});

  static const _barHeight = 6.0;

  /// Below this width the label goes above its bar instead of beside it.
  static const _sideBySide = 560.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;
    final rows = [for (final g in groups) ...g.rows];
    if (rows.isEmpty) return const SizedBox.shrink();
    final first = rows.map((r) => r.spans.first.$1).reduce(math.min);
    final last = rows.map((r) => r.spans.last.$2).reduce(math.max);
    final years = last - first + 1;
    final step = years > 7 ? 2 : 1;
    final labelStyle = text.bodySmall?.copyWith(color: colors.onSurface);
    final axisStyle = text.labelSmall?.copyWith(color: colors.onSurfaceVariant);
    final groupStyle = text.labelMedium?.copyWith(
      color: colors.onSurfaceVariant,
      letterSpacing: 0.4,
    );

    return ExcludeSemantics(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= _sideBySide;
          final labelWidth = wide ? constraints.maxWidth * 0.36 : 0.0;
          final gap = wide ? 16.0 : 0.0;

          // Year ticks and faint gridlines behind the bars.
          Widget track({required Widget child, double height = _barHeight}) =>
              LayoutBuilder(
                builder: (context, c) {
                  final perYear = c.maxWidth / years;
                  return SizedBox(
                    height: height,
                    child: CustomPaint(
                      painter: _Grid(
                        lines: [
                          for (var y = first; y <= last + 1; y += step)
                            (y - first) * perYear,
                        ],
                        color: colors.outlineVariant.withValues(alpha: 0.5),
                      ),
                      child: child,
                    ),
                  );
                },
              );

          Widget bars(TimelineRow row) => track(
            child: LayoutBuilder(
              builder: (context, c) {
                final perYear = c.maxWidth / years;
                return Stack(
                  children: [
                    for (final (from, to) in row.spans)
                      Positioned(
                        left: (from - first) * perYear + 1,
                        width: (to - from + 1) * perYear - 2,
                        top: 0,
                        bottom: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(_barHeight),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          );

          Widget label(TimelineRow row) => Text(
            row.label,
            style: labelStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );

          Widget entry(TimelineRow row) => Tooltip(
            message: '${row.label}: ${row.years}',
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: wide ? 5 : 4),
              child: wide
                  ? Row(
                      children: [
                        SizedBox(width: labelWidth, child: label(row)),
                        SizedBox(width: gap),
                        Expanded(child: bars(row)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        label(row),
                        const SizedBox(height: 4),
                        bars(row),
                      ],
                    ),
            ),
          );

          final axis = Row(
            children: [
              SizedBox(width: labelWidth + gap),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, c) {
                    final perYear = c.maxWidth / years;
                    return SizedBox(
                      height: 18,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          for (var y = first; y <= last; y += step)
                            Positioned(
                              left: (y - first) * perYear,
                              width: perYear * step,
                              child: Text(
                                // Two digits on phones so ticks never collide.
                                wide || step == 1 ? '$y' : "'${y % 100}",
                                style: axisStyle,
                                maxLines: 1,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );

          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                axis,
                for (final group in groups) ...[
                  if (group.title != null && groups.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 14, bottom: 2),
                      child: Text(group.title!, style: groupStyle),
                    ),
                  for (final row in group.rows) entry(row),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Grid extends CustomPainter {
  final List<double> lines;
  final Color color;

  const _Grid({required this.lines, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (final x in lines) {
      canvas.drawLine(Offset(x, -4), Offset(x, size.height + 4), paint);
    }
  }

  @override
  bool shouldRepaint(_Grid old) => old.lines != lines || old.color != color;
}
