import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_controller.dart';

/// Сохраняет предпочтение после записи, оставляя возможность повторить ошибку.
class MotionSettings extends ConsumerStatefulWidget {
  const MotionSettings({super.key});
  @override
  ConsumerState<MotionSettings> createState() => _MotionSettingsState();
}

class _MotionSettingsState extends ConsumerState<MotionSettings> {
  bool _saving = false;
  String? _error;

  Future<void> _save(bool value) async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(reduceMotionProvider.notifier).save(value);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Не удалось сохранить настройку. Попробуйте ещё раз.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => ref
      .watch(reduceMotionProvider)
      .when(
        loading: () => const Text('Загружаем настройки отображения…'),
        error: (_, _) => TextButton(
          onPressed: () => ref.invalidate(reduceMotionProvider),
          child: const Text('Повторить загрузку настроек'),
        ),
        data: (reduceMotion) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Отключить анимации переходов'),
              subtitle: const Text(
                'Без движения между экранами и при открытии диалогов. Общая настройка для обоих профилей.',
              ),
              value: reduceMotion,
              onChanged: _saving ? null : (value) => _save(value!),
            ),
            const Text(
              'Питомец нарисован статично. Звуки не используются. Системная настройка уменьшения анимаций также учитывается.',
            ),
            if (_error != null)
              Semantics(liveRegion: true, child: Text(_error!)),
          ],
        ),
      );
}
