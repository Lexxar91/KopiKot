import 'accountant_session.dart';
import 'game_transaction.dart';
import 'learning_task.dart';
import 'market_session.dart';
import 'period_summary.dart';

/// Внешность хранится как стабильные значения, независимо от способа отрисовки.
enum PetCoat { ginger, grey, cream, dark, white }

enum PetAccessory { scarf, bow, cap, headband, wristbands }

enum PetEmotion { calm, happy, excited, hungry, thoughtful, proud }

/// Открытый рубеж хранит исходные пороги, чтобы будущая балансировка его не меняла.
class GrowthMilestone {
  const GrowthMilestone({
    required this.stage,
    required this.incomeThreshold,
    required this.savingsThreshold,
    required this.bestDayIncome,
    required this.savingsAtUnlock,
    this.dayKey,
  });

  final int stage;
  final int incomeThreshold;
  final int savingsThreshold;
  final int bestDayIncome;
  final int savingsAtUnlock;
  final String? dayKey;
}

/// Посаженный саженец растёт по игровым периодам и потом приносит монеты.
class SaplingState {
  const SaplingState({
    required this.id,
    required this.definitionId,
    required this.plantedPeriod,
    this.plantedDayKey,
  });
  final String id;
  final String definitionId;
  final int plantedPeriod;
  final String? plantedDayKey;
}

/// План — прогноз; реально потратить можно только коткоины из кошелька.
class BudgetPlan {
  const BudgetPlan({
    required this.availableAtConfirmation,
    required this.needs,
    required this.wants,
    required this.savings,
    this.gifts = 0,
    int? openingBalance,
    this.expectedIncome = 0,
    this.kept = 0,
    this.sourceIds = const [],
  }) : openingBalance = openingBalance ?? availableAtConfirmation;

  final int availableAtConfirmation;
  final int openingBalance;
  final int expectedIncome;
  final int needs;
  final int wants;
  final int savings;
  final int gifts;
  final int kept;
  final List<String> sourceIds;

  int get allocated => needs + wants + gifts + savings + kept;
  int get remaining => availableAtConfirmation - allocated;
}

/// Прежний вариант плана остаётся в истории после пересмотра.
class BudgetRevision {
  const BudgetRevision({required this.period, required this.plan});
  final int period;
  final BudgetPlan plan;
}

/// Локальный игровой профиль. Domain не зависит от Flutter и Isar.
class GameProfile {
  static const reserveId = '_reserve';
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
    this.budgetRevisions = const [],
    this.selectedGoalId,
    this.goalChoicesUnlocked = false,
    this.goalSavings = const {},
    this.ownedAccessories = const [],
    this.transactions = const [],
    this.taskProgress = const [],
    this.learningTopics = const [],
    this.periodSummaries = const [],
    this.accountantSessions = const [],
    this.marketSessions = const [],
    this.bestDayIncome = 0,
    this.bestDayKey,
    this.unlockedGrowthStage = 1,
    this.growthIncomeThresholds = const [30, 55, 80],
    this.growthSavingsThresholds = const [30, 100, 200],
    this.growthMilestones = const [],
    this.saplings = const [],
    this.lastRewardAt,
    this.dayKey,
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

  /// Местная календарная дата активного игрового дня в формате YYYY-MM-DD.
  final String? dayKey;
  final String incomeSource;
  final int incomeAmount;
  final BudgetPlan? plan;
  final List<BudgetRevision> budgetRevisions;
  final String? selectedGoalId;

  /// После первого достижения полной суммы цели выбор остаётся открытым.
  final bool goalChoicesUnlocked;
  final Map<String, int> goalSavings;
  final List<PetAccessory> ownedAccessories;
  final List<GameTransaction> transactions;
  final String feedback;
  final List<TaskProgress> taskProgress;
  final List<LearningTopicProgress> learningTopics;
  final List<PeriodSummary> periodSummaries;
  final List<AccountantSession> accountantSessions;
  final List<MarketSession> marketSessions;
  final int bestDayIncome;
  final String? bestDayKey;
  final int unlockedGrowthStage;
  final List<int> growthIncomeThresholds;
  final List<int> growthSavingsThresholds;
  final List<GrowthMilestone> growthMilestones;
  final List<SaplingState> saplings;

