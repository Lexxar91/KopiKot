import '../models/game_profile.dart';
import '../models/learning_task.dart';

/// UI обращается к этому контракту; способ хранения можно заменить.
abstract interface class GameRepository {
  Future<GameProfile?> loadProfile();

  /// Тестовый профиль создаётся один раз; обычный может ещё отсутствовать.
  Future<GameProfile?> switchProfile({required bool testProfile});
  Future<GameProfile> resetTestProfile();
  Future<void> deleteRegularProfile();

  /// Общая настройка устройства, независимая от игрового профиля.
  Future<bool> loadReduceMotion();
  Future<void> saveReduceMotion(bool value);

  Future<GameProfile> createProfile({
    required String petName,
    required PetCoat coat,
    required PetAccessory accessory,
  });

  Future<GameProfile> confirmBudget({
    required int needs,
    required int wants,
    required int savings,
    int gifts = 0,
  });

  Future<GameProfile> purchase(String productId, {required String commandId});
  Future<GameProfile> equipAccessory(PetAccessory? accessory);
  Future<GameProfile> selectGoal(String goalId);
  Future<GameProfile> transfer(
    String goalId,
    int amount, {
    required String commandId,
    required bool withdraw,
  });
  Future<GameProfile> submitTask(String taskId, TaskAnswer answer);
  Future<GameProfile> finishPeriod(int expectedPeriod);
}
