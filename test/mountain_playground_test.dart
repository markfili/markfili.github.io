import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/dev/mountain_playground.dart';
import 'package:showcase/widgets/hero_scene.dart';

void main() {
  test('playground starts at the hero\'s values', () {
    expect(
      Dials.fromHero().describe(),
      'outline: midpoint, jaggedness: 0.82, height: 0.84, seed: 183',
    );
  });

  test('playground ridges match the hero', () {
    final mine = Dials.fromHero().ridges();
    expect(mine, hasLength(HeroScene.ridges.length));
    for (var i = 0; i < mine.length; i++) {
      for (var t = 0.0; t <= 3; t += 0.01) {
        expect(
          mine[i].elevationAt(t),
          closeTo(HeroScene.ridges[i].elevationAt(t), 1e-9),
          reason: 'ridge $i at t=$t',
        );
      }
    }
  });

  testWidgets('playground renders and responds', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: MountainPlayground()));
    await tester.pump();
    expect(find.textContaining('seed: 183'), findsWidgets);
    await tester.tap(find.byTooltip('Next variation'));
    await tester.pump();
    expect(find.textContaining('seed: 184'), findsWidgets);
  });
}
