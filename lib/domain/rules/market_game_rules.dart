/// Товар учебной корзины; реальные покупки через это правило не совершаются.
class MarketGameItem {
  const MarketGameItem({
    required this.id,
    required this.title,
    required this.price,
    required this.needed,
  });

  final String id;
  final String title;
  final int price;
  final bool needed;
}

class MarketCartResult {
  const MarketCartResult({
    required this.canClaim,
    required this.spent,
    required this.remaining,
    required this.message,
  });

  final bool canClaim;
  final int spent;
  final int remaining;
  final String message;
}

/// Проверяет приоритет нужных покупок и остаток учебного бюджета.
abstract final class MarketGameRules {
  static const int budget = 60;
  static const items = <MarketGameItem>[
    MarketGameItem(id: 'food', title: 'Корм', price: 15, needed: true),
    MarketGameItem(id: 'shampoo', title: 'Шампунь', price: 10, needed: true),
    MarketGameItem(id: 'toy', title: 'Игрушка', price: 20, needed: false),
  ];

  static MarketGameItem item(String id) => items.firstWhere(
    (entry) => entry.id == id,
    orElse: () => throw ArgumentError.value(id, 'id', 'Unknown market item'),
  );

  static int spent(Iterable<String> itemIds) =>
      itemIds.fold(0, (total, id) => total + item(id).price);

  static MarketCartResult evaluate(List<String> selection) {
    if (selection.toSet().length != selection.length) {
      throw ArgumentError.value(
        selection,
        'selection',
        'Duplicate market item',
      );
    }
    final total = spent(selection);
    final remaining = budget - total;
    MarketCartResult result(bool canClaim, String message) => MarketCartResult(
      canClaim: canClaim,
      spent: total,
      remaining: remaining,
      message: message,
    );

    if (remaining < 0) {
      return result(
        false,
        'Корзина дороже бюджета на ${-remaining} коткоинов. Убери один товар и попробуй снова.',
      );
    }
    if (items
        .where((entry) => entry.needed)
        .any((entry) => !selection.contains(entry.id))) {
      return result(
        false,
        'Сначала положи в корзину корм и шампунь — это нужное котику. Выбор можно изменить.',
      );
    }
    final firstWant = selection.indexWhere((id) => !item(id).needed);
    final lastNeed = selection.lastIndexWhere((id) => item(id).needed);
    if (firstWant >= 0 && firstWant < lastNeed) {
      return result(
        false,
        'Начни с нужного: убери игрушку и положи её после корма и шампуня.',
      );
    }
    return result(
      true,
      'Сначала выбрано нужное. Потрачено $total, осталось $remaining коткоинов — их можно отложить на цель.',
    );
  }
}
