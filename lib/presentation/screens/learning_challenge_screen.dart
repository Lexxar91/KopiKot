import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../../domain/models/learning_scenario.dart';
import '../../domain/models/learning_task.dart';
import '../../domain/rules/activity_reward_rules.dart';
import '../../domain/rules/game_rules.dart';
import '../providers/game_controller.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';

const _brown = Color(0xFF642818);
const _cream = Color(0xFFFFF9EA);

/// Один экран для всех шести сценариев: условия берутся из текущей ступени.
class LearningChallengeScreen extends ConsumerStatefulWidget {
  const LearningChallengeScreen({required this.task, super.key});
  final LearningTask task;

  @override
  ConsumerState<LearningChallengeScreen> createState() =>
      _LearningChallengeScreenState();
}

class _LearningChallengeScreenState
    extends ConsumerState<LearningChallengeScreen> {
  final _amount = TextEditingController();
  final _selected = <String>{};
  String? _choice;
  String? _error;
  bool _busy = false;
  bool _finished = false;
  late final LearningScenario _scenario;
  late final LearningDifficulty _difficulty;
  late final ActivityRewardSnapshot _snapshot;
  late final bool _practice;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(gameControllerProvider).asData!.value!;
    _practice = profile.completedTaskToday(widget.task.id);
    _snapshot = ActivityRewardSnapshot.fromProfile(profile);
    _difficulty = profile.learningTopic(widget.task.topic).difficulty;
    _scenario = LearningScenario.forTask(
      widget.task.id,
      _difficulty,
      practice: _practice,
    );
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  TaskAnswer get _answer => TaskAnswer(
    needs: int.tryParse(_amount.text) ?? -1,
    choice: _choice,
    products: _selected.toList(),
  );

  Future<void> _submit({bool acknowledge = false}) async {
    if (!acknowledge &&
        _scenario.kind == LearningAnswerKind.amount &&
        _amount.text.isEmpty) {
      setState(() => _error = 'Введи число коткоинов.');
      return;
    }
    final correct = _scenario.accepts(_answer);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (acknowledge) {
        await ref
            .read(gameControllerProvider.notifier)
            .acknowledgeTask(widget.task.id, snapshot: _snapshot);
      } else {
        await ref
            .read(gameControllerProvider.notifier)
            .submitTask(widget.task.id, _answer, snapshot: _snapshot);
      }
      if (mounted && (acknowledge || correct)) {
        setState(() => _finished = true);
      }
    } on GameRuleException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Не удалось сохранить ответ. Попробуй ещё раз.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    if (profile == null) return const SizedBox.shrink();
    final progress = profile.taskProgressToday(widget.task.id);
    final attemptCount = _practice
        ? progress?.practiceAttempts ?? 0
        : progress?.attempts ?? 0;
    final finishedCorrectly = _finished && _scenario.accepts(_answer);
    return Scaffold(
      backgroundColor: const Color(0xFF8BCBF5),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fairytale_background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                  children: [
                    Row(
                      children: [
                        IconButton.filled(
                          tooltip: 'Назад',
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF8835E8),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(52, 52),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(child: StoryLogo(height: 56)),
                        const SizedBox(width: 60),
                      ],
                    ),
                    const SizedBox(height: 7),
                    _panel(
                      child: Column(
                        children: [
                          Text(
                            widget.task.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: _brown,
                              fontSize: 27,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 5),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEBC8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 3,
                              ),
                              child: Text(
                                '${widget.task.topic} · ${_difficultyName(_difficulty)}',
                                style: const TextStyle(
                                  color: _brown,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 155,
                      child: Row(
                        children: [
                          PetPortrait(
                            coat: profile.coat,
                            accessory: profile.accessory,
                            stage: profile.growthStage,
                            emotion: PetEmotion.happy,
                            size: 155,
                          ),
                          const SizedBox(width: 5),
                          Expanded(child: _sceneItems()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    _panel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _scenario.prompt,
                            style: const TextStyle(
                              color: _brown,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _answerInput(),
                          if (attemptCount > 0 || _finished) ...[
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: finishedCorrectly
                                    ? const Color(0xFFDBFFDA)
                                    : const Color(0xFFFFEFD4),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _finished
                                        ? finishedCorrectly
                                              ? 'Верно!'
                                              : 'Разобрали вместе!'
                                        : 'Попробуй ещё раз',
                                    style: TextStyle(
                                      color: finishedCorrectly
                                          ? const Color(0xFF087E37)
                                          : _brown,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    _finished
                                        ? _scenario.explanation
                                        : profile.feedback,
                                    style: const TextStyle(
                                      color: _brown,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      _panel(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: _brown),
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    if (!_finished)
                      FilledButton(
                        onPressed: _busy ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF8738E6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        child: const Text('Проверить ответ'),
                      ),
                    if (!_finished && attemptCount >= 2) ...[
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: _busy
                            ? null
                            : () => _submit(acknowledge: true),
                        child: const Text('Понятно'),
                      ),
                    ],
                    if (_finished)
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF8738E6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        child: const Text('К заданиям'),
                      ),
                    const SizedBox(height: 7),
                    Text(
                      _practice
                          ? 'Тренировка с новыми числами · без повторной награды'
                          : 'Базовая награда: 12 · ожидаемая: ${_snapshot.taskReward} коткоинов',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: _brown, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> get _sceneObjectIds => switch (widget.task.id) {
    'need_first' => ['wallet', 'food', 'mouse'],
    'day_plan' => ['feed', 'vet', _scenario.options.last.id],
    'regular_saving' => ['coins', 'jar', 'sapling'],
    'saving_target' => ['coins', 'jar', 'goal'],
    'compare_price' => ['a', 'b', 'coins'],
    'free_paid' => ['wallet', 'free', 'treat'],
    _ => ['coins', 'jar', 'goal'],
  };

  List<String> get _sceneValues {
    final numbers = RegExp(
      r'\d+',
    ).allMatches(_scenario.prompt).map((match) => match.group(0)!).toList();
    if (widget.task.id == 'day_plan') {
      return [
        for (final option in [
          _scenario.options.first,
          _scenario.options[1],
          _scenario.options.last,
        ])
          RegExp(r'\d+').firstMatch(option.label)?.group(0) ?? '',
      ];
    }
    if (widget.task.id == 'compare_price' && numbers.length >= 4) {
      return [numbers[0], numbers[2], numbers[3]];
    }
    if (widget.task.id == 'free_paid' && numbers.length >= 3) {
      return [numbers[0], '0', numbers[2]];
    }
    return numbers.take(3).toList();
  }

  Widget _sceneItems() {
    final ids = _sceneObjectIds;
    final values = _sceneValues;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var index = 0; index < ids.length; index++)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (index < values.length && values[index].isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _cream,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Text(
                      values[index],
                      style: const TextStyle(
                        color: _brown,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                _objectArtwork(ids[index], 57),
              ],
            ),
          ),
      ],
    );
  }

  Widget _objectArtwork(String id, double size) {
    final path = switch (id) {
      'wallet' || 'jar' => 'assets/images/budget_savings.png',
      'food' || 'feed' => 'assets/images/quest_cat_food.png',
      'mouse' => 'assets/images/quest_toy_mouse.png',
      'vet' => 'assets/images/vet_rabbit.png',
      'cheap' =>
        _difficulty == LearningDifficulty.hard
            ? null
            : 'assets/images/action_play.png',
      'expensive' =>
        _difficulty == LearningDifficulty.hard
            ? 'assets/images/savings_bed.png'
            : 'assets/images/wardrobe_bow.png',
      'coins' => 'assets/images/cat_coin.png',
      'sapling' => 'assets/images/garden_coin_sapling.png',
      'goal' => 'assets/images/savings_treadmill.png',
      'a' || 'b' => null,
      'free' => 'assets/images/action_walk.png',
      'treat' => 'assets/images/shop_milk.png',
      _ => null,
    };
    if (path == null) {
      return Icon(
        id == 'ride' ? Icons.directions_bus_rounded : Icons.menu_book_rounded,
        key: ValueKey('task-art-$id'),
        size: size,
        color: const Color(0xFF4963BB),
      );
    }
    return Image.asset(
      path,
      key: ValueKey('task-art-$id'),
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }

  Widget _answerInput() {
    if (_scenario.kind == LearningAnswerKind.amount) {
      return TextField(
        controller: _amount,
        enabled: !_finished && !_busy,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: 'Ответ',
          suffixText: 'коткоинов',
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset('assets/images/cat_coin.png', width: 27),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(21)),
        ),
      );
    }
    return Column(
      children: [
        for (final option in _scenario.options)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: _scenario.kind == LearningAnswerKind.choice
                  ? _choice == option.id
                        ? const Color(0xFFE4FFE6)
                        : Colors.white
                  : _selected.contains(option.id)
                  ? const Color(0xFFE4FFE6)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21),
                side: BorderSide(
                  color: _choice == option.id || _selected.contains(option.id)
                      ? const Color(0xFF0BAF56)
                      : Colors.white,
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: _finished || _busy
                    ? null
                    : () => setState(() {
                        if (_scenario.kind == LearningAnswerKind.choice) {
                          _choice = option.id;
                        } else if (!_selected.add(option.id)) {
                          _selected.remove(option.id);
                        }
                      }),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        _scenario.kind == LearningAnswerKind.choice
                            ? (_choice == option.id
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off)
                            : (_selected.contains(option.id)
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank),
                        color:
                            _choice == option.id ||
                                _selected.contains(option.id)
                            ? const Color(0xFF0BAF56)
                            : _brown,
                      ),
                      const SizedBox(width: 7),
                      _objectArtwork(option.id, 46),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          option.label,
                          style: const TextStyle(
                            color: _brown,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (_choice == option.id || _selected.contains(option.id))
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF0BAF56),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _panel({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: _cream,
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: const [
        BoxShadow(
          color: Color(0x449B6928),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: child,
  );
}

String _difficultyName(LearningDifficulty value) => switch (value) {
  LearningDifficulty.simple => 'Простая',
  LearningDifficulty.medium => 'Средняя',
  LearningDifficulty.hard => 'Сложная',
};
