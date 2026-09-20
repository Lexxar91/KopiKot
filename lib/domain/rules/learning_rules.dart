import '../models/game_catalog.dart';
import '../models/game_profile.dart';
import '../models/game_transaction.dart';
import '../models/learning_task.dart';
import 'game_rules.dart';

/// Учебные монеты моделируют ситуацию; в основном балансе меняется только награда.
abstract final class LearningRules {
  static GameProfile submit(
    GameProfile profile,
    GameCatalog catalog,
    LearningTask task,
    TaskAnswer answer,
  ) {
    if (profile.completedTask(task.id)) {
      return profile.copyWith(
        feedback: 'Задание уже выполнено. Награда выдана один раз.',
      );
    }
    if (profile.plan == null) {
      throw const GameRuleException(
        'Сначала подтверди бюджет, затем переходи к заданиям.',
      );
    }
    bool correct = false;
    String result = '';
    if (answer.needs < 0 || answer.wants < 0 || answer.savings < 0) {
      result = 'Суммы не могут быть отрицательными. ';
    } else {
      switch (task.kind) {
        case TaskKind.budget:
          final total = answer.needs + answer.wants + answer.savings;
          correct =
              total <= task.budget &&
              answer.needs >= task.minimumNeeds &&
              answer.savings >= task.minimumSavings;
          result = total > task.budget
              ? 'Не хватает ${total - task.budget} учебных монет. '
              : 'Распределено $total из ${task.budget}, осталось ${task.budget - total}. ';
        case TaskKind.basket:
          final ids = answer.products.toSet();
          if (ids.length != answer.products.length ||
              !task.products.toSet().containsAll(ids)) {
            result =
                'Используй только товары этой учебной корзины, каждый по одному разу. ';
            break;
          }
          final total = ids.fold<int>(
            0,
            (sum, id) => sum + catalog.product(id).price,
          );
          correct =
              total <= task.budget && ids.containsAll(task.requiredProducts);
          result = 'Корзина стоит $total из ${task.budget} учебных монет. ';
        case TaskKind.saving:
          correct =
              answer.savings >= task.minimumSavings &&
              answer.savings <= task.goalRemaining &&
              answer.savings <= task.budget - task.minimumNeeds;
          result = answer.savings <= task.budget
              ? 'После учебного перевода осталось бы ${task.budget - answer.savings} монет. '
              : 'Такого количества учебных монет пока нет. ';
      }
    }
    final old = profile.taskProgress
        .where((progress) => progress.taskId == task.id)
        .firstOrNull;
    final feedback =
        '$result${correct ? task.success : task.retry} '
        '${correct ? 'Награда: +${task.reward} игровых монет.' : 'Баланс и состояние питомца не изменились. Попробуй ещё раз.'}';
    final progress = TaskProgress(
      taskId: task.id,
      attempts: (old?.attempts ?? 0) + 1,
      completed: correct,
      feedback: feedback,
    );
    final balance = profile.balance + (correct ? task.reward : 0);
    return profile.copyWith(
      balance: balance,
      feedback: feedback,
      taskProgress: [
        ...profile.taskProgress.where((entry) => entry.taskId != task.id),
        progress,
      ],
      transactions: [
        ...profile.transactions,
        if (correct)
          GameTransaction(
            id: 'task-reward-${task.id}',
            period: profile.period,
            kind: TransactionKind.income,
            amount: task.reward,
            label: 'Задание: ${task.title}',
            referenceId: task.id,
            balanceAfter: balance,
            savingsAfter: profile.savings,
            satietyAfter: profile.satiety,
            moodAfter: profile.mood,
          ),
      ],
    );
  }
}
