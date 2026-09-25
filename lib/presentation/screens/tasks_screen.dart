import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_catalog.dart';
import '../../domain/models/game_profile.dart';
import '../../domain/models/learning_task.dart';
import '../../domain/rules/game_rules.dart';
import '../../domain/rules/learning_rules.dart';
import '../providers/game_controller.dart';
import '../widgets/accessible_motion.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';

const _questBrown = Color(0xFF642818);
const _questCream = Color(0xFFFFF9EA);

class _QuestTopic {
  const _QuestTopic(
    this.id,
    this.label,
    this.shortLabel,
    this.hint,
    this.image,
    this.badgeImage,
  );

  final String id;
  final String label;
  final String shortLabel;
  final String hint;
  final String image;
  final String badgeImage;
}

const _questTopics = [
  _QuestTopic(
    'Планирование',
    'Планирование бюджета',
    'План',
    'Распределяй коткоины с умом',
    'assets/images/quest_budget.png',
    'assets/images/quest_badge_plan.png',
  ),
  _QuestTopic(
    'Покупки',
    'Платежи и покупки',
    'Покупки',
    'Сначала нужное, потом радость',
    'assets/images/quest_purchases.png',
    'assets/images/quest_badge_purchases.png',
  ),
  _QuestTopic(
    'Сбережения',
    'Формирование сбережений',
    'Копилка',
    'Копи понемногу и регулярно',
    'assets/images/quest_savings.png',
    'assets/images/quest_badge_savings.png',
  ),
];

