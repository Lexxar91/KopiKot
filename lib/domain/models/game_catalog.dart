import 'learning_task.dart';
import 'game_profile.dart';

/// Категории расходов совпадают с направлениями подтверждённого плана.
enum ExpenseCategory { needs, wants, gifts }

class ShopProduct {
  const ShopProduct({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.satiety,
    required this.mood,
    required this.description,
    this.energy = 0,
    this.accessory,
  });
  final String id;
  final String title;
  final ExpenseCategory category;
  final int price;
  final int satiety;
  final int mood;

  /// Прибавка бодрости: полезная еда бодрит, лакомство — только радует.
  final int energy;
  final String description;
  final PetAccessory? accessory;
}

/// Фиксированные условия саженца показываются до посадки.
class SaplingDefinition {
  const SaplingDefinition({
    required this.id,
    required this.title,
    required this.price,
    required this.term,
    required this.reward,
    required this.description,
  });
  final String id;
  final String title;
  final int price;
  final int term;
  final int reward;
  final String description;

  /// До зрелости ребёнок получает одинаковые 30 коткоинов в любой день.
  int earlyReward(int elapsedPeriods) => elapsedPeriods >= term ? reward : 30;
}

class GoalDefinition {
  const GoalDefinition({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
  });
  final String id;
  final String title;
  final int price;
  final String description;
}

/// Проверенный набор определений. Цены берутся из каталога, а не из команды UI.
class GameCatalog {
  // Только для уже сохранённых профилей; новые покупки берутся из списков ниже.
  static const legacyGoal = GoalDefinition(
    id: 'tree_bank',
    title: 'Дерево-копилка',
    price: 400,
    description: 'Ранее выбранная цель.',
  );
  static const legacySaplings = <String, SaplingDefinition>{
    'sapling_10': SaplingDefinition(
      id: 'sapling_10',
      title: 'Саженец на 10 дней',
      price: 20,
      term: 10,
      reward: 50,
      description: 'Ранее посаженный саженец.',
    ),
    'sapling_15': SaplingDefinition(
      id: 'sapling_15',
      title: 'Саженец на 15 дней',
      price: 20,
      term: 15,
      reward: 80,
      description: 'Ранее посаженный саженец.',
    ),
  };

  GameCatalog({
    required this.version,
    required List<ShopProduct> products,
    required List<GoalDefinition> goals,
    required List<SaplingDefinition> saplings,
    List<LearningTask> tasks = const [],
  }) : products = List.unmodifiable(products),
       goals = List.unmodifiable(goals),
       saplings = List.unmodifiable(saplings),
       tasks = List.unmodifiable(tasks);
  final int version;
  final List<ShopProduct> products;
  final List<GoalDefinition> goals;
  final List<SaplingDefinition> saplings;
  final List<LearningTask> tasks;
  LearningTask task(String id) => tasks.firstWhere((task) => task.id == id);

  ShopProduct product(String id) =>
      products.firstWhere((product) => product.id == id);
  GoalDefinition goal(String id) => id == legacyGoal.id
      ? legacyGoal
      : goals.firstWhere((goal) => goal.id == id);
  SaplingDefinition sapling(String id) =>
      legacySaplings[id] ?? saplings.firstWhere((sapling) => sapling.id == id);
}
