import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/models/game_catalog.dart';
import '../../domain/models/game_profile.dart';
import '../../domain/models/learning_task.dart';

Future<GameCatalog> loadGameCatalog() async => parseGameCatalog(
  await rootBundle.loadString('assets/content/catalog.json'),
  taskSource: await rootBundle.loadString('assets/content/tasks.json'),
);

/// Некорректный контент блокирует запуск, но никогда не очищает сохранения.
GameCatalog parseGameCatalog(String source, {String taskSource = '[]'}) {
  final data = jsonDecode(source) as Map<String, dynamic>;
  if (data['version'] != 1) {
    throw const FormatException('Unsupported catalog version');
  }
  final ids = <String>{};
  String text(Map<String, dynamic> item, String key) {
    final value = item[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Invalid $key');
    }
    return value;
  }

  String id(Map<String, dynamic> item) {
    final value = text(item, 'id');
    if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(value) || !ids.add(value)) {
      throw FormatException('Invalid or duplicate catalog ID: $value');
    }
    return value;
  }

  int number(Map<String, dynamic> item, String key, int min, int max) {
    final value = item[key];
    if (value is! int || value < min || value > max) {
      throw FormatException('Invalid $key');
    }
    return value;
  }

  final products = (data['products'] as List<dynamic>).map((dynamic raw) {
    final item = raw as Map<String, dynamic>;
    return ShopProduct(
      id: id(item),
      title: text(item, 'title'),
      category: ExpenseCategory.values.byName(text(item, 'category')),
      price: number(item, 'price', 1, 10000),
      satiety: number(item, 'satiety', 0, 100),
      mood: number(item, 'mood', 0, 100),
      description: text(item, 'description'),
      accessory: switch (item['accessory']) {
        final String value => PetAccessory.values.byName(value),
        null => null,
        _ => throw const FormatException('Invalid accessory'),
      },
    );
  }).toList();
  final goals = (data['goals'] as List<dynamic>).map((dynamic raw) {
    final item = raw as Map<String, dynamic>;
    return GoalDefinition(
      id: id(item),
      title: text(item, 'title'),
      price: number(item, 'price', 1, 10000),
      description: text(item, 'description'),
    );
  }).toList();
  if (products.isEmpty || goals.isEmpty) {
    throw const FormatException('Empty catalog');
  }
  final tasks = (jsonDecode(taskSource) as List<dynamic>).map((dynamic raw) {
    final item = raw as Map<String, dynamic>;
    final kind = TaskKind.values.byName(text(item, 'kind'));
    final allowed = List<String>.from(item['products'] as List<dynamic>? ?? []);
    final required = List<String>.from(
      item['requiredProducts'] as List<dynamic>? ?? [],
    );
    final task = LearningTask(
      id: id(item),
      title: text(item, 'title'),
      topic: text(item, 'topic'),
      kind: kind,
      prompt: text(item, 'prompt'),
      budget: number(item, 'budget', 1, 10000),
      minimumNeeds: number(item, 'minimumNeeds', 0, 10000),
      minimumSavings: number(item, 'minimumSavings', 0, 10000),
      goalRemaining: number(item, 'goalRemaining', 0, 10000),
      reward: number(item, 'reward', 1, 100),
      success: text(item, 'success'),
      retry: text(item, 'retry'),
      products: List.unmodifiable(allowed),
      requiredProducts: List.unmodifiable(required),
    );
    final productIds = products.map((product) => product.id).toSet();
    if (!productIds.containsAll(allowed) ||
        !allowed.toSet().containsAll(required) ||
        allowed.toSet().length != allowed.length ||
        required.toSet().length != required.length ||
        task.minimumNeeds + task.minimumSavings > task.budget ||
        (kind == TaskKind.saving &&
            (task.minimumSavings < 1 ||
                task.minimumSavings > task.goalRemaining)) ||
        (kind == TaskKind.basket &&
            (required.isEmpty ||
                products
                        .where((product) => required.contains(product.id))
                        .fold<int>(0, (sum, product) => sum + product.price) >
                    task.budget))) {
      throw FormatException('Unsolvable task: ${task.id}');
    }
    return task;
  }).toList();
  return GameCatalog(
    version: 1,
    products: products,
    goals: goals,
    tasks: tasks,
  );
}
