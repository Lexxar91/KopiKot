import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_controller.dart';
import '../widgets/game_action_dialog.dart';
import '../widgets/accessible_motion.dart';
import '../widgets/motion_settings.dart';
import 'progress_screen.dart';

/// Обзор обучения и подтверждаемые действия только после барьера взрослого.
class AdultScreen extends ConsumerWidget {
  const AdultScreen({super.key});

  Future<void> _confirm(
    BuildContext context, {
    required String title,
    required String description,
    required Future<void> Function() action,
    String confirmLabel = 'Подтвердить',
  }) async {
    final saved = await showAccessibleDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameActionDialog(
        title: title,
        description: description,
        confirmLabel: confirmLabel,
        action: (_) => action(),
      ),
    );
    // После смены/сброса профиля старые игровые формы не должны оставаться в стеке.
    if (saved == true && context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    final catalog = ref.watch(gameCatalogProvider).asData?.value;
    final controller = ref.read(gameControllerProvider.notifier);
    final testProfile = profile?.isTest ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Для взрослого')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Учимся через заботу',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Ребёнок планирует бюджет, выбирает необходимое и откладывает на цели. Все монеты игровые: реальных денег, рекламы и покупок за деньги нет.',
            ),
            const SizedBox(height: 16),
            Text(
              testProfile ? 'Тестовый профиль' : 'Обычный профиль',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (profile == null)
              const Text(
                'Питомец ещё не создан. Можно открыть тестовый профиль для знакомства.',
              ),
            if (profile != null) ...[
              Text('Питомец: ${profile.petName}'),
              Text(
                'Стадия: ${profile.growthLabel}. Завершено периодов: ${profile.periodSummaries.length}.',
              ),
              Text(
                'Выполнено заданий: ${profile.taskProgress.where((entry) => entry.completed).length} из ${catalog?.tasks.length ?? 0}.',
              ),
              for (final topic
                  in (catalog?.tasks.map((task) => task.topic).toSet() ??
                      <String>{}))
                Text(
                  '$topic: ${catalog!.tasks.where((task) => task.topic == topic && profile.completedTask(task.id)).length} из ${catalog.tasks.where((task) => task.topic == topic).length}',
                ),
              Text('Накоплено на цели: ${profile.savings} монет.'),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ProgressScreen(),
                  ),
                ),
                child: const Text('Посмотреть итоги'),
              ),
            ],
            const SizedBox(height: 20),
            const Text(
              'Ошибки не отнимают достигнутый рост и завершённые задания. Обсуждайте выбор, не оценивая ребёнка. Дополнительные баллы от взрослого в этой версии не начисляются.',
            ),
            const SizedBox(height: 20),
            const MotionSettings(),
            const SizedBox(height: 20),
            const Text(
              'В тестовом профиле все задания доступны сразу. Кнопка в бюджете открывает следующий игровой день без ожидания. Обычное сохранение хранится отдельно.',
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _confirm(
                context,
                title: testProfile
                    ? 'Вернуться в обычный профиль?'
                    : 'Открыть тестовый профиль?',
                description:
                    'Оба сохранения останутся на устройстве. ${testProfile ? 'Если обычного питомца ещё нет, откроется знакомство.' : 'При первом входе создаётся Финни Тест со 100 стартовыми и 10 ежедневными коткоинами, целью «Беговая дорожка» и пустым прогрессом. Повторный вход продолжает тестовую игру.'}',
                action: () =>
                    controller.switchProfile(testProfile: !testProfile),
              ),
              child: Text(
                testProfile
                    ? 'Вернуться в обычный профиль'
                    : 'Открыть тестовый профиль',
              ),
            ),
            if (testProfile) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => _confirm(
                  context,
                  title: 'Сбросить тестовый профиль?',
                  description:
                      'Все покупки, накопления, задания и итоги только тестового профиля будут удалены. Финни Тест начнёт с первого дня: 100 стартовых и 10 ежедневных коткоинов. Обычный профиль не изменится. Отменить выполненный сброс нельзя.',
                  confirmLabel: 'Сбросить тестовый профиль',
                  action: controller.resetTestProfile,
                ),
                child: const Text('Сбросить тестовый профиль'),
              ),
            ] else if (profile != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => _confirm(
                  context,
                  title: 'Удалить обычный профиль?',
                  description:
                      'Питомец «${profile.petName}», его монеты, покупки, накопления, задания и итоги будут удалены с устройства. Откроется знакомство. Восстановить профиль нельзя. Отдельный тестовый профиль не изменится.',
                  confirmLabel: 'Удалить профиль',
                  action: controller.deleteRegularProfile,
                ),
                child: const Text('Удалить обычный профиль'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