  int get growthStage => unlockedGrowthStage;
  String get growthLabel => switch (growthStage) {
    3 => 'Опытный друг',
    2 => 'Исследователь',
    _ => 'Малыш',
  };
  bool completedTask(String taskId) => taskProgress.any(
    (progress) => progress.taskId == taskId && progress.completed,
  );

  LearningTopicProgress learningTopic(String topic) =>
      learningTopics.where((entry) => entry.topic == topic).firstOrNull ??
      LearningTopicProgress(topic: topic);

  int savedFor(String goalId) => goalSavings[goalId] ?? 0;

  int get reserveSavings => savedFor(reserveId);

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
    String? dayKey,
    PetAccessory? accessory,
    bool removeAccessory = false,
    BudgetPlan? plan,
    List<BudgetRevision>? budgetRevisions,
    String? selectedGoalId,
    bool? goalChoicesUnlocked,
    Map<String, int>? goalSavings,
    List<PetAccessory>? ownedAccessories,
    List<GameTransaction>? transactions,
    String? feedback,
    int? period,
    bool clearPlan = false,
    List<TaskProgress>? taskProgress,
    List<LearningTopicProgress>? learningTopics,
    List<PeriodSummary>? periodSummaries,
    List<AccountantSession>? accountantSessions,
    List<MarketSession>? marketSessions,
    int? bestDayIncome,
    String? bestDayKey,
    int? unlockedGrowthStage,
    List<int>? growthIncomeThresholds,
    List<int>? growthSavingsThresholds,
    List<GrowthMilestone>? growthMilestones,
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
    dayKey: dayKey ?? this.dayKey,
    incomeSource: incomeSource,
    incomeAmount: incomeAmount,
    plan: clearPlan ? null : (plan ?? this.plan),
    budgetRevisions: List.unmodifiable(budgetRevisions ?? this.budgetRevisions),
    selectedGoalId: selectedGoalId ?? this.selectedGoalId,
    goalChoicesUnlocked: goalChoicesUnlocked ?? this.goalChoicesUnlocked,
    goalSavings: Map.unmodifiable(goalSavings ?? this.goalSavings),
    ownedAccessories: List.unmodifiable(
      ownedAccessories ?? this.ownedAccessories,
    ),
    transactions: List.unmodifiable(transactions ?? this.transactions),
    feedback: feedback ?? this.feedback,
    taskProgress: List.unmodifiable(taskProgress ?? this.taskProgress),
    learningTopics: List.unmodifiable(learningTopics ?? this.learningTopics),
    periodSummaries: List.unmodifiable(periodSummaries ?? this.periodSummaries),
    accountantSessions: List.unmodifiable(
      accountantSessions ?? this.accountantSessions,
    ),
    marketSessions: List.unmodifiable(marketSessions ?? this.marketSessions),
    bestDayIncome: bestDayIncome ?? this.bestDayIncome,
    bestDayKey: bestDayKey ?? this.bestDayKey,
    unlockedGrowthStage: unlockedGrowthStage ?? this.unlockedGrowthStage,
    growthIncomeThresholds: List.unmodifiable(
      growthIncomeThresholds ?? this.growthIncomeThresholds,
    ),
    growthSavingsThresholds: List.unmodifiable(
      growthSavingsThresholds ?? this.growthSavingsThresholds,
    ),
    growthMilestones: List.unmodifiable(
      growthMilestones ?? this.growthMilestones,
    ),
    saplings: List.unmodifiable(saplings ?? this.saplings),
  );
}
