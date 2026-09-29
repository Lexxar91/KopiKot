import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/presentation/widgets/home_scene.dart';

import 'game_rules_test.dart' show initialProfile;

void main() {
  for (final height in [640.0, 780.0]) {
    testWidgets('Новые кнопки не переполняются при высоте $height', (
      tester,
    ) async {
      tester.view.physicalSize = Size(360, height);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: HomeScene(
            profile: initialProfile,
            sections: const [],
            goalTitle: 'Беговая дорожка',
            goalSaved: 20,
            goalPrice: 400,
            needsVetVisit: false,
            onGarden: () {},
            onShop: () {},
            onVet: () {},
            onTasks: () {},
            onDemo: () {},
            onWalk: () {},
            onDailyTip: () {},
            onStory: () {},
            onSavings: () {},
            onReward: () {},
          ),
        ),
      );
      await tester.scrollUntilVisible(
        find.text('Совет дня'),
        120,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('История'), findsOneWidget);
      expect(find.text('Демо'), findsOneWidget);
      expect(find.text('Играть'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
