import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/models/learning_scenario.dart';
import 'package:kopikot/domain/models/learning_task.dart';
import 'package:kopikot/presentation/providers/game_controller.dart';
import 'package:kopikot/presentation/screens/learning_challenge_screen.dart';
import 'package:kopikot/presentation/widgets/pet_portrait.dart';

class _ReadyController extends GameController {
  @override
  Future<GameProfile?> build() async => const GameProfile(
    petName: 'Лут',
    coat: PetCoat.white,
    accessory: PetAccessory.wristbands,
    balance: 30,
    savings: 0,
    period: 1,
    satiety: 70,
    mood: 70,
    incomeSource: 'Награда',
    incomeAmount: 10,
  );
}

void main() {
  const cases = <(String, String, String)>[
    ('need_first', 'Покупки', 'food'),
    ('day_plan', 'Планирование', 'vet'),
    ('regular_saving', 'Сбережения', 'sapling'),
    ('saving_target', 'Сбережения', 'goal'),
    ('compare_price', 'Покупки', 'a'),
    ('free_paid', 'Планирование', 'treat'),
  ];

  for (final (id, topic, illustration) in cases) {
    testWidgets('$id: предметы и выбранный котик видны без переполнения', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = ProviderContainer(
        overrides: [gameControllerProvider.overrideWith(_ReadyController.new)],
      );
      addTearDown(container.dispose);
      await container.read(gameControllerProvider.future);
      final task = LearningTask(
        id: id,
        title: 'Задание',
        topic: topic,
        kind: TaskKind.choice,
        prompt: '',
        budget: 20,
        minimumNeeds: 0,
        minimumSavings: 0,
        goalRemaining: 0,
        reward: 12,
        success: '',
        retry: '',
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: LearningChallengeScreen(task: task)),
        ),
      );
      await tester.pumpAndSettle();
      final portrait = tester.widget<PetPortrait>(find.byType(PetPortrait));
      expect(portrait.coat, PetCoat.white);
      expect(portrait.accessory, PetAccessory.wristbands);
      expect(find.byKey(ValueKey('task-art-$illustration')), findsWidgets);
      expect(
        find.text(
          LearningScenario.forTask(id, LearningDifficulty.simple).prompt,
        ),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(
        find.text('Проверить ответ'),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
