import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/local/local_game_store.dart';
import '../../data/content/help_loader.dart';
import '../../data/content/catalog_loader.dart';
import '../../data/repositories/local_game_repository.dart';
import '../../domain/models/game_profile.dart';
import '../../domain/models/game_catalog.dart';
import '../../domain/models/learning_task.dart';
import '../../domain/models/help_topic.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/rules/game_rules.dart';
import '../../domain/rules/mini_game_rules.dart';

/// Точка сборки зависимостей: виджеты не знают ни о каталогах, ни об Isar.
final gameRepositoryProvider = FutureProvider<GameRepository>((ref) async {
  final catalog = await ref.watch(gameCatalogProvider.future);
  final directory = await getApplicationSupportDirectory();
  final LocalGameStore store = await LocalGameStore.open(
    directory: directory.path,
  );
  ref.onDispose(() {
    store.close();
  });
  return LocalGameRepository(store, catalog);
});

final gameCatalogProvider = FutureProvider<GameCatalog>(
  (ref) => loadGameCatalog(),
);

/// ID создаётся один раз на диалог и повторно используется при ошибке сохранения.
String newCommandId() {
  final random = Random.secure();
  return List.generate(
    4,
    (_) => random.nextInt(1 << 32).toRadixString(16).padLeft(8, '0'),
  ).join();
}

final gameControllerProvider =
    AsyncNotifierProvider<GameController, GameProfile?>(GameController.new);

/// Не смешивает общие настройки устройства с игровыми монетами и прогрессом.
final reduceMotionProvider =
    AsyncNotifierProvider<ReduceMotionController, bool>(
      ReduceMotionController.new,
    );

/// Публикует настройку только после сохранения, не меняя активный профиль.
class ReduceMotionController extends AsyncNotifier<bool> {
  bool _saving = false;
  @override
  Future<bool> build() async =>
      (await ref.watch(gameRepositoryProvider.future)).loadReduceMotion();

  Future<void> save(bool value) async {
    if (_saving) {
      throw const GameRuleException('Подожди, настройка сохраняется.');
    }
    _saving = true;
    try {
      await (await ref.read(
        gameRepositoryProvider.future,
      )).saveReduceMotion(value);
      if (ref.mounted) state = AsyncData(value);
    } finally {
      _saving = false;
    }
  }
}

/// Справочный контент поставляется вместе с приложением и доступен без сети.
final helpProvider = FutureProvider<List<HelpTopic>>((ref) => loadHelpTopics());

/// Публикует состояние только после успешной записи; ошибка не скрывает прогресс.
class GameController extends AsyncNotifier<GameProfile?> {
  bool _busy = false;

  Future<void> switchProfile({required bool testProfile}) => _perform(
    (repository) => repository.switchProfile(testProfile: testProfile),
  );
  Future<void> resetTestProfile() =>
      _perform((repository) => repository.resetTestProfile());
  Future<void> deleteRegularProfile() => _perform((repository) async {
    await repository.deleteRegularProfile();
    return null;
  });

  Future<void> submitTask(String taskId, TaskAnswer answer) =>
      _perform((repository) => repository.submitTask(taskId, answer));
  Future<void> claimMiniGame(MiniGameKind kind, String commandId) =>
      _perform((repository) => repository.claimMiniGame(kind, commandId));
  Future<void> claimDailyReward() =>
      _perform((repository) => repository.claimDailyReward());
  Future<void> finishPeriod(int expectedPeriod) =>
      _perform((repository) => repository.finishPeriod(expectedPeriod));

  @override
  Future<GameProfile?> build() async {
    final GameRepository repository = await ref.watch(
      gameRepositoryProvider.future,
    );
    return repository.loadProfile();
  }

  Future<void> createPet(String name, PetCoat coat, PetAccessory accessory) =>
      _perform(
        (repository) => repository.createProfile(
          petName: name,
          coat: coat,
          accessory: accessory,
        ),
      );

  Future<void> confirmBudget(
    int needs,
    int wants,
    int savings, {
    int gifts = 0,
  }) => _perform(
    (repository) => repository.confirmBudget(
      needs: needs,
      wants: wants,
      gifts: gifts,
      savings: savings,
    ),
  );

  Future<void> purchase(String productId, String commandId) => _perform(
    (repository) => repository.purchase(productId, commandId: commandId),
  );

  Future<void> equipAccessory(PetAccessory? accessory) =>
      _perform((repository) => repository.equipAccessory(accessory));

  Future<void> walk() => _perform((repository) => repository.walk());

  Future<void> plantSapling(String definitionId, String commandId) => _perform(
    (repository) => repository.plantSapling(definitionId, commandId),
  );

  Future<void> harvestSapling(String saplingId, String commandId) =>
      _perform((repository) => repository.harvestSapling(saplingId, commandId));

  Future<void> selectGoal(String goalId) =>
      _perform((repository) => repository.selectGoal(goalId));

  Future<void> transfer(
    String goalId,
    int amount,
    String commandId, {
    required bool withdraw,
  }) => _perform(
    (repository) => repository.transfer(
      goalId,
      amount,
      commandId: commandId,
      withdraw: withdraw,
    ),
  );

  Future<void> _perform(
    Future<GameProfile?> Function(GameRepository) action,
  ) async {
    if (_busy) {
      throw const GameRuleException('Подожди, сохраняем предыдущее действие.');
    }
    _busy = true;
    try {
      final GameRepository repository = await ref.read(
        gameRepositoryProvider.future,
      );
      final GameProfile? next = await action(repository);
      if (ref.mounted) state = AsyncData(next);
    } finally {
      _busy = false;
    }
  }
}
