import '../models/game_profile.dart';
import '../models/learning_task.dart';
import '../rules/activity_reward_rules.dart';
import '../rules/accountant_rules.dart';
import '../rules/market_game_rules.dart';
import '../rules/mini_game_rules.dart';

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
    int kept = 0,
    int expectedIncome = 0,
    List<String> sourceIds = const [],
  });

  Future<GameProfile> reviseBudget({
    required int needs,
    required int wants,
    required int savings,
    int gifts = 0,
    int kept = 0,
    int expectedIncome = 0,
    List<String> sourceIds = const [],
  });

  Future<GameProfile> purchase(String productId, {required String commandId});
  Future<GameProfile> equipAccessory(PetAccessory? accessory);

  /// Бесплатная прогулка: раз в игровой день, без монет и плана.
  Future<GameProfile> walk();

  /// Посадка и сбор саженца котодерева-копилки.
  Future<GameProfile> plantSapling(String definitionId, String commandId);
  Future<GameProfile> harvestSapling(String saplingId, String commandId);

  Future<GameProfile> selectGoal(String goalId);
  Future<GameProfile> purchaseGoal(String goalId, String commandId);
  Future<GameProfile> transferReserve(
    int amount, {
    required String commandId,
    required bool withdraw,
  });
  Future<GameProfile> transfer(
    String goalId,
    int amount, {
    required String commandId,
    required bool withdraw,
  });
  Future<GameProfile> submitTask(
    String taskId,
    TaskAnswer answer, {
    ActivityRewardSnapshot? snapshot,
  });
  Future<GameProfile> acknowledgeTask(
    String taskId, {
    ActivityRewardSnapshot? snapshot,
  });
  Future<GameProfile> chooseLearningDifficulty(
    String topic,
    LearningDifficulty difficulty,
  );
  Future<GameProfile> dismissLearningDowngrade(String topic);
  Future<GameProfile> claimMiniGame(
    MiniGameKind kind,
    String commandId, {
    ActivityRewardSnapshot? snapshot,
  });
  Future<GameProfile> accountantAction(
    String sessionId,
    AccountantAction action, {
    int? answer,
  });
  Future<GameProfile> marketAction(
    String sessionId,
    MarketAction action, {
    String? itemId,
  });
  Future<GameProfile> claimDailyReward();
  Future<GameProfile> finishPeriod(int expectedPeriod);
}
