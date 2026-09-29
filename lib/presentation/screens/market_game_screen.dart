import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../../domain/models/learning_task.dart';
import '../../domain/models/market_session.dart';
import '../../domain/rules/market_game_rules.dart';
import '../../domain/rules/game_rules.dart';
import '../providers/game_controller.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';

const _brown = Color(0xFF642818);
const _cream = Color(0xFFFFF9EA);

String _itemAsset(String id) => switch (id) {
  'food' => 'assets/images/quest_cat_food.png',
  'shampoo' => 'assets/images/market_shampoo.png',
  'toy' => 'assets/images/quest_toy_mouse.png',
  'vet' => 'assets/images/vet_rabbit.png',
  'book' => 'assets/images/quest_budget.png',
  _ => throw ArgumentError.value(id, 'id', 'Unknown market item'),
};

/// Учебная корзина: товары можно перетаскивать или выбирать нажатием.
class MarketGameScreen extends ConsumerStatefulWidget {
  const MarketGameScreen({super.key});

  @override
  ConsumerState<MarketGameScreen> createState() => _MarketGameScreenState();
}

class _MarketGameScreenState extends ConsumerState<MarketGameScreen> {
  bool _claiming = false;
  String? _sessionId;
  MarketSession? _session;
  String? _error;

  List<String> get _selected => _session?.selectedIds ?? const [];
  MarketScenario get _scenario => _session!.scenario;
  bool get _completed => _session?.completed ?? false;
  int get _reward => _session?.paidReward ?? 0;

