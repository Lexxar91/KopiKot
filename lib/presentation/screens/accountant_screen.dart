import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../../domain/rules/accountant_rules.dart';
import '../../domain/rules/mini_game_rules.dart';
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
  int? _selected;
  bool _checked = false;
  bool _hintVisible = false;
  bool _claiming = false;
  bool _claimed = false;
  int? _claimedReward;
  String? _error;
  final String _commandId = newCommandId();

  AccountantQuestion get _question => AccountantRules.questions[_index];

  Future<void> _continue() async {
    if (!_checked || !_question.isCorrect(_selected!)) return;
    if (_index < AccountantRules.questions.length - 1) {
      setState(() {
        _index++;
        _selected = null;
        _checked = false;
        _hintVisible = false;
      });
      return;
    }
    if (_claiming || _claimed) return;
    final profile = ref.read(gameControllerProvider).asData?.value;
    if (profile == null) return;
    setState(() {
      _claiming = true;
      _error = null;
    });
    try {
      await ref
          .read(gameControllerProvider.notifier)
          .claimMiniGame(MiniGameKind.accountant, _commandId);
      if (mounted) {
        setState(() {
          _claimedReward = MiniGameRules.rewardFor(profile);
          _claimed = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Не удалось сохранить награду. Попробуй ещё раз.',
        );
      }
    } finally {
      if (mounted) setState(() => _claiming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text('Сначала создай питомца.')),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFF88C9F6),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fairytale_background.png',
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
                    if (_claimed)
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
              Icon(Icons.calculate_rounded, color: Color(0xFF9B35DF)),
              SizedBox(width: 8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Бухгалтер',
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Text(
          'Задание ${_index + 1} из ${AccountantRules.questions.length}',
          style: const TextStyle(
            color: _brown,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ],
  );

  Widget _hero(GameProfile profile) => SizedBox(
    height: 115,
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
          right: 69,
          top: 5,
          child: _panel(
            padding: const EdgeInsets.all(7),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 145),
              child: Text(
                _claimed ? 'Мяу! Отличная работа!' : 'Помоги посчитать сдачу!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _brown,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 7,
          bottom: 0,
          child: Image.asset(
            _index == 0
                ? 'assets/images/quest_cat_food.png'
                : 'assets/images/budget_joy.png',
            width: 75,
            height: 75,
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
            Expanded(child: _amountTile('Цена', _question.price)),
            const SizedBox(width: 8),
            Expanded(child: _amountTile('Дали', _question.paid)),
          ],
        ),
      ],
    ),
  );

  Widget _amountTile(String label, int amount) => Container(
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: label == 'Цена'
          ? const Color(0xFFDCF4FF)
          : const Color(0xFFE4FBE8),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            '$label: ',
            style: const TextStyle(color: _brown, fontWeight: FontWeight.w800),
          ),
        ),
        Image.asset('assets/images/cat_coin.png', width: 22),
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
          childAspectRatio: 2.6,
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
          onTap: _claiming
              ? null
              : () => setState(() {
                  _selected = answer;
                  _checked = true;
                  _error = null;
                }),
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
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 5),
                Image.asset('assets/images/cat_coin.png', width: 27),
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
          child: Text(
            _question.isCorrect(_selected!)
                ? '${_question.paid} − ${_question.price} = ${_question.correctChange}. '
                      'Отлично посчитано!'
                : 'Давай проверим ещё раз: из полученной суммы вычти цену. '
                      'Заработанное не теряется.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: _brown, fontWeight: FontWeight.w800),
          ),
        ),
      if (_hintVisible) ...[
        const SizedBox(height: 6),
        Text(
          'Подсказка: ${_question.paid} − ${_question.price} = ?',
          textAlign: TextAlign.center,
          style: const TextStyle(color: _brown, fontWeight: FontWeight.w800),
        ),
      ],
      if (_error != null) ...[
        const SizedBox(height: 6),
        Text(_error!, style: const TextStyle(color: _brown)),
      ],
      if (_checked && _question.isCorrect(_selected!)) ...[
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
                  : _index == AccountantRules.questions.length - 1
                  ? 'Получить награду'
                  : 'Следующий пример',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),
        ),
      ],
      TextButton.icon(
        onPressed: () => setState(() => _hintVisible = true),
        icon: const Icon(Icons.lightbulb_outline_rounded),
        label: const Text('Подсказка'),
      ),
    ],
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
          '+${_claimedReward ?? 0} коткоинов',
          style: const TextStyle(
            color: _brown,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Text('Ты помог магазину и сохранил всё заработанное.'),
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
