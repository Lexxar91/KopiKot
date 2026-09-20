import 'game_transaction.dart';
import 'learning_task.dart';
import 'period_summary.dart';

/// Внешность хранится как стабильные значения, независимо от способа отрисовки.
enum PetCoat { ginger, grey, cream }

enum PetAccessory { scarf, bow, cap }

/// Подтверждённый план не тратит монеты и не меняется задним числом.
class BudgetPlan {
  const BudgetPlan({
    required this.availableAtConfirmation,
    required this.needs,
    required this.wants,
    required this.savings,
  });

  final int availableAtConfirmation;
  final int needs;
  final int wants;
  final int savings;

  int get allocated => needs + wants + savings;
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
    this.isTest = false,
    this.plan,
    this.selectedGoalId,
    this.goalSavings = const {},
    this.transactions = const [],
    this.taskProgress = const [],
    this.periodSummaries = const [],
    this.feedback =
        'Питомец рад знакомству. Давай подумаем, на что хватит монет.',
  });

  final String petName;
  final bool isTest;
  final PetCoat coat;
  final PetAccessory accessory;
  final int balance;
  final int savings;
  final int period;
  final int satiety;
  final int mood;
  final String incomeSource;
  final int incomeAmount;
  final BudgetPlan? plan;
  final String? selectedGoalId;
  final Map<String, int> goalSavings;
  final List<GameTransaction> transactions;
  final String feedback;
  final List<TaskProgress> taskProgress;
  final List<PeriodSummary> periodSummaries;

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
  int get netSaved =>
      totalFor(TransactionKind.deposit) - totalFor(TransactionKind.withdrawal);

  GameProfile withPlan(BudgetPlan value) => copyWith(plan: value);

  GameProfile copyWith({
    int? balance,
    int? savings,
    int? satiety,
    int? mood,
    BudgetPlan? plan,
    String? selectedGoalId,
    Map<String, int>? goalSavings,
    List<GameTransaction>? transactions,
    String? feedback,
    int? period,
    bool clearPlan = false,
    List<TaskProgress>? taskProgress,
    List<PeriodSummary>? periodSummaries,
  }) => GameProfile(
    petName: petName,
    isTest: isTest,
    coat: coat,
    accessory: accessory,
    balance: balance ?? this.balance,
    savings: savings ?? this.savings,
    period: period ?? this.period,
    satiety: satiety ?? this.satiety,
    mood: mood ?? this.mood,
    incomeSource: incomeSource,
    incomeAmount: incomeAmount,
    plan: clearPlan ? null : (plan ?? this.plan),
    selectedGoalId: selectedGoalId ?? this.selectedGoalId,
    goalSavings: Map.unmodifiable(goalSavings ?? this.goalSavings),
    transactions: List.unmodifiable(transactions ?? this.transactions),
    feedback: feedback ?? this.feedback,
    taskProgress: List.unmodifiable(taskProgress ?? this.taskProgress),
    periodSummaries: List.unmodifiable(periodSummaries ?? this.periodSummaries),
  );
}
