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
                    if (!_claimed) _hintFooter(),
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
              'Задание ${_index + 1} из ${AccountantRules.questions.length}',
              style: const TextStyle(
                color: _brown,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < AccountantRules.questions.length; i++)
                  Icon(
                    i < _index ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 16,
                    color: const Color(0xFF9A9A9A),
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
            accessory: profile.accessory ?? PetAccessory.scarf,
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
              'Подсказка: ${_question.paid} − ${_question.price} = ?',
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
            onPressed: () => setState(() => _hintVisible = true),
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
