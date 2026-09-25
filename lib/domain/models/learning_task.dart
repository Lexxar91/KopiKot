enum TaskKind { budget, basket, saving, choice }

/// Параметры учебной ситуации хранятся в каталоге, отдельно от обработчика и UI.
class LearningTask {
  const LearningTask({
    required this.id,
    required this.title,
    required this.topic,
    required this.kind,
    required this.prompt,
    required this.budget,
    required this.minimumNeeds,
    required this.minimumSavings,
    required this.goalRemaining,
    required this.reward,
    required this.success,
    required this.retry,
    this.products = const [],
    this.requiredProducts = const [],
  });
  final String id;
  final String title;
  final String topic;
  final TaskKind kind;
  final String prompt;
  final int budget;
  final int minimumNeeds;
  final int minimumSavings;
  final int goalRemaining;
  final int reward;
  final String success;
  final String retry;
  final List<String> products;
  final List<String> requiredProducts;
}

class TaskAnswer {
  const TaskAnswer({
    this.needs = 0,
    this.wants = 0,
    this.savings = 0,
    this.products = const [],
    this.choice,
  });
  final int needs;
  final int wants;
  final int savings;
  final List<String> products;
  final String? choice;
}

/// Попытки и выданная награда сохраняются вместе с новым балансом.
class TaskProgress {
  const TaskProgress({
    required this.taskId,
    required this.attempts,
    required this.completed,
    required this.feedback,
  });
  final String taskId;
  final int attempts;
  final bool completed;
  final String feedback;
}
