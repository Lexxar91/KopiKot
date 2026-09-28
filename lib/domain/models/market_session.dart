import 'learning_task.dart';

/// Цена и категория товара фиксируются в учебном сценарии.
class MarketGameItem {
  const MarketGameItem({
    required this.id,
    required this.title,
    required this.price,
    required this.needed,
  });

  final String id;
  final String title;
  final int price;
  final bool needed;
}

class MarketScenario {
  const MarketScenario({
    required this.version,
    required this.budget,
    required this.reserve,
    required this.items,
  });

  final int version;
  final int budget;
  final int reserve;
  final List<MarketGameItem> items;
}

/// Выбор сохраняется после каждого действия и не меняет реальный кошелёк.
class MarketSession {
  const MarketSession({
    required this.id,
    required this.period,
    required this.dayKey,
    required this.difficulty,
    required this.scenario,
    required this.startSatiety,
    required this.startEnergy,
    required this.startMood,
    this.selectedIds = const [],
    this.attempts = 0,
    this.hintUsed = false,
    this.reviewed = false,
    this.solved = false,
    this.completed = false,
    this.paidReward = 0,
    this.lastFeedback,
  });

  final String id;
  final int period;
  final String? dayKey;
  final LearningDifficulty difficulty;
  final MarketScenario scenario;
  final int startSatiety;
  final int startEnergy;
  final int startMood;
  final List<String> selectedIds;
  final int attempts;
  final bool hintUsed;
  final bool reviewed;
  final bool solved;
  final bool completed;
  final int paidReward;
  final String? lastFeedback;

  bool get firstTry => solved && attempts == 1 && !hintUsed && !reviewed;

  MarketSession copyWith({
    List<String>? selectedIds,
    int? attempts,
    bool? hintUsed,
    bool? reviewed,
    bool? solved,
    bool? completed,
    int? paidReward,
    String? lastFeedback,
    bool clearFeedback = false,
  }) => MarketSession(
    id: id,
    period: period,
    dayKey: dayKey,
    difficulty: difficulty,
    scenario: scenario,
    startSatiety: startSatiety,
    startEnergy: startEnergy,
    startMood: startMood,
    selectedIds: selectedIds ?? this.selectedIds,
    attempts: attempts ?? this.attempts,
    hintUsed: hintUsed ?? this.hintUsed,
    reviewed: reviewed ?? this.reviewed,
    solved: solved ?? this.solved,
    completed: completed ?? this.completed,
    paidReward: paidReward ?? this.paidReward,
    lastFeedback: clearFeedback ? null : (lastFeedback ?? this.lastFeedback),
  );
}
