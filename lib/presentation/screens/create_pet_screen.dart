import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../../domain/rules/game_rules.dart';
import '../providers/game_controller.dart';
import '../widgets/adult_access_button.dart';
import '../widgets/pet_portrait.dart';
import 'help_screen.dart';

const _ink = Color(0xFF642818);
const _cream = Color(0xFFFFF9E9);

/// Три шага знакомства создают гостевой профиль без настоящего имени ребёнка.
class CreatePetScreen extends ConsumerStatefulWidget {
  const CreatePetScreen({super.key});

  @override
  ConsumerState<CreatePetScreen> createState() => _CreatePetScreenState();
}

class _CreatePetScreenState extends ConsumerState<CreatePetScreen> {
  final _name = TextEditingController();
  final _form = GlobalKey<FormState>();
  PetCoat _coat = PetCoat.ginger;
  int _step = 0;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _moveTo(int step) {
    FocusScope.of(context).unfocus();
    setState(() {
      _step = step;
      _error = null;
    });
  }

  Future<void> _create() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(gameControllerProvider.notifier)
          .createPet(_name.text, _coat, PetAccessory.scarf);
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
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark,
    child: Scaffold(
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
                  key: ValueKey(_step),
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                  children: [
                    _header(),
                    const SizedBox(height: 8),
                    if (_step == 0) _intro(),
                    if (_step == 1) _chooseCoat(),
                    if (_step == 2) _chooseName(),
                    const SizedBox(height: 12),
                    _navigation(),
                    const SizedBox(height: 5),
                    Align(
                      child: TextButton.icon(
                        onPressed: _saving
                            ? null
                            : () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const HelpScreen(),
                                ),
                              ),
                        icon: const Icon(Icons.help_outline, size: 18),
                        label: const Text('Как играть'),
                        style: TextButton.styleFrom(
                          foregroundColor: _ink,
                          backgroundColor: _cream.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _header() => Row(
    children: [
      Expanded(
        flex: 3,
        child: Container(
          height: 49,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFA95820), Color(0xFF67300F)],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFFFD777), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x883A210F),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Text(
                'КопиКот',
                style: TextStyle(
                  color: Color(0xFFFFD84D),
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(color: _ink, offset: Offset(1, 2), blurRadius: 2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 6),
      Expanded(
        flex: 2,
        child: Semantics(
          label: 'Шаг ${_step + 1} из 3',
          child: Container(
            height: 49,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFB51F), Color(0xFFF1740C)],
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${_step + 1} из 3',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                for (var i = 1; i < 3; i++) ...[
                  const SizedBox(width: 3),
                  Expanded(
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: i <= _step
                          ? const Color(0xFFFF9115)
                          : const Color(0xFFE9D9CA),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      SizedBox(width: 48, child: AdultAccessButton(enabled: !_saving)),
    ],
  );

  Widget _hero({double size = 182, bool greeting = false}) => SizedBox(
    height: size,
    child: Stack(
      alignment: Alignment.center,
      children: [
        PetPortrait(coat: _coat, accessory: PetAccessory.scarf, size: size),
        if (greeting)
          Positioned(
            right: 0,
            top: size * 0.25,
            child: Container(
              constraints: BoxConstraints(maxWidth: size * 0.4),
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: _cream,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                _name.text.trim().isEmpty
                    ? 'Привет, давай придумаем мне имя?'
                    : 'Привет!\nЯ ${_name.text.trim()}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    ),
  );

  Widget _panel({
    required String title,
    required String subtitle,
    bool large = false,
  }) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: large ? 13 : 8),
    decoration: BoxDecoration(
      color: _cream,
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: Colors.white, width: 3),
      boxShadow: const [
        BoxShadow(
          color: Color(0x8A76552D),
          blurRadius: 4,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _ink,
            fontSize: large ? 25 : 22,
            height: 1.05,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _ink,
            fontSize: 14,
            height: 1.1,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  Widget _intro() => Column(
    children: [
      _hero(size: 185),
      _panel(
        title: 'Привет! Это КопиКот',
        subtitle:
            'Заботься о котике и учись выбирать, куда потратить коткоины.',
        large: true,
      ),
      const SizedBox(height: 9),
      _lessonRow(
        'Сначала нужное',
        'Еда и уход',
        'assets/images/action_feed.png',
        const Color(0xFFFFE0E0),
        const Color(0xFFC92335),
      ),
      _lessonRow(
        'Потом радость',
        'Игры и игрушки',
        'assets/images/action_play.png',
        const Color(0xFFDDF2FF),
        const Color(0xFF19549A),
      ),
      _lessonRow(
        'И немного в копилку',
        'На большую цель',
        null,
        const Color(0xFFDFFBD9),
        const Color(0xFF087536),
      ),
    ],
  );

  Widget _lessonRow(
    String title,
    String subtitle,
    String? image,
    Color color,
    Color titleColor,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 8),
    constraints: const BoxConstraints(minHeight: 66),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white, width: 3),
    ),
    child: Row(
      children: [
        SizedBox.square(
          dimension: 55,
          child: image == null
              ? const Icon(
                  Icons.savings_rounded,
                  size: 42,
                  color: Color(0xFF278C3D),
                )
              : Image.asset(image, fit: BoxFit.contain),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 18,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 14,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right_rounded, color: titleColor, size: 26),
      ],
    ),
  );

  Widget _chooseCoat() {
    final compact = MediaQuery.sizeOf(context).height < 700;
    const coats = [
      PetCoat.ginger,
      PetCoat.cream,
      PetCoat.grey,
      PetCoat.dark,
      PetCoat.white,
    ];
    return Column(
      children: [
        _hero(size: compact ? 150 : 163),
        _panel(
          title: 'Выбери котика',
          subtitle: 'Нажми на окрас, который нравится.',
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: _cream,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Text(
            'Варианты окраса',
            style: TextStyle(
              color: _ink,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 5),
        for (var row = 0; row < 2; row++) ...[
          Row(
            children: [
              Expanded(child: _coatCard(coats[row * 2], compact: compact)),
              const SizedBox(width: 7),
              Expanded(child: _coatCard(coats[row * 2 + 1], compact: compact)),
            ],
          ),
          const SizedBox(height: 7),
        ],
        FractionallySizedBox(
          widthFactor: 0.5,
          child: _coatCard(coats.last, compact: compact),
        ),
      ],
    );
  }

  Widget _coatCard(PetCoat coat, {required bool compact}) {
    final selected = _coat == coat;
    final color = switch (coat) {
      PetCoat.ginger => const Color(0xFFFFF3C4),
      PetCoat.cream => const Color(0xFFFFE9D6),
      PetCoat.grey => const Color(0xFFE0E9FF),
      PetCoat.dark => const Color(0xFFF0DEFF),
      PetCoat.white => const Color(0xFFDFF7FF),
    };
    return Semantics(
      button: true,
      selected: selected,
      label: 'Выбрать окрас ${coatLabels[coat]}',
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: selected ? const Color(0xFF2198E5) : Colors.white,
            width: selected ? 3 : 2,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _saving ? null : () => setState(() => _coat = coat),
          child: SizedBox(
            height: compact ? 70 : 91,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  child: PetPortrait(
                    coat: coat,
                    accessory: PetAccessory.scarf,
                    size: compact ? 48 : 66,
                  ),
                ),
                Positioned(
                  bottom: 3,
                  child: Text(
                    coatLabels[coat]!,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (selected)
                  const Positioned(
                    top: 3,
                    right: 3,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Color(0xFF3DAD2E),
                      child: Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chooseName() => Column(
    children: [
      const SizedBox(height: 15),
      _hero(size: 225, greeting: true),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 11),
        decoration: BoxDecoration(
          color: _cream,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text(
                    'Как назвать котика?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _ink,
                      fontSize: 26,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Имя увидишь только ты.',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Имя котика',
              style: TextStyle(
                color: _ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Form(
              key: _form,
              child: TextFormField(
                controller: _name,
                enabled: !_saving,
                maxLength: 20,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF2466B0),
                  ),
                  fillColor: Colors.white,
                  counterText: '',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xFF38B7EF),
                      width: 2,
                    ),
                  ),
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
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'Можно выбрать любое имя',
                style: TextStyle(color: _ink, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      if (_error != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Semantics(
            liveRegion: true,
            child: Text(
              _error!,
              style: const TextStyle(color: _ink),
              semanticsLabel: 'Ошибка. $_error',
            ),
          ),
        ),
    ],
  );

  Widget _navigation() => Row(
    children: [
      if (_step > 0) ...[
        OutlinedButton.icon(
          onPressed: _saving ? null : () => _moveTo(_step - 1),
          icon: const Icon(Icons.chevron_left_rounded),
          label: const Text('Назад'),
          style: OutlinedButton.styleFrom(
            foregroundColor: _ink,
            backgroundColor: _cream,
            side: const BorderSide(color: Colors.white, width: 2),
            minimumSize: const Size(0, 56),
          ),
        ),
        const SizedBox(width: 8),
      ],
      Expanded(
        child: FilledButton(
          onPressed: _saving
              ? null
              : _step == 2
              ? _create
              : () => _moveTo(_step + 1),
          style: FilledButton.styleFrom(
            foregroundColor: _ink,
            backgroundColor: const Color(0xFFFFC92C),
            side: const BorderSide(color: Color(0xFFFA8711), width: 2),
            minimumSize: const Size(0, 56),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.pets_rounded, size: 19),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _saving
                        ? 'Сохраняем…'
                        : _step == 2
                        ? 'Начать игру'
                        : 'Дальше',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const Icon(Icons.pets_rounded, size: 19),
            ],
          ),
        ),
      ),
    ],
  );
}
