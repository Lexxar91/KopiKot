import 'game_transaction.dart';
import 'learning_task.dart';
import 'period_summary.dart';

/// Внешность хранится как стабильные значения, независимо от способа отрисовки.
enum PetCoat { ginger, grey, cream }

enum PetAccessory { scarf, bow, cap }

enum PetEmotion { calm, happy, excited, hungry, thoughtful, proud }

/// Посаженный саженец растёт по игровым периодам и потом приносит монеты.
class SaplingState {
  const SaplingState({
    required this.id,
    required this.definitionId,
    required this.plantedPeriod,
  });
  final String id;
  final String definitionId;
  final int plantedPeriod;
}

/// Подтверждённый план не тратит монеты и не меняется задним числом.
class BudgetPlan {
  const BudgetPlan({
    required this.availableAtConfirmation,
    required this.needs,
    required this.wants,
    required this.savings,
    this.gifts = 0,
  });

  final int availableAtConfirmation;
  final int needs;
  final int wants;
  final int savings;
  final int gifts;

  int get allocated => needs + wants + gifts + savings;
  int get remaining => availableAtConfirmation - allocated;
}

/// Локальный игровой профиль. Domain не зависит от Flutter и Isar.
class GameProfile {
  const GameProfile({
    required this.petName,
    required this.coat,
    required this.accessory,
    required this.balance,
    required this.savings,
    required this.period,
    required this.satiety,
    required this.mood,
    required this.incomeSource,
    required this.incomeAmount,
    this.energy = 70,
    this.streak = 1,
    this.walkPeriod = 0,
    this.isTest = false,
    this.plan,
    this.selectedGoalId,
    this.goalSavings = const {},
    this.ownedAccessories = const [],
    this.transactions = const [],
    this.taskProgress = const [],
    this.periodSummaries = const [],
    this.saplings = const [],
    this.lastRewardAt,
    this.feedback =
        'Питомец рад знакомству. Давай подумаем, на что хватит монет.',
  });

  final String petName;
  final bool isTest;
  final PetCoat coat;
  final PetAccessory? accessory;
  final int balance;
  final int savings;
  final int period;
  final int satiety;
  final int mood;

  /// Бодрость питомца: полезная еда и бесплатные прогулки её поднимают.
  final int energy;

  /// Уровень серии ежедневных подарков: от 1 до 7, при пропуске мягко падает.
  final int streak;

  /// Период последней бесплатной прогулки: не чаще одного раза за период.
  final int walkPeriod;

  /// Момент последнего начисления серии; до первого периода равен null.
  final DateTime? lastRewardAt;
  final String incomeSource;
  final int incomeAmount;
  final BudgetPlan? plan;
  final String? selectedGoalId;
  final Map<String, int> goalSavings;
  final List<PetAccessory> ownedAccessories;
  final List<GameTransaction> transactions;
  final String feedback;
  final List<TaskProgress> taskProgress;
  final List<PeriodSummary> periodSummaries;
  final List<SaplingState> saplings;

  int get growthPeriods =>
      periodSummaries.where((summary) => summary.supportsGrowth).length;
  int get growthStage => growthPeriods >= 4 ? 3 : (growthPeriods >= 2 ? 2 : 1);
  String get growthLabel => switch (growthStage) {
    3 => 'Опытный друг',
    2 => 'Исследователь',
    _ => 'Малыш',
  };
  bool completedTask(String taskId) => taskProgress.any(
    (progress) => progress.taskId == taskId && progress.completed,
  );

  int savedFor(String goalId) => goalSavings[goalId] ?? 0;

  int totalFor(TransactionKind kind) => transactions
      .where((entry) => entry.period == period && entry.kind == kind)
      .fold(0, (sum, entry) => sum + entry.amount);

  int get actualNeeds => totalFor(TransactionKind.needPurchase);
  int get actualWants => totalFor(TransactionKind.wantPurchase);
  int get actualGifts => totalFor(TransactionKind.giftPurchase);
  int get netSaved =>
      totalFor(TransactionKind.deposit) - totalFor(TransactionKind.withdrawal);

  bool ownsAccessory(PetAccessory value) =>
      accessory == value || ownedAccessories.contains(value);

  PetEmotion get emotion {
    if (satiety <= 45) return PetEmotion.hungry;
    if (mood <= 45) return PetEmotion.thoughtful;
    if (transactions.isNotEmpty) {
      return switch (transactions.last.kind) {
        TransactionKind.deposit => PetEmotion.proud,
        TransactionKind.needPurchase => PetEmotion.happy,
        TransactionKind.wantPurchase ||
        TransactionKind.giftPurchase => PetEmotion.excited,
        _ => mood >= 85 ? PetEmotion.happy : PetEmotion.calm,
      };
    }
    return growthStage >= 2 ? PetEmotion.proud : PetEmotion.calm;
  }

  GameProfile withPlan(BudgetPlan value) => copyWith(plan: value);

  GameProfile copyWith({
    int? balance,
    int? savings,
    int? satiety,
    int? mood,
    int? energy,
    int? streak,
    int? walkPeriod,
    DateTime? lastRewardAt,
    PetAccessory? accessory,
    bool removeAccessory = false,
    BudgetPlan? plan,
    String? selectedGoalId,
    Map<String, int>? goalSavings,
    List<PetAccessory>? ownedAccessories,
    List<GameTransaction>? transactions,
    String? feedback,
    int? period,
    bool clearPlan = false,
    List<TaskProgress>? taskProgress,
    List<PeriodSummary>? periodSummaries,
    List<SaplingState>? saplings,
  }) => GameProfile(
    petName: petName,
    isTest: isTest,
    coat: coat,
    accessory: removeAccessory ? null : (accessory ?? this.accessory),
    balance: balance ?? this.balance,
    savings: savings ?? this.savings,
    period: period ?? this.period,
    satiety: satiety ?? this.satiety,
    mood: mood ?? this.mood,
    energy: energy ?? this.energy,
    streak: streak ?? this.streak,
    walkPeriod: walkPeriod ?? this.walkPeriod,
    lastRewardAt: lastRewardAt ?? this.lastRewardAt,
    incomeSource: incomeSource,
    incomeAmount: incomeAmount,
    plan: clearPlan ? null : (plan ?? this.plan),
    selectedGoalId: selectedGoalId ?? this.selectedGoalId,
    goalSavings: Map.unmodifiable(goalSavings ?? this.goalSavings),
    ownedAccessories: List.unmodifiable(
      ownedAccessories ?? this.ownedAccessories,
    ),
    transactions: List.unmodifiable(transactions ?? this.transactions),
    feedback: feedback ?? this.feedback,
    taskProgress: List.unmodifiable(taskProgress ?? this.taskProgress),
    periodSummaries: List.unmodifiable(periodSummaries ?? this.periodSummaries),
    saplings: List.unmodifiable(saplings ?? this.saplings),
  );
}