  Future<void> _apply(MarketAction action, {String? itemId}) async {
    final id = _sessionId;
    if (id == null || _claiming) return;
    setState(() {
      _claiming = true;
      _error = null;
    });
    try {
      await ref
          .read(gameControllerProvider.notifier)
          .marketAction(id, action, itemId: itemId);
    } on GameRuleException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Не удалось сохранить выбор. Попробуй ещё раз.',
        );
      }
    } finally {
      if (mounted) setState(() => _claiming = false);
    }
  }

  Future<void> _start() async {
    _sessionId = newCommandId();
    await _apply(MarketAction.start);
    if (mounted && _session == null && _error != null) _sessionId = null;
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text('Сначала создай питомца.')),
      );
    }
    if (_sessionId == null) {
      final unfinished = profile.marketSessions
          .where(
            (entry) =>
                !entry.completed &&
                entry.period == profile.period &&
                entry.dayKey == profile.dayKey,
          )
          .lastOrNull;
      if (unfinished != null) _sessionId = unfinished.id;
    }
    _session = profile.marketSessions
        .where((entry) => entry.id == _sessionId)
        .firstOrNull;
    final spent = _session == null
        ? 0
        : MarketGameRules.spent(_selected, scenario: _scenario);
    final remaining = _session == null ? 0 : _scenario.budget - spent;
    return Scaffold(
      backgroundColor: const Color(0xFF88C9F6),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/quest_market_background.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 5, 12, 24),
                  children: [
                    _topBar(profile),
                    const SizedBox(height: 7),
                    _titleBar(context),
                    _hero(profile),
                    if (_session == null)
                      _startCard(profile)
                    else ...[
                      _products(),
                      const SizedBox(height: 8),
                      _basketArea(),
                      const SizedBox(height: 8),
                      _summary(spent, remaining),
                      if (_session?.lastFeedback != null || _error != null) ...[
                        const SizedBox(height: 8),
                        _panel(
                          child: Text(
                            _error ?? _session!.lastFeedback!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: _brown,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                      if (_completed) ...[
                        const SizedBox(height: 8),
                        _panel(
                          child: Column(
                            children: [
                              Text(
                                _reward == 0
                                    ? 'Тренировка без новой награды.'
                                    : 'Корзина собрана! Получено $_reward коткоинов.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: _brown,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                _session!.firstTry
                                    ? '⭐ Звезда за первую попытку!'
                                    : _session!.reviewed
                                    ? 'Разбор завершён.'
                                    : 'Ты исправил выбор.',
                              ),
                              if (_reward > 0)
                                Text(
                                  MarketGameRules.snapshot(
                                    _session!,
                                  ).gameExplanation,
                                ),
                              const Text(
                                'Учебные товары не списали коткоины из кошелька.',
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      _actions(context),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(GameProfile profile) => Row(
    children: [
      const Expanded(child: StoryLogo(height: 44)),
      const SizedBox(width: 8),
      Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: _cream,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Image.asset('assets/images/cat_coin.png', width: 27),
            const SizedBox(width: 5),
            Text(
              '${profile.balance}',
              style: const TextStyle(
                color: _brown,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _titleBar(BuildContext context) => Row(
    children: [
      Material(
        color: const Color(0xFF9B35DF),
        borderRadius: BorderRadius.circular(22),
        child: IconButton(
          tooltip: 'Назад',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
      ),
      const SizedBox(width: 7),
      Expanded(
        child: _panel(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: const Row(
            children: [
              Icon(Icons.shopping_basket_rounded, color: Color(0xFF9B35DF)),
              SizedBox(width: 8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Котомаркет',
                    style: TextStyle(
                      color: _brown,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 5),
      _panel(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
        child: const Text(
          'Игра',
          style: TextStyle(color: _brown, fontWeight: FontWeight.w800),
        ),
      ),
    ],
  );

  Widget _hero(GameProfile profile) => SizedBox(
    height: 116,
    child: Stack(
      children: [
        Positioned(
          left: 0,
          bottom: 0,
          child: PetPortrait(
            coat: profile.coat,
            accessory: profile.accessory,
            emotion: profile.emotion,
            stage: profile.growthStage,
            size: 112,
          ),
        ),
        Positioned(
          right: 8,
          top: 13,
          child: _panel(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: const Text(
              'Сначала купим нужное!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _brown,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _startCard(GameProfile profile) => _panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Собери корзину',
          style: TextStyle(
            color: _brown,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Text(
          'Сначала нужное, потом радость. Не забудь оставить коткоины в кошельке!',
        ),
        const SizedBox(height: 8),
        const Text(
          'Сложность:',
          style: TextStyle(color: _brown, fontWeight: FontWeight.w900),
        ),
        Wrap(
          spacing: 6,
          children: [
            for (final difficulty in LearningDifficulty.values)
              ChoiceChip(
                label: Text(switch (difficulty) {
                  LearningDifficulty.simple => 'Простая',
                  LearningDifficulty.medium => 'Средняя',
                  LearningDifficulty.hard => 'Сложная',
                }),
                selected:
                    profile.learningTopic('kotomarket').difficulty ==
                    difficulty,
                onSelected: _claiming
                    ? null
                    : (_) => ref
                          .read(gameControllerProvider.notifier)
                          .chooseLearningDifficulty('kotomarket', difficulty),
                selectedColor: const Color(0xFF00B896),
                backgroundColor: const Color(0xFFFFE9BF),
                labelStyle: const TextStyle(
                  color: _brown,
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
        ),
        if (profile.learningTopic('kotomarket').downgradePending) ...[
          const Text(
            'Понадобилась помощь в трёх играх. Попробуем ступень проще?',
            style: TextStyle(color: _brown, fontWeight: FontWeight.w800),
          ),
          Wrap(
            spacing: 8,
            children: [
              TextButton(
                onPressed: () => ref
                    .read(gameControllerProvider.notifier)
                    .chooseLearningDifficulty(
                      'kotomarket',
                      LearningDifficulty.values[profile
                              .learningTopic('kotomarket')
                              .difficulty
                              .index -
                          1],
                    ),
                child: const Text('Ступень проще'),
              ),
              TextButton(
                onPressed: () => ref
                    .read(gameControllerProvider.notifier)
                    .dismissLearningDowngrade('kotomarket'),
                child: const Text('Оставить как есть'),
              ),
            ],
          ),
        ],
        const SizedBox(height: 9),
        FilledButton.icon(
          key: const Key('market-start'),
          onPressed: _claiming ? null : _start,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFFCE31),
            foregroundColor: _brown,
            minimumSize: const Size(0, 52),
          ),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text(
            'Начать',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
        ),
        if (_error != null)
          Text(_error!, style: const TextStyle(color: _brown)),
      ],
    ),
  );

  Widget _reviewCard() {
    final needs = _scenario.items.where((entry) => entry.needed).toList();
    final needsTotal = needs.fold<int>(0, (sum, entry) => sum + entry.price);
    final desire = MarketGameRules.item(
      MarketGameRules.targetIds(_scenario).last,
      scenario: _scenario,
    );
    return _panel(
      child: Column(
        children: [
          const Text(
            'Проверим по шагам',
            style: TextStyle(
              color: _brown,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            'Нужное: ${needs.map((entry) => entry.price).join(' + ')} = $needsTotal',
          ),
          Text(
            'После нужных покупок останется ${_scenario.budget - needsTotal}. '
            'Из них ${_scenario.reserve} нужно оставить в кошельке.',
          ),
          Text('Подходит ${desire.title.toLowerCase()} за ${desire.price}.'),
          FilledButton(
            key: const Key('market-understood'),
            onPressed: _claiming ? null : () => _apply(MarketAction.understood),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF09AC78),
            ),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }

  Widget _products() => _panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset('assets/images/cat_coin.png', width: 25),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Бюджет: ${_scenario.budget} коткоинов',
                style: const TextStyle(
                  color: _brown,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        Text(
          'Оставить в кошельке: ${_scenario.reserve}',
          style: const TextStyle(color: _brown, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              for (final item in _scenario.items)
                SizedBox(
                  width: (constraints.maxWidth - 10) / 3,
                  child: _draggableProduct(item),
                ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _draggableProduct(MarketGameItem item) {
    final selected = _selected.contains(item.id);
    final card = _productCard(item, selected);
    return LongPressDraggable<String>(
      data: item.id,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(width: 110, child: _productCard(item, selected)),
      ),
      childWhenDragging: Opacity(opacity: 0.45, child: card),
      child: card,
    );
  }

  Widget _productCard(MarketGameItem item, bool selected) => Material(
    color: item.needed ? const Color(0xFFE4FBE8) : const Color(0xFFFFE2E5),
    borderRadius: BorderRadius.circular(19),
    child: InkWell(
      key: Key('market-item-${item.id}'),
      borderRadius: BorderRadius.circular(19),
      onTap: _claiming || _session!.solved
          ? null
          : () => _apply(MarketAction.toggle, itemId: item.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: selected ? const Color(0xFF20B760) : Colors.white,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  _itemAsset(item.id),
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
                if (selected)
                  const Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF18BF67),
                      size: 23,
                    ),
                  ),
              ],
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.title,
                style: const TextStyle(
                  color: _brown,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/cat_coin.png', width: 18),
                Text(
                  '${item.price}',
                  style: const TextStyle(
                    color: _brown,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Widget _basketArea() => DragTarget<String>(
    key: const Key('market-basket'),
    onWillAcceptWithDetails: (details) =>
        !_claiming && !_session!.solved && !_selected.contains(details.data),
    onAcceptWithDetails: (details) =>
        _apply(MarketAction.toggle, itemId: details.data),
    builder: (context, candidates, rejected) => _panel(
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.shopping_basket_rounded, color: Color(0xFFE76135)),
              SizedBox(width: 6),
              Text(
                'Моя корзина',
                style: TextStyle(
                  color: _brown,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Container(
            height: 85,
            width: double.infinity,
            decoration: BoxDecoration(
              color: candidates.isEmpty
                  ? Colors.transparent
                  : const Color(0x8037CC85),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/market_basket.png',
                  width: 220,
                  height: 85,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  top: 4,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final id in _selected)
                        Image.asset(
                          _itemAsset(id),
                          width: 43,
                          height: 45,
                          fit: BoxFit.contain,
                          semanticLabel: MarketGameRules.item(
                            id,
                            scenario: _scenario,
                          ).title,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'Перетащи товар сюда или нажми на его карточку.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _brown, fontSize: 10),
          ),
        ],
      ),
    ),
  );

  Widget _summary(int spent, int remaining) => _panel(
    padding: const EdgeInsets.all(7),
    child: Row(
      children: [
        Expanded(
          child: _summaryTile('Потрачено', spent, const Color(0xFFFFE2E5)),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: _summaryTile('Осталось', remaining, const Color(0xFFDCF4FF)),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: _summaryTile(
            'Можно отложить',
            remaining.clamp(0, _scenario.budget),
            const Color(0xFFE4FBE8),
          ),
        ),
      ],
    ),
  );

  Widget _summaryTile(String label, int amount, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 7),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(color: _brown, fontWeight: FontWeight.w900),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/cat_coin.png', width: 18),
            Text(
              '$amount',
              style: const TextStyle(
                color: _brown,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _actions(BuildContext context) => Column(
    children: [
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          key: const Key('market-primary'),
          onPressed: _claiming
              ? null
              : _completed
              ? () => Navigator.of(context).maybePop()
              : _session!.solved
              ? () => _apply(MarketAction.finish)
              : _selected.isEmpty
              ? null
              : () => _apply(MarketAction.confirm),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFFCE31),
            foregroundColor: _brown,
            minimumSize: const Size(0, 52),
          ),
          child: Text(
            _claiming
                ? 'Сохраняем…'
                : _completed
                ? 'К котику'
                : _session!.solved
                ? 'Получить награду'
                : 'Готово',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
        ),
      ),
      if (!_completed && !_session!.solved)
        TextButton(
          onPressed: _selected.isEmpty || _claiming
              ? null
              : () => _apply(MarketAction.clear),
          child: const Text('Изменить выбор'),
        ),
      if (_session!.attempts >= 2 && !_session!.solved) _reviewCard(),
    ],
  );

  Widget _panel({required Widget child, EdgeInsetsGeometry? padding}) =>
      Container(
        padding: padding ?? const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _cream,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: child,
      );
}
