import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_catalog.dart';
import '../../domain/models/learning_task.dart';
import '../../domain/rules/game_rules.dart';
import '../providers/game_controller.dart';
import '../widgets/accessible_motion.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    return Scaffold(
      appBar: AppBar(title: const Text('Задания')),
      body: ref
          .watch(gameCatalogProvider)
          .when(
            loading: () => const Center(child: LoadingStatus()),
            error: (_, _) => const Center(
              child: Text(
                'Не удалось открыть задания. Вернись и попробуй ещё раз.',
              ),
            ),
            data: (catalog) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'В заданиях используем учебные монеты. За разумное решение получишь награду в игре — один раз за задание.',
                ),
                if (profile?.plan == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Сначала подтверди бюджет этого периода.'),
                  ),
                for (final task in catalog.tasks)
                  Card(
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Text(
                        '${task.topic} · ${profile?.completedTask(task.id) == true ? 'Выполнено' : '+${task.reward} монет'}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              TaskScreen(task: task, catalog: catalog),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
    );
  }
}

/// Три взаимодействия: распределение, корзина и перевод с сохранением резерва.
class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({required this.task, required this.catalog, super.key});
  final LearningTask task;
  final GameCatalog catalog;
  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  final _needs = TextEditingController(text: '0');
  final _wants = TextEditingController(text: '0');
  final _savings = TextEditingController(text: '0');
  final _basket = <String>{};
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _needs.dispose();
    _wants.dispose();
    _savings.dispose();
    super.dispose();
  }

  Widget _number(
    String label,
    TextEditingController controller,
    bool enabled,
  ) => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.number,
      onChanged: (_) => setState(() {}),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(5),
      ],
      decoration: InputDecoration(labelText: label, suffixText: 'монет'),
    ),
  );

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(gameControllerProvider.notifier)
          .submitTask(
            widget.task.id,
            TaskAnswer(
              needs: int.tryParse(_needs.text) ?? 0,
              wants: int.tryParse(_wants.text) ?? 0,
              savings: int.tryParse(_savings.text) ?? 0,
              products: _basket.toList(),
            ),
          );
    } on GameRuleException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Не удалось сохранить попытку. Твой ответ остался здесь.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    final progress = profile?.taskProgress
        .where((entry) => entry.taskId == widget.task.id)
        .firstOrNull;
    final enabled = !_busy && progress?.completed != true;
    return Scaffold(
      appBar: AppBar(title: Text(widget.task.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            widget.task.topic,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Text(widget.task.prompt),
          const SizedBox(height: 8),
          const Text(
            'Учебная ситуация: твои покупки и накопления в игре не тратятся.',
          ),
          if (widget.task.kind == TaskKind.budget) ...[
            _number('Нужно', _needs, enabled),
            _number('Хочется', _wants, enabled),
            _number('На мечту', _savings, enabled),
            const SizedBox(height: 12),
            Text(
              'Распределено: ${(int.tryParse(_needs.text) ?? 0) + (int.tryParse(_wants.text) ?? 0) + (int.tryParse(_savings.text) ?? 0)} из ${widget.task.budget}',
            ),
          ] else if (widget.task.kind == TaskKind.saving)
            _number('Перевод на учебную цель', _savings, enabled)
          else ...[
            for (final id in widget.task.products)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(widget.catalog.product(id).title),
                subtitle: Text('${widget.catalog.product(id).price} монет'),
                value: _basket.contains(id),
                onChanged: !enabled
                    ? null
                    : (selected) => setState(() {
                        if (selected == true) {
                          _basket.add(id);
                        } else {
                          _basket.remove(id);
                        }
                      }),
              ),
            Text(
              'Корзина: ${_basket.fold<int>(0, (sum, id) => sum + widget.catalog.product(id).price)} из ${widget.task.budget}',
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: enabled && profile?.plan != null ? _submit : null,
            child: Text(
              progress?.completed == true
                  ? 'Задание выполнено'
                  : (_busy ? 'Сохраняем…' : 'Проверить решение'),
            ),
          ),
          if (profile?.plan == null)
            const Text('Для выполнения сначала подтверди бюджет.'),
          if (_error != null || progress != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Semantics(
                liveRegion: true,
                child: Text(_error ?? progress!.feedback),
              ),
            ),
        ],
      ),
    );
  }
}
