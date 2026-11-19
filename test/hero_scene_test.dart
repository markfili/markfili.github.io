import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/widgets/hero_scene.dart';

const ridge = Ridge(
  seed: 7,
  horizon: 0.7,
  amplitude: 0.1,
  top: Colors.red,
  bottom: Colors.black,
);

void main() {
  group('Ridge', () {
    test('elevation is deterministic for the same seed', () {
      const twin = Ridge(
        seed: 7,
        horizon: 0.7,
        amplitude: 0.1,
        top: Colors.red,
        bottom: Colors.black,
      );
      for (var i = 0; i <= 20; i++) {
        final t = i / 20;
        expect(ridge.elevationAt(t), twin.elevationAt(t));
      }
    });

    test('elevation stays within horizon plus or minus amplitude', () {
      for (var i = 0; i <= 200; i++) {
        final e = ridge.elevationAt(i / 200);
        expect(e, inInclusiveRange(0.6, 0.8), reason: 't=${i / 200}');
      }
    });

    test('peaked and rough profiles still stay within the band', () {
      const rough = Ridge(
        seed: 3,
        horizon: 0.7,
        amplitude: 0.1,
        roughness: 1,
        peaked: true,
        top: Colors.red,
        bottom: Colors.black,
      );
      for (var i = 0; i <= 400; i++) {
        expect(rough.elevationAt(i / 400 * 3), inInclusiveRange(0.6, 0.8));
      }
    });

    group('midpoint outline', () {
      Ridge mid({int variation = 0}) => Ridge(
        seed: 7,
        horizon: 0.7,
        amplitude: 0.1,
        jaggedness: 0.82,
        variation: variation,
        top: Colors.red,
        bottom: Colors.black,
      );

      test('stays within the band', () {
        final r = mid();
        for (var t = 0.0; t <= 12; t += 0.003) {
          expect(r.elevationAt(t), inInclusiveRange(0.6, 0.8), reason: 't=$t');
        }
      });

      test('is jagged', () {
        int peaks(Ridge r) {
          final v = [for (var t = 0.0; t <= 1.6; t += 0.002) r.elevationAt(t)];
          var n = 0;
          for (var i = 1; i < v.length - 1; i++) {
            if (v[i] > v[i - 1] && v[i] >= v[i + 1]) n++;
          }
          return n;
        }

        expect(peaks(mid()), greaterThan(40));
        expect(peaks(ridge), lessThan(10));
      });

      test('continues past its span', () {
        final r = mid();
        final v = [for (var t = 4.5; t <= 6.0; t += 0.003) r.elevationAt(t)];
        final spread = v.reduce(math.max) - v.reduce(math.min);
        expect(spread, greaterThan(0.3 * 0.1));
      });

      test('variation changes the outline', () {
        final a = mid(), b = mid(variation: 1);
        final differs = [for (var t = 0.0; t <= 2; t += 0.01) t]
            .any((t) => a.elevationAt(t) != b.elevationAt(t));
        expect(differs, isTrue);
      });
    });

    test('different seeds give different profiles', () {
      const other = Ridge(
        seed: 8,
        horizon: 0.7,
        amplitude: 0.1,
        top: Colors.red,
        bottom: Colors.black,
      );
      final same = List.generate(50, (i) => i / 50).every(
        (t) => (ridge.elevationAt(t) - other.elevationAt(t)).abs() < 1e-6,
      );
      expect(same, isFalse);
    });

    test('path spans the full width and is anchored to the bottom edge', () {
      const size = Size(400, 300);
      final bounds = ridge.path(size).getBounds();
      expect(bounds.left, closeTo(0, 0.01));
      expect(bounds.right, closeTo(400, 0.01));
      expect(bounds.bottom, closeTo(300, 0.01));
      expect(bounds.top, inInclusiveRange(180, 240));
    });
  });

  group('HeroScene', () {
    testWidgets('paints the ridges', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HeroScene()));
      await tester.pump();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders without grain when the shader is unavailable', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: HeroScene(grainShader: 'shaders/missing.frag')),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(HeroScene), findsOneWidget);
    });

    testWidgets('clouds are painted and the scene is idle', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HeroScene()));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)),
      );
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without clouds when the shader is unavailable', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: HeroScene(cloudShader: 'shaders/missing.frag')),
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.byType(HeroScene), findsOneWidget);
    });
  });
}
