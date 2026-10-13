import 'package:flutter/material.dart';
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

    test('different seeds give different profiles', () {
      const other = Ridge(
        seed: 8,
        horizon: 0.7,
        amplitude: 0.1,
        top: Colors.red,
        bottom: Colors.black,
      );
      final same = List.generate(50, (i) => i / 50).every(
          (t) => (ridge.elevationAt(t) - other.elevationAt(t)).abs() < 1e-6);
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

    testWidgets('renders without grain when the shader is unavailable',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HeroScene(grainShader: 'shaders/missing.frag')),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(HeroScene), findsOneWidget);
    });
  });
}
