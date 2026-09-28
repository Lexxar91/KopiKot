import '../models/game_catalog.dart';
import '../models/game_profile.dart';
import '../models/game_transaction.dart';
import 'daily_reward_rules.dart';
import 'game_rules.dart';
import 'mini_game_rules.dart';

/// Доходы для плана — прогноз, а не деньги в кошельке.
class BudgetIncomeOption {
  const BudgetIncomeOption({
    required this.id,
    required this.title,
    required this.base,
    required this.expected,
    required this.received,
  });

  final String id;
  final String title;
  final int base;
  final int expected;
  final bool received;
}

abstract final class BudgetIncomeRules {
  static List<BudgetIncomeOption> options(
    GameProfile profile,
    GameCatalog catalog,
  ) {
    final entries = profile.transactions.where(
      (entry) =>
          entry.period == profile.period &&
          entry.kind == TransactionKind.income,
    );
    final daily = entries
        .where((entry) => entry.id.startsWith('daily-reward-'))
        .firstOrNull;
    final dailyLevel = DailyRewardRules.rewardLevel(profile);
    final result = <BudgetIncomeOption>[
      BudgetIncomeOption(
        id: 'daily',
        title: 'Ежедневная награда',
        base: daily?.amount ?? DailyRewardRules.ladder[dailyLevel - 1],
        expected: daily?.amount ?? DailyRewardRules.ladder[dailyLevel - 1],
        received: daily != null,
      ),
    ];
    for (final kind in MiniGameKind.values) {
      final paid = entries
          .where((entry) => entry.referenceId == kind.name)
          .firstOrNull;
      result.add(
        BudgetIncomeOption(
          id: 'game:${kind.name}',
          title: 'Игра «${MiniGameRules.title(kind)}»',
          base: MiniGameRules.baseReward,
          expected: paid?.amount ?? MiniGameRules.rewardFor(profile),
          received: paid != null,
        ),
      );
    }
    for (final task in catalog.tasks) {
      final paid = entries
          .where((entry) => entry.referenceId == task.id)
          .firstOrNull;
      if (profile.completedTask(task.id) && paid == null) continue;
      result.add(
        BudgetIncomeOption(
          id: 'task:${task.id}',
          title: 'Задание «${task.title}»',
          base: task.reward,
          expected:
              paid?.amount ??
              task.reward -
                  (profile.satiety < 50 || profile.energy < 50 ? 1 : 0),
          received: paid != null,
        ),
      );
    }
    for (final sapling in profile.saplings) {
      final definition = catalog.sapling(sapling.definitionId);
      if (profile.period - sapling.plantedPeriod < definition.term) continue;
      result.add(
        BudgetIncomeOption(
          id: 'tree:${sapling.id}',
          title: 'Урожай Котодерева',
          base: definition.reward,
          expected: definition.reward,
          received: false,
        ),
      );
    }
    for (final entry in entries.where(
      (entry) => entry.label.startsWith('Урожай:'),
    )) {
      result.add(
        BudgetIncomeOption(
          id: 'tree:${entry.referenceId}',
          title: entry.label,
          base: entry.amount,
          expected: entry.amount,
          received: true,
        ),
      );
    }
    return result;
  }

  static int totalFor(
    GameProfile profile,
    GameCatalog catalog,
    List<String> sourceIds,
  ) {
    if (sourceIds.toSet().length != sourceIds.length) {
      throw const GameRuleException(
        'Один источник дохода нельзя выбрать дважды.',
      );
    }
    final byId = {
      for (final option in options(profile, catalog)) option.id: option,
    };
    var total = 0;
    for (final id in sourceIds) {
      final option = byId[id];
      if (option == null) {
        throw const GameRuleException(
          'Выбранный источник дохода больше недоступен. Обнови план.',
        );
      }
      total += option.expected;
    }
    return total;
  }
}
