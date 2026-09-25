import 'dart:math';

import 'package:flutter/material.dart';

import '../screens/adult_screen.dart';
import 'accessible_motion.dart';

/// Простой барьер от случайного входа; не аутентификация и не проверка возраста.
class AdultAccessButton extends StatelessWidget {
  const AdultAccessButton({this.enabled = true, super.key});
  final bool enabled;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Для взрослого',
    icon: const Icon(Icons.lock_outline),
    onPressed: enabled ? () => openAdultSection(context) : null,
  );
}

/// Одинаковый барьер для входа из шапки и группы «Ещё».
Future<void> openAdultSection(BuildContext context) async {
  final unlocked = await showAccessibleDialog<bool>(
    context: context,
    builder: (_) => const _AdultGate(),
  );
  if (unlocked == true && context.mounted) {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AdultScreen()));
  }
}

class _AdultGate extends StatefulWidget {
  const _AdultGate();
  @override
  State<_AdultGate> createState() => _AdultGateState();
}

class _AdultGateState extends State<_AdultGate> {
  final _answer = TextEditingController();
  final int _first = 12 + Random.secure().nextInt(28);
  final int _second = 12 + Random.secure().nextInt(28);
  bool _incorrect = false;

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  void _check() {
    if (int.tryParse(_answer.text.trim()) == _first + _second) {
      Navigator.pop(context, true);
    } else {
      setState(() => _incorrect = true);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Вход для взрослого'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Передайте устройство взрослому. Решите пример, чтобы открыть настройки профилей.',
          ),
          const SizedBox(height: 16),
          Text('$_first + $_second = ?', key: const Key('adult-challenge')),
          const SizedBox(height: 12),
          TextField(
            key: const Key('adult-answer'),
            controller: _answer,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Ответ на пример'),
            onSubmitted: (_) => _check(),
          ),
          if (_incorrect)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Semantics(
                liveRegion: true,
                child: const Text('Проверьте ответ и попробуйте ещё раз.'),
              ),
            ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Отмена'),
      ),
      FilledButton(onPressed: _check, child: const Text('Открыть раздел')),
    ],
  );
}
