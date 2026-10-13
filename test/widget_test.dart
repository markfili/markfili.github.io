import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/main.dart';
import 'package:showcase/utils/widgets.dart';
import 'package:showcase/widgets/hero_scene.dart';

void main() {
  testWidgets('home page shows the brand, the scene and the contact badges',
      (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('arilus'), findsOneWidget);
    expect(find.byType(HeroScene), findsOneWidget);
    expect(find.byType(ContactBadge), findsNWidgets(4));
  });
}