/// Список заданий оформлен по макету; темы и значки следуют QUESTS_TEXT.md.
class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  String? _selectedTopic;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text('Сначала создай питомца.')),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFF8BCBF5),
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
                child: ref
                    .watch(gameCatalogProvider)
                    .when(
                      loading: () => const Center(child: LoadingStatus()),
                      error: (_, _) => const Center(
                        child: Text(
                          'Не удалось открыть задания. Вернись и попробуй ещё раз.',
                        ),
                      ),
                      data: (catalog) => _content(profile, catalog),
                    ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  Widget _content(GameProfile profile, GameCatalog catalog) {
    final compact =
        MediaQuery.sizeOf(context).height < 700 &&
        MediaQuery.textScalerOf(context).scale(1) < 1.25;
    final tasks = catalog.tasks
        .where((task) => _selectedTopic == null || task.topic == _selectedTopic)
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 18),
      children: [
        _topBar(profile),
        const SizedBox(height: 5),
        _titleBar(),
        _hero(profile, compact),
        _badges(profile, catalog, compact),
        const SizedBox(height: 8),
        _panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Выбери задание',
                      style: TextStyle(
                        color: _questBrown,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  _topicMenu(),
                ],
              ),
              if (profile.plan == null)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Сначала подтверди бюджет этого периода.',
                    style: TextStyle(color: _questBrown),
                  ),
                ),
              const SizedBox(height: 6),
              for (final task in tasks) _taskCard(profile, catalog, task),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topBar(GameProfile profile) => Row(
    children: [
      const Expanded(child: StoryLogo(height: 48)),
      const SizedBox(width: 8),
      Container(
        height: 47,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: _questCream,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Image.asset('assets/images/cat_coin.png', width: 28),
            const SizedBox(width: 5),
            Text(
              '${profile.balance}',
              style: const TextStyle(
                color: _questBrown,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _titleBar() => Row(
    children: [
      Material(
        color: const Color(0xFF983BE1),
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
          height: 50,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: _questCream,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Row(
            children: [
              Icon(Icons.menu_book_rounded, color: Color(0xFF9B35DF)),
              SizedBox(width: 8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Задания',
                    maxLines: 1,
                    style: TextStyle(
                      color: _questBrown,
                      fontSize: 25,
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
    height: compact ? 100 : 129,
    child: Stack(
      children: [
        Positioned(
          left: 0,
          bottom: -4,
          child:
              profile.coat == PetCoat.ginger &&
                  profile.accessory == PetAccessory.scarf
              ? Image.asset(
                  'assets/images/quest_hero_ginger.png',
                  width: compact ? 155 : 185,
                  height: compact ? 100 : 125,
                  fit: BoxFit.contain,
                  semanticLabel: 'Рыжий котик приглашает выбрать задание',
                )
              : PetPortrait(
                  coat: profile.coat,
                  accessory: profile.accessory,
                  size: compact ? 105 : 143,
                ),
        ),
        Positioned(
          right: 0,
          top: 10,
          child: Container(
            width: compact ? 185 : 193,
            padding: EdgeInsets.all(compact ? 6 : 10),
            decoration: BoxDecoration(
              color: _questCream,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              'Мур! Потренируем финансовый ум? Выполняй задания и получай коткоины и значки.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _questBrown,
                fontSize: compact ? 12 : 14,
                fontWeight: FontWeight.w800,
                height: 1.12,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _panel({required Widget child}) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: _questCream,
      borderRadius: BorderRadius.circular(23),
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: const [
        BoxShadow(
          color: Color(0x445C350E),
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: child,
  );

  Widget _badges(GameProfile profile, GameCatalog catalog, bool compact) =>
      _panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/quest_badge_plan.png',
                  width: 29,
                  height: 29,
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    'Значки за темы',
                    style: TextStyle(
                      color: _questBrown,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              'Выполни все задания темы — и получи значок.',
              style: TextStyle(color: _questBrown, fontSize: 11),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                for (final topic in _questTopics)
                  Expanded(child: _badge(topic, profile, catalog, compact)),
              ],
            ),
          ],
        ),
      );

  Widget _badge(
    _QuestTopic topic,
    GameProfile profile,
    GameCatalog catalog,
    bool compact,
  ) {
    final entries = catalog.tasks
        .where((task) => task.topic == topic.id)
        .toList();
    final earned =
        entries.isNotEmpty &&
        entries.every((task) => profile.completedTask(task.id));
    final scaledText = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final badgeImage = Image.asset(topic.badgeImage, fit: BoxFit.contain);
    return Semantics(
      label: '${topic.label}. ${earned ? 'Получен!' : topic.hint}',
      child: Container(
        height: scaledText ? 165 : (compact ? 90 : 120),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: earned ? const Color(0xFFE6FFE8) : Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: earned ? const Color(0xFF24C77A) : const Color(0xFFE8D8C2),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: scaledText ? 52 : (compact ? 39 : 61),
              child: earned
                  ? badgeImage
                  : ColorFiltered(
                      colorFilter: const ColorFilter.matrix([
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                      ]),
                      child: badgeImage,
                    ),
            ),
            FittedBox(
              child: Text(
                topic.shortLabel,
                style: const TextStyle(
                  color: _questBrown,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: earned
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0BB568),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                            SizedBox(width: 2),
                            Text(
                              'Получен!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        topic.hint,
                        maxLines: scaledText ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF667080),
                          fontSize: 9,
                          height: 1.1,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topicMenu() => PopupMenuButton<String>(
    tooltip: 'Фильтр по темам',
    icon: const Icon(Icons.filter_list_rounded, color: _questBrown),
    initialValue: _selectedTopic ?? 'all',
    onSelected: (topic) =>
        setState(() => _selectedTopic = topic == 'all' ? null : topic),
    itemBuilder: (_) => [
      const PopupMenuItem(value: 'all', child: Text('Все темы')),
      for (final topic in _questTopics)
        PopupMenuItem(value: topic.id, child: Text(topic.label)),
    ],
  );

  Widget _taskCard(
    GameProfile profile,
    GameCatalog catalog,
    LearningTask task,
  ) {
    final topic = _questTopics.firstWhere((item) => item.id == task.topic);
    final completed = profile.completedTask(task.id);
    final tint = switch (topic.id) {
      'Планирование' => const Color(0xFFE0FFF1),
      'Покупки' => const Color(0xFFFFE5E5),
      _ => const Color(0xFFE1F2FF),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Material(
        color: tint,
        borderRadius: BorderRadius.circular(19),
        child: InkWell(
          borderRadius: BorderRadius.circular(19),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => TaskScreen(task: task, catalog: catalog),
            ),
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: 91),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Row(
              children: [
                Image.asset(
                  topic.image,
                  width: 69,
                  height: 76,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        task.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _questBrown,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        task.prompt,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF5C6472),
                          fontSize: 11,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        topic.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _questBrown,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Награда до ${task.reward}',
                        style: const TextStyle(
                          color: _questBrown,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (completed)
                        const Text(
                          'Выполнено',
                          style: TextStyle(
                            color: Color(0xFF038C55),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/cat_coin.png', width: 20),
                        Text(
                          '+${task.reward}',
                          style: const TextStyle(
                            color: _questBrown,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Icon(
                      completed
                          ? Icons.check_circle_rounded
                          : Icons.chevron_right_rounded,
                      color: completed
                          ? const Color(0xFF0BAF64)
                          : const Color(0xFFF07747),
                    ),
                    Text(
                      completed ? 'Повторить' : 'Играть',
                      style: const TextStyle(
                        color: _questBrown,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomNavigation() {
    return SafeArea(
      top: false,
      child: ColoredBox(
        color: _questCream,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _navItem(
                Icons.home_rounded,
                'Главная',
                false,
                () => Navigator.of(context).maybePop(),
              ),
              _navItem(Icons.menu_book_rounded, 'Задания', true, () {}),
              _navItem(
                Icons.pets_rounded,
                'Котик',
                false,
                () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    bool selected,
    VoidCallback onTap,
  ) => Expanded(
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? const Color(0xFF9B35DF) : _questBrown),
            Text(
              label,
              style: TextStyle(
                color: selected ? const Color(0xFF9B35DF) : _questBrown,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    ),
  );
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
  String? _dayBudgetWarning;
  QuestFeedback? _questPreview;
  String? _choice;
  String? _fixedText;
  bool _practiceViewed = false;

  bool get _isWeeklyBudget => widget.task.id == 'budget_lunch';
  bool get _isDayPlan => widget.task.id == 'budget_reserve';
  bool get _isFirstPurchase => widget.task.id == 'basket_food';
  bool get _isFullPrice => widget.task.id == 'basket_care';
  bool get _isRewardSaving => widget.task.id == 'saving_start';
  bool get _isDailySavings => widget.task.id == 'saving_finish';
  bool get _isChoiceQuest =>
      _isFirstPurchase || _isFullPrice || _isDailySavings;
  bool get _isCustomQuest =>
      _isWeeklyBudget || _isDayPlan || _isChoiceQuest || _isRewardSaving;

  QuestFeedback _evaluateQuest(TaskAnswer answer) => switch (widget.task.id) {
    'budget_lunch' => LearningRules.evaluateWeeklyBudget(answer),
    'budget_reserve' => LearningRules.evaluateDayPlan(answer),
    'basket_food' => LearningRules.evaluateFirstPurchase(answer),
    'basket_care' => LearningRules.evaluateFullPrice(answer),
    'saving_start' => LearningRules.evaluateRewardSaving(answer),
    'saving_finish' => LearningRules.evaluateDailySavings(answer),
    _ => throw StateError('Unsupported quest: ${widget.task.id}'),
  };

  TaskAnswer get _answer => TaskAnswer(
    needs: int.tryParse(_needs.text) ?? 0,
    wants: int.tryParse(_wants.text) ?? 0,
    savings: int.tryParse(_savings.text) ?? 0,
    products: _basket.toList(),
    choice: _choice,
  );

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
      onChanged: (_) => setState(() {
        _questPreview = null;
        _fixedText = null;
      }),
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
      final answer = _answer;
      final currentProfile = ref.read(gameControllerProvider).asData?.value;
      if (currentProfile?.completedTask(widget.task.id) == true) {
        setState(() {
          _questPreview = _evaluateQuest(answer);
          _practiceViewed = true;
        });
        return;
      }
      if (_isCustomQuest && _questPreview?.canClaim == false) return;
      if (_isCustomQuest && _questPreview?.canClaim != true) {
        final preview = _evaluateQuest(answer);
        if (mounted) setState(() => _questPreview = preview);
        if (preview.canClaim ||
            (_isWeeklyBudget &&
                answer.needs + answer.wants + answer.savings != 60) ||
            (_isDayPlan &&
                (preview.title == 'План больше бюджета' ||
                    preview.title == 'Проверь план дня')) ||
            (_isChoiceQuest && answer.choice == null) ||
            (_isRewardSaving && (answer.savings < 0 || answer.savings > 30))) {
          return;
        }
      }
      await ref
          .read(gameControllerProvider.notifier)
          .submitTask(widget.task.id, answer);
    } on GameRuleException catch (error) {
      if (mounted) {
        setState(() {
          _error = error.message;
          _questPreview = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Не удалось сохранить попытку. Твой ответ остался здесь.';
          _questPreview = null;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _choose(String id) => setState(() {
    _choice = id;
    _questPreview = null;
    _fixedText = null;
  });

  void _correctChoice() {
    final fixedText = _questPreview?.fixedText;
    if (fixedText == null) return;
    setState(() {
      _choice = switch (widget.task.id) {
        'basket_food' => 'food',
        'basket_care' => 'no',
        'saving_finish' => 'fluffy',
        _ => _choice,
      };
      _fixedText = fixedText;
      _questPreview = null;
    });
  }

  Widget _questChoiceTile(
    String id,
    String title,
    String subtitle,
    bool enabled,
  ) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Material(
      color: _choice == id ? const Color(0xFFE4FFEC) : const Color(0xFFFFF9EA),
      borderRadius: BorderRadius.circular(18),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        selected: _choice == id,
        leading: Icon(
          _choice == id
              ? Icons.radio_button_checked_rounded
              : Icons.radio_button_unchecked_rounded,
          color: const Color(0xFF713019),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: enabled ? () => _choose(id) : null,
      ),
    ),
  );

  Widget _purchaseItemCard(
    String imagePath,
    String label,
    int price,
    Color tint,
  ) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          Image.asset(imagePath, height: 88, fit: BoxFit.contain),
          Text(
            label,
            style: const TextStyle(
              color: _questBrown,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/cat_coin.png', width: 24),
              const SizedBox(width: 4),
              Text(
                '$price',
                style: const TextStyle(
                  color: _questBrown,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _purchaseChoiceCard(
    String id,
    String title,
    String detail,
    String imagePath,
    int remainder,
    Color tint,
    bool enabled,
  ) {
    final selected = _choice == id;
    return Expanded(
      child: Material(
        color: tint,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: !enabled
              ? null
              : () => setState(() {
                  _choice = id;
                  _questPreview = null;
                  _fixedText = null;
                }),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: selected ? const Color(0xFF16A967) : Colors.white,
                width: 3,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      selected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: selected ? const Color(0xFF16A967) : _questBrown,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: _questBrown,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                Image.asset(imagePath, height: 70, fit: BoxFit.contain),
                Text(
                  detail,
                  style: const TextStyle(color: _questBrown, fontSize: 12),
                ),
                Text(
                  'Останется: $remainder',
                  style: const TextStyle(
                    color: _questBrown,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _firstPurchaseScreen(
    GameProfile? profile,
    TaskProgress? progress,
    bool enabled,
    int questReward,
    String? feedback,
  ) => Scaffold(
    body: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/quest_market_background.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
            children: [
              Row(
                children: [
                  const Expanded(child: StoryLogo(height: 48)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _questCream,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/images/cat_coin.png', width: 29),
                        const SizedBox(width: 4),
                        Text(
                          '${profile?.balance ?? 0}',
                          style: const TextStyle(
                            color: _questBrown,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton.filled(
                    tooltip: 'Назад',
                    onPressed: () => Navigator.of(context).maybePop(),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF922CE0),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 54,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: _questCream,
                        borderRadius: BorderRadius.circular(27),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.menu_book_rounded,
                            color: Color(0xFF922CE0),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.task.title,
                                style: const TextStyle(
                                  color: _questBrown,
                                  fontSize: 23,
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
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  PetPortrait(
                    coat: profile?.coat ?? PetCoat.ginger,
                    accessory: profile?.accessory,
                    size: 170,
                    emotion: PetEmotion.thoughtful,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _questCream,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        'Как поступим?',
                        style: TextStyle(
                          color: _questBrown,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _questCream,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'На покупки: 30',
                      style: TextStyle(
                        color: _questBrown,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(widget.task.prompt),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _purchaseItemCard(
                          'assets/images/quest_cat_food.png',
                          'Корм',
                          20,
                          const Color(0xFFE1FFE6),
                        ),
                        const SizedBox(width: 8),
                        _purchaseItemCard(
                          'assets/images/quest_toy_mouse.png',
                          'Золотая мышка',
                          25,
                          const Color(0xFFFFE3E4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _questCream,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Сравни варианты',
                      style: TextStyle(
                        color: _questBrown,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _purchaseChoiceCard(
                          'food',
                          'Сначала корм',
                          '20 коткоинов — котик будет сыт',
                          'assets/images/quest_cat_food.png',
                          10,
                          const Color(0xFFE2FFED),
                          enabled,
                        ),
                        const SizedBox(width: 8),
                        _purchaseChoiceCard(
                          'mouse',
                          'Сначала мышку',
                          '25 коткоинов — очень хочется!',
                          'assets/images/quest_toy_mouse.png',
                          5,
                          const Color(0xFFFFE5E5),
                          enabled,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed:
                    enabled &&
                        (profile?.plan != null || progress?.completed == true)
                    ? _submit
                    : null,
                child: Text(
                  progress?.completed == true
                      ? 'Проверить план'
                      : _questPreview?.canClaim == true
                      ? 'Забрать награду · $questReward'
                      : 'Проверить план',
                ),
              ),
              if (profile?.plan == null && progress?.completed != true)
                const Text('Для выполнения сначала подтверди бюджет.'),
              if (feedback != null || _fixedText != null)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _questCream,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      feedback ?? 'Всё исправлено!\n$_fixedText',
                      style: const TextStyle(color: _questBrown, fontSize: 16),
                    ),
                  ),
                ),
              if (enabled && _questPreview?.fixButton != null)
                OutlinedButton(
                  onPressed: () => setState(() {
                    _choice = 'food';
                    _fixedText = _questPreview!.fixedText;
                    _questPreview = null;
                  }),
                  child: Text(_questPreview!.fixButton!),
                ),
              const SizedBox(height: 8),
              const Text(
                'Выбор можно изменить',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _questBrown,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    final progress = profile?.taskProgress
        .where((entry) => entry.taskId == widget.task.id)
        .firstOrNull;
    final enabled = !_busy;
    final answer = _answer;
    final distributed = answer.needs + answer.wants + answer.savings;
    final questReward =
        _questPreview?.perfect == false || (progress?.attempts ?? 0) > 0
        ? 8
        : 12;
    final feedback =
        _error ??
        (_isCustomQuest
            ? (progress?.completed == true
                  ? (_practiceViewed
                        ? _questPreview?.message
                        : progress!.feedback)
                  : _questPreview?.message)
            : progress?.feedback);
    final displayedFeedback =
        feedback ??
        (_fixedText == null ? null : 'Всё исправлено!\n$_fixedText');
    if (_isFirstPurchase) {
      return _firstPurchaseScreen(
        profile,
        progress,
        enabled,
        questReward,
        feedback,
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6DD),
      appBar: AppBar(title: Text(widget.task.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            _questTopics
                    .where((topic) => topic.id == widget.task.topic)
                    .firstOrNull
                    ?.label ??
                widget.task.topic,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Text(widget.task.prompt),
          const SizedBox(height: 8),
          if (_isWeeklyBudget) ...[
            const SizedBox(height: 8),
            const Text('Сколько коткоинов положить в каждую корзинку?'),
            _number('Нужное', _needs, enabled),
            const Text('Еда и уход — не меньше 30'),
            _number('Радость', _wants, enabled),
            const Text('Игрушки и вкусняшки'),
            _number('Копилка', _savings, enabled),
            const Text('На мечту — хотя бы 5'),
            const SizedBox(height: 12),
            Text('Распределено $distributed / 60'),
            Text('Осталось распределить: ${(60 - distributed).clamp(0, 60)}'),
            if (distributed > 60)
              const Text('Это больше бюджета: осталось только 0 коткоинов.'),
          ] else if (_isDayPlan) ...[
            const Text('Что включим в план дня?'),
            for (final id in LearningRules.dayPlanPrices.keys)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(switch (id) {
                  'feed' => 'Покормить Барсика',
                  'vet' => 'Осмотр у ветеринара',
                  'bow' => 'Купить бантик',
                  _ => 'Поиграть с мышкой',
                }),
                subtitle: Text(
                  '${id == 'feed' || id == 'vet' ? 'нужное' : 'радость'} · ${LearningRules.dayPlanPrices[id]} коткоинов',
                ),
                value: _basket.contains(id),
                onChanged: !enabled
                    ? null
                    : (selected) => setState(() {
                        _questPreview = null;
                        if (selected == true) {
                          final spent = _basket.fold<int>(
                            0,
                            (sum, product) =>
                                sum + LearningRules.dayPlanPrices[product]!,
                          );
                          if (spent + LearningRules.dayPlanPrices[id]! > 45) {
                            _dayBudgetWarning =
                                'Это больше бюджета: осталось только ${45 - spent} коткоинов.';
                          } else {
                            _basket.add(id);
                            _dayBudgetWarning = null;
                          }
                        } else {
                          _basket.remove(id);
                          _dayBudgetWarning = null;
                        }
                      }),
              ),
            Text(
              'Сумма плана ${_basket.fold<int>(0, (sum, id) => sum + LearningRules.dayPlanPrices[id]!)} / 45',
            ),
            Text(
              'Останется: ${45 - _basket.fold<int>(0, (sum, id) => sum + LearningRules.dayPlanPrices[id]!)} коткоинов',
            ),
            if (_dayBudgetWarning != null) Text(_dayBudgetWarning!),
          ] else if (_isFullPrice) ...[
            const Text('Хватит ли 40 коткоинов на всё сразу?'),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.restaurant_rounded),
              title: Text('Корм'),
              subtitle: Text('нужное · 15 коткоинов'),
            ),
            const ListTile(
              leading: Icon(Icons.medical_services_rounded),
              title: Text('Лекарство'),
              subtitle: Text('нужное · 20 коткоинов'),
            ),
            const ListTile(
              leading: Icon(Icons.set_meal_rounded),
              title: Text('Вкусная рыбка'),
              subtitle: Text('радость · 25 коткоинов'),
            ),
            const Text('Полная цена 60'),
            _questChoiceTile(
              'yes',
              'Да, хватит на всё',
              'Полная цена — 60 коткоинов',
              enabled,
            ),
            _questChoiceTile(
              'no',
              'Нет, не хватит',
              'Полная цена 60, а в кошельке 40',
              enabled,
            ),
          ] else if (_isRewardSaving) ...[
            const Text('Сколько коткоинов отложим в копилку?'),
            _number('В копилку', _savings, enabled),
            const Text('На беговую дорожку — отлично от 10'),
            const SizedBox(height: 12),
            Text('Распределено ${answer.savings} / 30'),
            Text(
              'Осталось распределить: ${(30 - answer.savings).clamp(0, 30)}',
            ),
            Text(
              'Остальное — ${(30 - answer.savings).clamp(0, 30)} коткоинов — пойдёт на игрушку',
            ),
            if (answer.savings > 30)
              const Text('Это больше бюджета: осталось только 0 коткоинов.'),
          ] else if (_isDailySavings) ...[
            const Text('Кто накопит быстрее?'),
            _questChoiceTile(
              'fluffy',
              'Пушок — понемногу каждый день',
              '5 коткоинов × 18 дней = 90',
              enabled,
            ),
            _questChoiceTile(
              'coal',
              'Уголёк — ждать большую награду',
              'Большая награда когда-нибудь будет',
              enabled,
            ),
            _questChoiceTile(
              'same',
              'Оба одинаково',
              'Копить — так копить',
              enabled,
            ),
          ] else if (widget.task.kind == TaskKind.budget) ...[
            const Text(
              'Учебная ситуация: твои покупки и накопления в игре не тратятся.',
            ),
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
            onPressed:
                enabled &&
                    (profile?.plan != null || progress?.completed == true)
                ? _submit
                : null,
            child: Text(
              progress?.completed == true
                  ? 'Проверить план'
                  : (_busy
                        ? 'Сохраняем…'
                        : _isCustomQuest
                        ? (_questPreview?.canClaim == true
                              ? 'Забрать награду · $questReward'
                              : 'Проверить план')
                        : 'Проверить решение'),
            ),
          ),
          if (profile?.plan == null && progress?.completed != true)
            const Text('Для выполнения сначала подтверди бюджет.'),
          if (displayedFeedback != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Semantics(
                liveRegion: true,
                child: Text(displayedFeedback),
              ),
            ),
          if (enabled && _questPreview?.fixButton != null)
            OutlinedButton(
              onPressed: _correctChoice,
              child: Text(_questPreview!.fixButton!),
            ),
        ],
      ),
    );
  }
}
