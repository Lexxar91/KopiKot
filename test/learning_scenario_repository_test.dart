import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/data/local/local_game_store.dart';
import 'package:kopikot/data/repositories/local_game_repository.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/models/learning_task.dart';

import 'support/native_isar.dart';

void main() {
  final catalog = parseGameCatalog(
    File('assets/content/catalog.json').readAsStringSync(),
    taskSource: File('assets/content/tasks.json').readAsStringSync(),
  );
  setUpAll(initializeTestIsar);

  test('Уровень темы и первая награда сохраняются после перезапуска', () async {
    final directory = await Directory.systemTemp.createTemp(
      'kopikot_learning_',
    );
    var store = await LocalGameStore.open(
      directory: directory.path,
      name: 'learning',
    );
    try {
      var repository = LocalGameRepository(store, catalog);
      await repository.createProfile(
        petName: 'Мурзик',
        coat: PetCoat.grey,
        accessory: PetAccessory.scarf,
      );
      await repository.confirmBudget(needs: 50, wants: 20, savings: 30);
      await repository.chooseLearningDifficulty(
        'Покупки',
        LearningDifficulty.medium,
      );
      final before = (await repository.loadProfile())!.balance;
      var profile = await repository.submitTask(
        'need_first',
        const TaskAnswer(choice: 'food'),
      );
      expect(profile.balance, before + 12);
      await store.close();
      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'learning',
      );
      repository = LocalGameRepository(store, catalog);
      profile = (await repository.loadProfile())!;
      expect(
        profile.learningTopic('Покупки').difficulty,
        LearningDifficulty.medium,
      );
      expect(profile.completedTask('need_first'), isTrue);
      expect(profile.taskProgress.single.attempts, 1);
      profile = await repository.submitTask(
        'need_first',
        const TaskAnswer(choice: 'food'),
      );
      expect(profile.balance, before + 12);
    } finally {
      await store.close();
      await directory.delete(recursive: true);
    }
  });
}
