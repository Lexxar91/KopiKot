import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../../domain/rules/game_rules.dart';
import '../providers/game_controller.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/adult_access_button.dart';
import 'help_screen.dart';

/// Гостевой профиль без регистрации и запроса настоящего имени.
class CreatePetScreen extends ConsumerStatefulWidget {
  const CreatePetScreen({super.key});

  @override
  ConsumerState<CreatePetScreen> createState() => _CreatePetScreenState();
}

class _CreatePetScreenState extends ConsumerState<CreatePetScreen> {
  final _name = TextEditingController();
  final _form = GlobalKey<FormState>();
  PetCoat _coat = PetCoat.ginger;
  PetAccessory _accessory = PetAccessory.scarf;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(gameControllerProvider.notifier)
          .createPet(_name.text, _coat, _accessory);
    } on GameRuleException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Не удалось сохранить питомца. Попробуй ещё раз.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Питомец Финни'),
      actions: [
        AdultAccessButton(enabled: !_saving),
        IconButton(
          tooltip: 'Как играть',
          icon: const Icon(Icons.help_outline),
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => const HelpScreen())),
        ),
      ],
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Давай дружить!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Заботься о питомце: выбирай нужное, решай, что хочется, и откладывай на мечту.',
                ),
                const SizedBox(height: 12),
                Center(
                  child: PetPortrait(coat: _coat, accessory: _accessory),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _name,
                  enabled: !_saving,
                  maxLength: 20,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Игровое имя питомца',
                    hintText: 'Например, Финни',
                    helperText: 'Настоящее имя вводить не нужно',
                  ),
                  validator: (value) {
                    try {
                      GameRules.validatePetName(value ?? '');
                      return null;
                    } on GameRuleException catch (error) {
                      return error.message;
                    }
                  },
                ),
                const SizedBox(height: 12),
                const Text('Выбери окрас'),
                Wrap(
                  spacing: 8,
                  children: PetCoat.values
                      .map(
                        (coat) => ChoiceChip(
                          label: Text(coatLabels[coat]!),
                          selected: _coat == coat,
                          onSelected: _saving
                              ? null
                              : (_) => setState(() => _coat = coat),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                const Text('Добавь аксессуар'),
                Wrap(
                  spacing: 8,
                  children: PetAccessory.values
                      .map(
                        (accessory) => ChoiceChip(
                          label: Text(accessoryLabels[accessory]!),
                          selected: _accessory == accessory,
                          onSelected: _saving
                              ? null
                              : (_) => setState(() => _accessory = accessory),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(_error!, semanticsLabel: 'Ошибка. $_error'),
                  ),
                FilledButton(
                  onPressed: _saving ? null : _create,
                  child: Text(_saving ? 'Сохраняем…' : 'Начать дружбу'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'На знакомство — 100 игровых монет. Реальных денег в игре нет.',
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
