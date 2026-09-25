/// Один короткий пример на вычисление сдачи.
class AccountantQuestion {
  const AccountantQuestion({
    required this.product,
    required this.price,
    required this.paid,
    required this.choices,
  });

  final String product;
  final int price;
  final int paid;
  final List<int> choices;

  int get correctChange => paid - price;

  bool isCorrect(int answer) => answer == correctChange;
}

/// Задачи игры отделены от виджета, чтобы проверка не зависела от интерфейса.
abstract final class AccountantRules {
  static const questions = <AccountantQuestion>[
    AccountantQuestion(
      product: 'Корм',
      price: 15,
      paid: 50,
      choices: [35, 25, 30, 45],
    ),
    AccountantQuestion(
      product: 'Игрушка',
      price: 20,
      paid: 50,
      choices: [25, 30, 35, 40],
    ),
  ];
}
