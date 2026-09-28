import '../models/game_profile.dart';
import '../models/learning_task.dart';
import '../models/market_session.dart';
import 'activity_reward_rules.dart';
import 'game_rules.dart';
import 'learning_difficulty_rules.dart';
import 'mini_game_rules.dart';

class MarketCartResult {
  const MarketCartResult({
    required this.canClaim,
    required this.spent,
    required this.remaining,
    required this.message,
  });

  final bool canClaim;
  final int spent;
  final int remaining;
  final String message;
}

enum MarketAction { start, toggle, clear, confirm, understood, finish }

/// Корзина учебная; только награда завершённой игры меняет кошелёк.
abstract final class MarketGameRules {
  static const simple = MarketScenario(
    version: 1,
    budget: 30,
    reserve: 7,
    items: [
      MarketGameItem(id: 'food', title: 'Корм', price: 8, needed: true),
      MarketGameItem(id: 'shampoo', title: 'Шампунь', price: 5, needed: true),
      MarketGameItem(id: 'toy', title: 'Игрушка', price: 10, needed: false),
    ],
  );
  static const medium = MarketScenario(
    version: 1,
    budget: 60,
    reserve: 15,
    items: [
      MarketGameItem(id: 'food', title: 'Корм', price: 15, needed: true),
      MarketGameItem(id: 'shampoo', title: 'Шампунь', price: 10, needed: true),
      MarketGameItem(id: 'toy', title: 'Игрушка', price: 20, needed: false),
    ],
  );
  static const hard = MarketScenario(
    version: 1,
    budget: 100,
    reserve: 25,
    items: [
      MarketGameItem(id: 'food', title: 'Корм', price: 25, needed: true),
      MarketGameItem(id: 'shampoo', title: 'Шампунь', price: 15, needed: true),
      MarketGameItem(id: 'vet', title: 'Осмотр', price: 20, needed: true),
      MarketGameItem(id: 'book', title: 'Книжка', price: 15, needed: false),
      MarketGameItem(id: 'toy', title: 'Игрушка', price: 30, needed: false),
    ],
  );

  static const int budget = 60;
  static final items = medium.items;

  static MarketScenario scenarioFor(LearningDifficulty difficulty) =>
      switch (difficulty) {
        LearningDifficulty.simple => simple,
        LearningDifficulty.medium => medium,
        LearningDifficulty.hard => hard,
      };

  static MarketGameItem item(String id, {MarketScenario scenario = medium}) =>
      scenario.items.firstWhere(
        (entry) => entry.id == id,
        orElse: () =>
            throw ArgumentError.value(id, 'id', 'Unknown market item'),
      );

  static int spent(
    Iterable<String> itemIds, {
    MarketScenario scenario = medium,
  }) => itemIds.fold(
    0,
    (total, id) => total + item(id, scenario: scenario).price,
  );

  static List<String> targetIds(MarketScenario scenario) {
    final needs = scenario.items.where((entry) => entry.needed).toList();
    final limit =
        scenario.budget -
        scenario.reserve -
        needs.fold<int>(0, (sum, entry) => sum + entry.price);
    final wants =
        scenario.items
            .where((entry) => !entry.needed && entry.price <= limit)
            .toList()
          ..sort((left, right) => right.price.compareTo(left.price));
    return [
      for (final entry in needs) entry.id,
      if (wants.isNotEmpty) wants.first.id,
    ];
  }

  static MarketCartResult evaluate(
    List<String> selection, {
    MarketScenario scenario = medium,
  }) {
    if (selection.toSet().length != selection.length) {
      throw ArgumentError.value(
        selection,
        'selection',
        'Duplicate market item',
      );
    }
    final total = spent(selection, scenario: scenario);
    final remaining = scenario.budget - total;
    MarketCartResult result(bool canClaim, String message) => MarketCartResult(
      canClaim: canClaim,
      spent: total,
      remaining: remaining,
      message: message,
    );

    if (remaining < 0) {
      return result(
        false,
        'В корзине больше бюджета на ${-remaining} коткоинов. Сначала верни нужные товары, затем проверь, помещается ли желание и остаётся ли ${scenario.reserve} для копилки.',
      );
    }
    final missing = scenario.items
        .where((entry) => entry.needed && !selection.contains(entry.id))
        .toList();
    if (missing.isNotEmpty) {
      return result(
        false,
        'Проверь, что в корзине есть нужное: ${missing.map((entry) => entry.title.toLowerCase()).join(', ')}. Сначала закрываем то, что нужно котику.',
      );
    }
    if (remaining < scenario.reserve) {
      return result(
        false,
        'В корзине больше, чем разрешает план, на ${scenario.reserve - remaining} коткоинов. Проверь, остаётся ли ${scenario.reserve} для копилки.',
      );
    }
    final target = targetIds(scenario);
    if (selection.toSet().difference(target.toSet()).isNotEmpty ||
        target.toSet().difference(selection.toSet()).isNotEmpty) {
      final neededTotal = scenario.items
          .where((entry) => entry.needed)
          .fold<int>(0, (sum, entry) => sum + entry.price);
      final want = item(target.last, scenario: scenario);
      return result(
        false,
        'Нужное стоит $neededTotal. После резерва ${scenario.reserve} на радость хватает ${scenario.budget - neededTotal - scenario.reserve}. Выбери ${want.title.toLowerCase()}.',
      );
    }
    final neededTotal = scenario.items
        .where((entry) => entry.needed)
        .fold<int>(0, (sum, entry) => sum + entry.price);
    final want = item(target.last, scenario: scenario);
    return result(
      true,
      'Нужное стоит $neededTotal. После покупки ${want.title.toLowerCase()} вся корзина стоит $total, поэтому $remaining коткоинов остаются в копилке.',
    );
  }

