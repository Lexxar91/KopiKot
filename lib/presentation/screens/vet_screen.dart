import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_catalog.dart';
import '../../domain/models/game_profile.dart';
import '../providers/game_controller.dart';
import '../widgets/accessible_motion.dart';
import '../widgets/game_action_dialog.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';

const _brown = Color(0xFF642818);
const _cream = Color(0xFFFFF9EA);

/// Показывает плановый осмотр и его реальную стоимость из каталога.
class VetScreen extends ConsumerStatefulWidget {
  const VetScreen({super.key});

  @override
  ConsumerState<VetScreen> createState() => _VetScreenState();
}

class _VetScreenState extends ConsumerState<VetScreen> {
  bool _checkupCompleted = false;

  Future<void> _scheduleCheckup(
    GameProfile profile,
    ShopProduct checkup,
  ) async {
    final completed = await showAccessibleDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameActionDialog(
        title: 'Запланировать осмотр?',
        description:
            'Стоимость: ${checkup.price} коткоинов. '
            'После визита останется ${profile.balance - checkup.price}.\n\n'
            '${checkup.description.replaceFirst('котика', profile.petName)}',
        confirmLabel: 'Запланировать',
        action: (id) =>
            ref.read(gameControllerProvider.notifier).purchase(checkup.id, id),
      ),
    );
    if (mounted && completed == true) {
      setState(() => _checkupCompleted = true);
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
    final compact = MediaQuery.sizeOf(context).height < 700;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFF88C9F6),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/vet_clinic_background.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            SafeArea(
              child: ref
                  .watch(gameCatalogProvider)
                  .when(
                    loading: () => const Center(child: LoadingStatus()),
                    error: (_, _) => Center(
                      child: TextButton(
                        onPressed: () => ref.invalidate(gameCatalogProvider),
                        child: const Text('Повторить загрузку осмотра'),
                      ),
                    ),
                    data: (catalog) {
                      final checkup = catalog.product('vet_checkup');
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(12, 5, 12, 20),
                            children: [
                              _topBar(profile),
                              const SizedBox(height: 5),
                              _titleBar(context),
                              _hero(profile, compact),
                              _checkupPanel(profile, checkup, compact),
                              const SizedBox(height: 8),
                              _helpPanel(profile, checkup),
                              const SizedBox(height: 8),
                              FilledButton.icon(
                                onPressed:
                                    profile.plan == null ||
                                        profile.balance < checkup.price
                                    ? null
                                    : () => _scheduleCheckup(profile, checkup),
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFCF35),
                                  foregroundColor: _brown,
                                  minimumSize: const Size(0, 55),
                                ),
                                icon: const Icon(Icons.pets_rounded),
                                label: const Text(
                                  'Запланировать осмотр',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                              const SizedBox(height: 8),
                              OutlinedButton(
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _cream,
                                  foregroundColor: _brown,
                                  minimumSize: const Size(0, 50),
                                ),
                                child: const Text('Вернуться к котику'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(GameProfile profile) => Row(
    children: [
      const Expanded(child: StoryLogo(height: 48)),
      const SizedBox(width: 8),
      Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: _cream,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Image.asset('assets/images/cat_coin.png', width: 27),
            const SizedBox(width: 4),
            Text(
              '${profile.balance}',
              style: const TextStyle(
                color: _brown,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
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
        child: Container(
          height: 49,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: _cream,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Row(
            children: [
              Icon(Icons.favorite_rounded, color: Color(0xFFFF5678)),
              SizedBox(width: 8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ветеринар',
                    style: TextStyle(
                      color: _brown,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _hero(GameProfile profile, bool compact) => SizedBox(
    height: compact ? 220 : 270,
    child: Stack(
      children: [
        Positioned(
          left: 0,
          bottom: 0,
          child: PetPortrait(
            coat: profile.coat,
            accessory: profile.accessory,
            emotion: profile.emotion,
            stage: profile.growthStage,
            size: compact ? 160 : 205,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Image.asset(
            'assets/images/vet_rabbit.png',
            width: compact ? 175 : 215,
            height: compact ? 210 : 260,
            fit: BoxFit.contain,
            semanticLabel: 'Добрый кролик-ветеринар',
          ),
        ),
        Positioned(
          left: compact ? 92 : 125,
          top: 9,
          child: Container(
            constraints: BoxConstraints(maxWidth: compact ? 140 : 175),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              _checkupCompleted
                  ? 'Всё хорошо, котик полностью здоров!'
                  : 'Проверим, всё ли хорошо?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _brown,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _checkupPanel(
    GameProfile profile,
    ShopProduct checkup,
    bool compact,
  ) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: _cream,
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: Colors.white, width: 3),
    ),
    child: Column(
      children: [
        const Text(
          'Плановый осмотр',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _brown,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Совет по уходу за котиком',
          style: TextStyle(color: _brown, fontWeight: FontWeight.w900),
        ),
        const Text(
          'Наш ветеринар проверит, всё ли хорошо с котиком, и подскажет, как лучше за ним заботиться.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _brown),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _InfoTile(
                label: 'Стоимость',
                value: '${checkup.price}',
                icon: 'assets/images/cat_coin.png',
                color: const Color(0xFFFFF1C7),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoTile(
                label: 'Радость',
                value: '+${checkup.mood}',
                icon: 'assets/images/action_care.png',
                color: const Color(0xFFDBFFF0),
              ),
            ),
          ],
        ),
        if (!compact) const SizedBox(height: 8),
        if (profile.plan == null)
          const Text('Сначала сохрани бюджет, чтобы запланировать осмотр.'),
      ],
    ),
  );

  Widget _helpPanel(GameProfile profile, ShopProduct checkup) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFE7F8FF),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: Colors.white, width: 2),
    ),
    child: Row(
      children: [
        Image.asset('assets/images/budget_savings.png', width: 68),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Резерв помощи',
                style: TextStyle(
                  color: _brown,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                profile.balance < checkup.price
                    ? 'Пока не хватает ${checkup.price - profile.balance} коткоинов. Можно выполнить задание и вернуться к осмотру — котик в безопасности.'
                    : 'Небольшой запас коткоинов помогает заранее позаботиться о здоровье котика.',
                style: const TextStyle(color: _brown),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(7),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white, width: 2),
    ),
    child: Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(
              color: _brown,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 32, height: 32, fit: BoxFit.contain),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: _brown,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
