import 'package:isar_community/isar.dart';

part 'profile_record.g.dart';

/// Полный агрегат: обычный профиль ID 1 и отдельный тестовый профиль ID 2.
@collection
class ProfileRecord {
  Id id = 1;
  int schemaVersion = 3;
  late String petName;
  late String coat;
  late String accessory;
  int balance = 0;
  int savings = 0;
  int period = 1;
  int satiety = 70;
  int mood = 70;
  late String incomeSource;
  int incomeAmount = 0;
  bool budgetConfirmed = false;
  int plannedBalance = 0;
  int plannedNeeds = 0;
  int plannedWants = 0;
  int plannedSavings = 0;
  String? selectedGoalId;
  String? feedback;
  List<GoalBalanceRecord>? goalBalances;
  List<TransactionRecord>? transactions;
  List<TaskProgressRecord>? taskProgress;
  List<PeriodSummaryRecord>? periodSummaries;
}

/// Остатки разделены по целям; смена выбранной цели не переносит её монеты.
@embedded
class GoalBalanceRecord {
  late String goalId;
  int amount = 0;
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
  late String feedback;
}

@embedded
class PeriodSummaryRecord {
  int period = 1;
  int plannedNeeds = 0;
  int plannedWants = 0;
  int plannedSavings = 0;
  int actualNeeds = 0;
  int actualWants = 0;
  int netSaved = 0;
  bool needsMet = false;
  bool withinPlan = false;
  bool savedRegularly = false;
  late String explanation;
}