  static ActivityRewardSnapshot snapshot(MarketSession session) =>
      ActivityRewardSnapshot(
        period: session.period,
        dayKey: session.dayKey,
        satiety: session.startSatiety,
        energy: session.startEnergy,
        mood: session.startMood,
      );

  static GameProfile apply(
    GameProfile profile,
    String sessionId,
    MarketAction action, {
    String? itemId,
  }) {
    if (sessionId.trim().isEmpty) {
      throw ArgumentError.value(sessionId, 'sessionId');
    }
    if (action == MarketAction.start) {
      GameRules.requirePlan(profile);
      if (profile.marketSessions.any((entry) => entry.id == sessionId)) {
        return profile;
      }
      final difficulty = profile.learningTopic('kotomarket').difficulty;
      return profile.copyWith(
        marketSessions: [
          ...profile.marketSessions,
          MarketSession(
            id: sessionId,
            period: profile.period,
            dayKey: profile.dayKey,
            difficulty: difficulty,
            scenario: scenarioFor(difficulty),
            startSatiety: profile.satiety,
            startEnergy: profile.energy,
            startMood: profile.mood,
          ),
        ],
      );
    }
    final session = profile.marketSessions
        .where((entry) => entry.id == sessionId)
        .firstOrNull;
    if (session == null) {
      throw const GameRuleException('Сессия не найдена. Начни игру заново.');
    }
    if (session.completed) return profile;
    snapshot(session).requireCurrentDay(profile);
    if (action == MarketAction.finish) {
      if (!session.solved) {
        throw const GameRuleException('Сначала собери корзину.');
      }
      final paid = MiniGameRules.claim(
        profile,
        MiniGameKind.kotomarket,
        sessionId,
        snapshot: snapshot(session),
      );
      final reward =
          paid.transactions
              .where((entry) => entry.id == 'mini-game-$sessionId')
              .firstOrNull
              ?.amount ??
          0;
      final advanced = LearningDifficultyRules.afterTask(
        paid,
        'kotomarket',
        clean: session.firstTry,
      );
      return _replace(
        advanced,
        session.copyWith(completed: true, paidReward: reward),
      );
    }
    if (session.solved) return profile;
    MarketSession updated;
    switch (action) {
      case MarketAction.toggle:
        if (itemId == null) throw const GameRuleException('Выбери товар.');
        item(itemId, scenario: session.scenario);
        final selection = [...session.selectedIds];
        selection.contains(itemId)
            ? selection.remove(itemId)
            : selection.add(itemId);
        updated = session.copyWith(selectedIds: selection, clearFeedback: true);
      case MarketAction.clear:
        updated = session.copyWith(selectedIds: const [], clearFeedback: true);
      case MarketAction.confirm:
        final result = evaluate(
          session.selectedIds,
          scenario: session.scenario,
        );
        updated = session.copyWith(
          attempts: session.attempts + 1,
          hintUsed: session.hintUsed || !result.canClaim,
          solved: result.canClaim,
          lastFeedback: result.message,
        );
      case MarketAction.understood:
        if (session.attempts < 2) {
          throw const GameRuleException(
            'Сначала попробуй собрать корзину ещё раз.',
          );
        }
        final target = targetIds(session.scenario);
        final result = evaluate(target, scenario: session.scenario);
        updated = session.copyWith(
          selectedIds: target,
          reviewed: true,
          hintUsed: true,
          solved: true,
          lastFeedback: 'Разбор: ${result.message}',
        );
      case MarketAction.start || MarketAction.finish:
        throw StateError('Unexpected market action');
    }
    return _replace(profile, updated);
  }

  static GameProfile _replace(GameProfile profile, MarketSession session) =>
      profile.copyWith(
        marketSessions: [
          for (final entry in profile.marketSessions)
            entry.id == session.id ? session : entry,
        ],
      );
}
