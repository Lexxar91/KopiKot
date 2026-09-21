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
    this.accessory,
  });
  final String id;
  final String title;
  final ExpenseCategory category;
  final int price;
  final int satiety;
  final int mood;
  final String description;
  final PetAccessory? accessory;
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
  GameCatalog({
    required this.version,
    required List<ShopProduct> products,
    required List<GoalDefinition> goals,
    List<LearningTask> tasks = const [],
  }) : products = List.unmodifiable(products),
       goals = List.unmodifiable(goals),
       tasks = List.unmodifiable(tasks);
  final int version;
  final List<ShopProduct> products;
  final List<GoalDefinition> goals;
  final List<LearningTask> tasks;
  LearningTask task(String id) => tasks.firstWhere((task) => task.id == id);

  ShopProduct product(String id) =>
      products.firstWhere((product) => product.id == id);
  GoalDefinition goal(String id) => goals.firstWhere((goal) => goal.id == id);
}
