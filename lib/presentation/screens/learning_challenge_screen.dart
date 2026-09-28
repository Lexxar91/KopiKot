import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    _practice = profile.completedTask(widget.task.id);
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
    final progress = profile.taskProgress
        .where((entry) => entry.taskId == widget.task.id)
        .firstOrNull;
    final attemptCount = _practice
        ? progress?.practiceAttempts ?? 0
        : progress?.attempts ?? 0;
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
                  padding: const EdgeInsets.all(16),
                  children: [
                    const StoryLogo(height: 56),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton.filled(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _panel(
                            child: Text(
                              widget.task.title,
                              style: const TextStyle(
                                color: _brown,
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        PetPortrait(
                          coat: profile.coat,
                          accessory: profile.accessory,
                          stage: profile.growthStage,
                          emotion: profile.emotion,
                          size: 118,
                        ),
                        Expanded(
                          child: _panel(
                            child: const Text(
                              'Давай решим вместе!',
                              style: TextStyle(
                                color: _brown,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _panel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.task.topic} · ${_difficultyName(_difficulty)}',
                            style: const TextStyle(
                              color: _brown,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _scenario.prompt,
                            style: const TextStyle(
                              color: _brown,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _answerInput(),
                          const SizedBox(height: 12),
                          Text(
                            _practice
                                ? 'Тренировка с новыми числами · без повторной награды'
                                : 'Базовая награда: 12 · ожидаемая: ${_snapshot.taskReward} коткоинов',
                            style: const TextStyle(color: _brown),
                          ),
                        ],
                      ),
                    ),
                    if (attemptCount > 0 || _finished) ...[
                      const SizedBox(height: 12),
                      _panel(
                        child: Text(
                          profile.feedback,
                          style: const TextStyle(color: _brown, fontSize: 17),
                        ),
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      _panel(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: _brown),
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    if (!_finished)
                      FilledButton(
                        onPressed: _busy ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF007C68),
                          padding: const EdgeInsets.symmetric(vertical: 17),
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
                        child: const Text('К заданиям'),
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

  Widget _answerInput() {
    if (_scenario.kind == LearningAnswerKind.amount) {
      return TextField(
        controller: _amount,
        enabled: !_finished && !_busy,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          labelText: 'Ответ',
          suffixText: 'коткоинов',
          filled: true,
          fillColor: Colors.white,
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
                        ? const Color(0xFFD9FBEA)
                        : Colors.white
                  : _selected.contains(option.id)
                  ? const Color(0xFFD9FBEA)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                  padding: const EdgeInsets.all(13),
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
                      ),
                      const SizedBox(width: 9),
                      Expanded(child: Text(option.label)),
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
