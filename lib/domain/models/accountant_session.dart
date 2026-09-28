import 'learning_task.dart';

/// Один короткий пример на вычисление сдачи.
class AccountantQuestion {
  const AccountantQuestion({
    required this.product,
    required this.price,
    required this.paid,
    required this.choices,
    this.secondProduct,
    this.secondPrice = 0,
  });

  final String product;
  final int price;
  final int paid;
  final List<int> choices;
  final String? secondProduct;
  final int secondPrice;

  int get totalPrice => price + secondPrice;
  int get correctChange => paid - totalPrice;
  bool isCorrect(int answer) => answer == correctChange;
}

/// Сохраняет каждый ответ и способ завершения одного примера.
class AccountantAnswerState {
  const AccountantAnswerState({
    this.answers = const [],
    this.hintUsed = false,
    this.reviewed = false,
    this.solved = false,
  });

  final List<int> answers;
  final bool hintUsed;
  final bool reviewed;
  final bool solved;

  bool get firstTry => solved && !reviewed && !hintUsed && answers.length == 1;
  int get errors =>
      reviewed ? answers.length : answers.length - (solved ? 1 : 0);
}

/// Снимок вопросов и шкал позволяет продолжить игру после перезапуска.
class AccountantSession {
  const AccountantSession({
    required this.id,
    required this.period,
    required this.dayKey,
    required this.difficulty,
    required this.questions,
    required this.progress,
    required this.startSatiety,
    required this.startEnergy,
    required this.startMood,
    this.completed = false,
    this.paidReward = 0,
  });

  final String id;
  final int period;
  final String? dayKey;
  final LearningDifficulty difficulty;
  final List<AccountantQuestion> questions;
  final List<AccountantAnswerState> progress;
  final int startSatiety;
  final int startEnergy;
  final int startMood;
  final bool completed;
  final int paidReward;

  int get currentIndex {
    final index = progress.indexWhere((entry) => !entry.solved);
    return index < 0 ? questions.length - 1 : index;
  }

  bool get readyToFinish => progress.every((entry) => entry.solved);
  int get stars => progress.where((entry) => entry.firstTry).length;

  AccountantSession copyWith({
    List<AccountantAnswerState>? progress,
    bool? completed,
    int? paidReward,
  }) => AccountantSession(
    id: id,
    period: period,
    dayKey: dayKey,
    difficulty: difficulty,
    questions: questions,
    progress: progress ?? this.progress,
    startSatiety: startSatiety,
    startEnergy: startEnergy,
    startMood: startMood,
    completed: completed ?? this.completed,
    paidReward: paidReward ?? this.paidReward,
  );
}
