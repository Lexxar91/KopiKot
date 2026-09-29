import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../../domain/models/accountant_session.dart';
import '../../domain/models/learning_task.dart';
import '../../domain/rules/accountant_rules.dart';
import '../../domain/rules/game_rules.dart';
import '../providers/game_controller.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';

const _brown = Color(0xFF642818);
const _cream = Color(0xFFFFF9EA);

/// Два примера на сдачу; ошибка даёт подсказку и не меняет баланс.
class AccountantScreen extends ConsumerStatefulWidget {
  const AccountantScreen({super.key});

  @override
  ConsumerState<AccountantScreen> createState() => _AccountantScreenState();
}

class _AccountantScreenState extends ConsumerState<AccountantScreen> {
  int _index = 0;
  bool _claiming = false;
  String? _error;
  String? _sessionId;
  AccountantSession? _session;

  AccountantQuestion get _question => _session!.questions[_index];
  AccountantAnswerState get _answer => _session!.progress[_index];
  int? get _selected => _answer.answers.lastOrNull;
  bool get _checked => _answer.answers.isNotEmpty;
  bool get _hintVisible => _answer.hintUsed;
  bool get _claimed => _session?.completed ?? false;
  int get _claimedReward => _session?.paidReward ?? 0;

  Future<void> _apply(AccountantAction action, {int? answer}) async {
    final id = _sessionId;
    if (id == null || _claiming) return;
    setState(() {
      _claiming = true;
      _error = null;
    });
    try {
      await ref
          .read(gameControllerProvider.notifier)
          .accountantAction(id, action, answer: answer);
    } on GameRuleException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Не удалось сохранить ответ. Попробуй ещё раз.',
        );
      }
    } finally {
      if (mounted) setState(() => _claiming = false);
    }
  }

  Future<void> _start() async {
    _sessionId = newCommandId();
    await _apply(AccountantAction.start);
    if (mounted && _session == null && _error != null) _sessionId = null;
  }

  Future<void> _continue() async {
    if (!_answer.solved) return;
    if (_index < _session!.questions.length - 1) {
      setState(() => _index++);
      return;
    }
    await _apply(AccountantAction.finish);
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
      final unfinished = profile.accountantSessions
          .where(
            (entry) =>
                !entry.completed &&
                entry.period == profile.period &&
                entry.dayKey == profile.dayKey,
          )
          .lastOrNull;
      if (unfinished != null) {
        _sessionId = unfinished.id;
        _index = unfinished.currentIndex;
      }
    }
    _session = profile.accountantSessions
        .where((entry) => entry.id == _sessionId)
        .firstOrNull;
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
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(12, 5, 12, 24),
                        children: [
                          _topBar(profile),
                          const SizedBox(height: 5),
                          _titleBar(context),
                          _hero(profile),
                          if (_session == null)
                            _startCard(profile)
                          else if (_claimed)
                            _resultCard(context)
                          else ...[
                            _questionCard(),
                            const SizedBox(height: 10),
                            _answersCard(),
                            const SizedBox(height: 10),
                            _actions(),
                          ],
                        ],
                      ),
                    ),
                    if (_session != null && !_claimed && !_answer.solved)
                      _hintFooter(),
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
            Image.asset('assets/images/cat_coin.png', width: 30),
            const SizedBox(width: 5),
            Text(
              '${profile.balance}',
              style: const TextStyle(
                color: _brown,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 5),
            const CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFF00A979),
              child: Icon(Icons.add_rounded, color: Colors.white),
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
              CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF9B35DF),
                child: Icon(Icons.calculate_rounded, color: Colors.white),
              ),
              SizedBox(width: 8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Бухгалтер',
                    style: TextStyle(
                      color: _brown,
                      fontSize: 25,
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Задание ${_index + 1} из ${_session?.questions.length ?? 2}',
              style: const TextStyle(
                color: _brown,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < (_session?.questions.length ?? 2); i++)
                  Icon(
                    _session?.progress[i].firstTry == true
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    size: 16,
                    color: _session?.progress[i].firstTry == true
                        ? const Color(0xFFFFB52B)
                        : const Color(0xFF9A9A9A),
                  ),
              ],
            ),
          ],
        ),
      ),
    ],
  );

  Widget _hero(GameProfile profile) => SizedBox(
    height: 137,
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
            size: 136,
          ),
        ),
        Positioned(
          right: 70,
          top: 9,
          child: _panel(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 118),
              child: Text(
                _claimed ? 'Мяу! Отличная работа!' : 'Помоги посчитать сдачу!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _brown,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Image.asset(
            _index == 0
                ? 'assets/images/quest_cat_food.png'
                : 'assets/images/budget_joy.png',
            width: 105,
            height: 105,
            fit: BoxFit.contain,
          ),
        ),
      ],
    ),
  );

  Widget _questionCard() => _panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_question.product} стоит ${_question.price} коткоинов. '
          '${_question.secondProduct == null ? '' : '${_question.secondProduct} стоит ${_question.secondPrice}. '} '
          'Покупатель дал ${_question.paid}. Сколько сдачи вернуть?',
          style: const TextStyle(
            color: _brown,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _amountTile('Цена', _question.totalPrice)),
            const SizedBox(width: 8),
            Expanded(child: _amountTile('Дали', _question.paid)),
          ],
        ),
      ],
    ),
  );

  Widget _amountTile(String label, int amount) => Container(
    height: 58,
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: label == 'Цена'
          ? const Color(0xFFDCF4FF)
          : const Color(0xFFE4FBE8),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Image.asset(
          label == 'Цена'
              ? _index == 0
                    ? 'assets/images/action_feed.png'
                    : 'assets/images/budget_joy.png'
              : 'assets/images/cat_coin.png',
          width: 47,
          height: 48,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 3),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label:',
                style: const TextStyle(
                  color: _brown,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Row(
                children: [
                  Image.asset('assets/images/cat_coin.png', width: 20),
                  Text(
                    '$amount',
                    style: const TextStyle(
                      color: _brown,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _answersCard() => _panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎯  Выбери ответ',
          style: TextStyle(
            color: _brown,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.7,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            for (var index = 0; index < _question.choices.length; index++)
              _answerTile(index, _question.choices[index]),
          ],
        ),
      ],
    ),
  );

  Widget _startCard(GameProfile profile) => _panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Помоги посчитать сдачу!',
          style: TextStyle(
            color: _brown,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        const Text('Два примера. За первые правильные ответы получишь звёзды.'),
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
                    profile.learningTopic('accountant').difficulty ==
                    difficulty,
                onSelected: _claiming
                    ? null
                    : (_) => ref
                          .read(gameControllerProvider.notifier)
                          .chooseLearningDifficulty('accountant', difficulty),
                selectedColor: const Color(0xFF00B896),
                backgroundColor: const Color(0xFFFFE9BF),
                labelStyle: const TextStyle(
                  color: _brown,
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
        ),
        if (profile.learningTopic('accountant').downgradePending) ...[
          const SizedBox(height: 6),
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
                      'accountant',
                      LearningDifficulty.values[profile
                              .learningTopic('accountant')
                              .difficulty
                              .index -
                          1],
                    ),
                child: const Text('Ступень проще'),
              ),
              TextButton(
                onPressed: () => ref
                    .read(gameControllerProvider.notifier)
                    .dismissLearningDowngrade('accountant'),
                child: const Text('Оставить как есть'),
              ),
            ],
          ),
        ],
        const SizedBox(height: 9),
        FilledButton.icon(
          key: const Key('accountant-start'),
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

  Widget _stepCoin(String label) => Container(
    margin: const EdgeInsets.only(top: 5),
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFFFEBC2),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFFFC62B)),
    ),
    child: Text(
      label,
      style: const TextStyle(color: _brown, fontWeight: FontWeight.w900),
    ),
  );

  Widget _answerTile(int index, int answer) {
    const colors = [
      Color(0xFFFFF0C5),
      Color(0xFFDCF4FF),
      Color(0xFFFFE2E5),
      Color(0xFFE4FBE8),
    ];
    return Semantics(
      selected: _selected == answer,
      child: Material(
        color: colors[index],
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          key: Key('accountant-answer-$answer'),
          borderRadius: BorderRadius.circular(20),
          onTap: _claiming || _answer.solved
              ? null
              : () => _apply(AccountantAction.answer, answer: answer),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _selected == answer
                    ? const Color(0xFF9B35DF)
                    : Colors.white,
                width: 3,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$answer',
                  style: const TextStyle(
                    color: _brown,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 5),
                Image.asset('assets/images/cat_coin.png', width: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actions() => Column(
    children: [
      if (_checked)
        _panel(
          child: Column(
            children: [
              Text(
                _answer.solved
                    ? '${_question.paid} − ${_question.totalPrice} = ${_question.correctChange}. ${_answer.reviewed ? 'Разбор завершён!' : 'Отлично посчитано!'}'
                    : _answer.errors >= 2
                    ? 'Проверим по шагам:'
                    : 'Сначала сравни, сколько дали, и сколько стоит покупка. Попробуй ещё раз.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _brown,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (!_answer.solved && _answer.errors >= 2) ...[
                const SizedBox(height: 7),
                if (_question.secondPrice > 0)
                  Text(
                    '${_question.price} + ${_question.secondPrice} = ${_question.totalPrice}',
                    style: const TextStyle(
                      color: _brown,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 6,
                  children: [
                    _stepCoin('${_question.paid}'),
                    _stepCoin(
                      '− ${(_question.totalPrice ~/ 10) * 10} = ${_question.paid - (_question.totalPrice ~/ 10) * 10}',
                    ),
                    _stepCoin(
                      '− ${_question.totalPrice % 10} = ${_question.correctChange}',
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                FilledButton(
                  key: const Key('accountant-understood'),
                  onPressed: _claiming
                      ? null
                      : () => _apply(AccountantAction.understood),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF09AC78),
                  ),
                  child: const Text('Понятно'),
                ),
              ],
            ],
          ),
        ),
      if (_error != null) ...[
        const SizedBox(height: 6),
        Text(_error!, style: const TextStyle(color: _brown)),
      ],
      if (_answer.solved) ...[
        const SizedBox(height: 7),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            key: const Key('accountant-primary'),
            onPressed: _claiming ? null : _continue,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFFCE31),
              foregroundColor: _brown,
              minimumSize: const Size(0, 50),
            ),
            child: Text(
              _claiming
                  ? 'Сохраняем…'
                  : _index == _session!.questions.length - 1
                  ? 'Получить награду'
                  : 'Следующий пример',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),
        ),
      ],
    ],
  );

  Widget _hintFooter() => Padding(
    padding: const EdgeInsets.fromLTRB(12, 5, 12, 8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_hintVisible)
          _panel(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(
              'Сначала сравни, сколько дали, и сколько стоит покупка.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _brown,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        SizedBox(
          width: 205,
          height: 50,
          child: FilledButton.icon(
            key: const Key('accountant-hint'),
            onPressed: _claiming || _hintVisible
                ? null
                : () => _apply(AccountantAction.hint),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF2E6FF),
              foregroundColor: _brown,
              side: const BorderSide(color: Colors.white, width: 2),
            ),
            icon: const Icon(
              Icons.lightbulb_rounded,
              color: Color(0xFFE6A100),
              size: 27,
            ),
            label: const Text(
              'Подсказка',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            'Можно попробовать ещё раз',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _brown,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              shadows: [
                Shadow(color: _cream, blurRadius: 5),
                Shadow(color: _cream, offset: Offset(1, 1), blurRadius: 5),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _resultCard(BuildContext context) => _panel(
    child: Column(
      children: [
        const Icon(Icons.stars_rounded, color: Color(0xFFFFB52B), size: 56),
        const Text(
          'Сдача посчитана!',
          style: TextStyle(
            color: _brown,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          _claimedReward == 0
              ? 'Тренировка без новой награды'
              : 'Оба расчёта разобраны. Ты помог продавцу и получил $_claimedReward коткоинов',
          style: const TextStyle(
            color: _brown,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          'Звёзд за первую попытку: ${_session!.stars} из ${_session!.questions.length}',
        ),
        if (_claimedReward > 0)
          Text(AccountantRules.snapshot(_session!).gameExplanation),
        const Text('Уже заработанные коткоины остаются у тебя.'),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text('К котику'),
        ),
      ],
    ),
  );

  Widget _panel({required Widget child, EdgeInsetsGeometry? padding}) =>
      Container(
        padding: padding ?? const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: _cream,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: child,
      );
}
