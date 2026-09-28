import 'package:isar_community/isar.dart';

part 'profile_record.g.dart';

/// Полный агрегат: обычный профиль ID 1 и отдельный тестовый профиль ID 2.
@collection
class ProfileRecord {
  Id id = 1;
  int schemaVersion = 8;
  late String petName;
  late String coat;
  late String accessory;
  List<String>? ownedAccessories;
  int balance = 0;
  int savings = 0;
  int period = 1;
  int satiety = 70;
  int mood = 70;
  int energy = 70;
  int streak = 1;
  DateTime? lastRewardAt;
  String? dayKey;
  int walkPeriod = 0;
  late String incomeSource;
  int incomeAmount = 0;
  bool budgetConfirmed = false;
  int plannedBalance = 0;
  int budgetOpeningBalance = 0;
  int budgetExpectedIncome = 0;
  int budgetKept = 0;
  List<String>? budgetSourceIds;
  List<BudgetRevisionRecord>? budgetRevisions;
  int plannedNeeds = 0;
  int plannedWants = 0;
  int plannedSavings = 0;
  int plannedGifts = 0;
  String? selectedGoalId;
  bool? goalChoicesUnlocked;
  String? feedback;
  List<GoalBalanceRecord>? goalBalances;
  List<TransactionRecord>? transactions;
  List<TaskProgressRecord>? taskProgress;
  List<LearningTopicRecord>? learningTopics;
  String? accountantSessionsJson;
  String? marketSessionsJson;
  int bestDayIncome = 0;
  String? bestDayKey;
  int unlockedGrowthStage = 1;
  List<int>? growthIncomeThresholds;
  List<int>? growthSavingsThresholds;
  List<GrowthMilestoneRecord>? growthMilestones;
  List<PeriodSummaryRecord>? periodSummaries;
  List<SaplingRecord>? saplings;
}

/// Остатки разделены по целям; смена выбранной цели не переносит её монеты.
@embedded
class GoalBalanceRecord {
  late String goalId;
  int amount = 0;
}

@embedded
class BudgetRevisionRecord {
  int period = 1;
  int available = 0;
  int openingBalance = 0;
  int expectedIncome = 0;
  int needs = 0;
  int wants = 0;
  int savings = 0;
  int gifts = 0;
  int kept = 0;
  List<String>? sourceIds;
}

/// История входит в агрегат профиля и фиксируется той же транзакцией Isar.
@embedded
class TransactionRecord {
  late String commandId;
  int period = 1;
  late String kind;
  int amount = 0;
  late String label;
  String? referenceId;
  int? startSatiety;
  int? startEnergy;
  int? startMood;
  int? baseReward;
  int balanceAfter = 0;
  int savingsAfter = 0;
  int satietyAfter = 0;
  int moodAfter = 0;
}

@embedded
class TaskProgressRecord {
  late String taskId;
  int attempts = 0;
  bool completed = false;
  bool hintUsed = false;
  bool solutionShown = false;
  bool reviewed = false;
  int practiceAttempts = 0;
  late String feedback;
}

@embedded
class LearningTopicRecord {
  late String topic;
  String difficulty = 'simple';
  int cleanStreak = 0;
  int helpStreak = 0;
  bool downgradeOffered = false;
  bool downgradePending = false;
}

@embedded
class GrowthMilestoneRecord {
  int stage = 1;
  int incomeThreshold = 0;
  int savingsThreshold = 0;
  int bestDayIncome = 0;
  int savingsAtUnlock = 0;
  String? dayKey;
}

/// Растущий саженец живёт внутри профиля и фиксируется той же транзакцией.
@embedded
class SaplingRecord {
  late String saplingId;
  late String definitionId;
  int plantedPeriod = 1;
  String? plantedDayKey;
}

@embedded
class PeriodSummaryRecord {
  int period = 1;
  String? dayKey;
  int missedDays = 0;
  int? plannedIncome;
  int plannedNeeds = 0;
  int plannedWants = 0;
  int plannedSavings = 0;
  int plannedGifts = 0;
  int actualNeeds = 0;
  int actualWants = 0;
  int actualGifts = 0;
  int netSaved = 0;
  bool needsMet = false;
  bool withinPlan = false;
  bool savedRegularly = false;
  late String explanation;
}
