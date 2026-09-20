import 'package:flutter/material.dart';

import '../../domain/rules/game_rules.dart';
import '../providers/game_controller.dart';

/// Подтверждение и повтор безопасного сохранения с неизменным ID команды.
class GameActionDialog extends StatefulWidget {
  const GameActionDialog({
    required this.title,
    required this.description,
    required this.action,
    this.confirmLabel = 'Подтвердить',
    super.key,
  });
  final String title;
  final String description;
  final String confirmLabel;
  final Future<void> Function(String commandId) action;

  @override
  State<GameActionDialog> createState() => _GameActionDialogState();
}

class _GameActionDialogState extends State<GameActionDialog> {
  final String _commandId = newCommandId();
  bool _saving = false;
  String? _error;

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.action(_commandId);
      if (!mounted) return;
      setState(() => _saving = false);
      Navigator.of(context).pop(true);
    } on GameRuleException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Не удалось сохранить действие. Попробуй ещё раз.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.description),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Semantics(liveRegion: true, child: Text(_error!)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Сохраняем…' : widget.confirmLabel),
        ),
      ],
    ),
  );
}
