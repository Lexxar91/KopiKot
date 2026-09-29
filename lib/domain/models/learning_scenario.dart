import 'learning_task.dart';

enum LearningAnswerKind { choice, amount, selection }

class LearningOption {
  const LearningOption(this.id, this.label);
  final String id;
  final String label;
}

/// Версия задания зависит от темы и ступени, но не меняет реальный кошелёк.
class LearningScenario {
  const LearningScenario({
    required this.prompt,
    required this.kind,
    required this.hint,
    required this.steps,
    required this.explanation,
    this.options = const [],
    this.correctChoice,
    this.correctAmount,
    this.correctSelection = const [],
  });

  final String prompt;
  final LearningAnswerKind kind;
  final List<LearningOption> options;
  final String? correctChoice;
  final int? correctAmount;
  final List<String> correctSelection;
  final String hint;
  final String steps;
  final String explanation;

  bool accepts(TaskAnswer answer) => switch (kind) {
    LearningAnswerKind.choice => answer.choice == correctChoice,
    LearningAnswerKind.amount => answer.needs == correctAmount,
    LearningAnswerKind.selection =>
      answer.products.length == correctSelection.length &&
          answer.products.toSet().containsAll(correctSelection),
  };

  static LearningScenario forTask(
    String taskId,
    LearningDifficulty difficulty, {
    bool practice = false,
  }) {
    final tier = difficulty.index;
    switch (taskId) {
      case 'need_first':
        final budget = [20, 30, 50][tier] - (practice ? 1 : 0);
        final food = [10, 20, 30][tier] - (practice ? 1 : 0);
        final toy = [15, 25, 35][tier] - (practice ? 1 : 0);
        final target = budget - food;
        return LearningScenario(
          prompt:
              'В кошельке $budget коткоинов. Корм стоит $food, а золотая мышка — $toy. Выбери покупку, после которой останется ровно $target.',
          kind: LearningAnswerKind.choice,
          options: [
            const LearningOption('food', 'Сначала корм'),
            const LearningOption('mouse', 'Сначала мышка'),
          ],
          correctChoice: 'food',
          hint: 'Сравни остаток после каждой покупки с числом $target.',
          steps:
              '$budget − $food = $target после корма.\n$budget − $toy = ${budget - toy} после мышки.',
          explanation:
              'Корм стоит $food, поэтому останется $target. После мышки останется ${budget - toy}; на корм этого не хватит.',
        );
      case 'day_plan':
        final budget = [20, 45, 100][tier];
        final feed = [8, 15, 25][tier] - (practice ? 1 : 0);
        final vet = [7, 20, 30][tier] + (practice ? 1 : 0);
        final ride = tier == 2 ? 15 : 0;
        final cheap = [5, 10, 12][tier];
        final expensive = [10, 20, 25][tier];
        final options = [
          LearningOption('feed', 'Корм — $feed'),
          LearningOption('vet', 'Осмотр — $vet'),
          if (ride > 0) LearningOption('ride', 'Проезд — $ride'),
          LearningOption(
            'cheap',
            tier == 2 ? 'Книга — $cheap' : 'Игра — $cheap',
          ),
          LearningOption(
            'expensive',
            tier == 2 ? 'Домик — $expensive' : 'Бантик — $expensive',
          ),
        ];
        final correct = [
          'feed',
          'vet',
          if (ride > 0) 'ride',
          tier == 2 ? 'expensive' : 'cheap',
        ];
        final necessary = feed + vet + ride;
        return LearningScenario(
          prompt:
              'У котика $budget коткоинов. Выбери все обязательные дела и ровно одно желание: ${tier == 2 ? 'самое дорогое, которое можно купить после обязательных дел' : 'то, которое поместится в бюджет'}.',
          kind: LearningAnswerKind.selection,
          options: options,
          correctSelection: correct,
          hint:
              'Сначала сложи обязательные расходы. Затем посчитай, сколько осталось на одно желание.',
          steps:
              'Нужное: $necessary.\nПосле нужного остаётся ${budget - necessary}.\nПодходит ${tier == 2 ? 'домик' : 'игра'} за ${tier == 2 ? expensive : cheap}.',
          explanation:
              'Нужное стоит $necessary. После обязательных покупок на желание остаётся ${budget - necessary}. Выбранный вариант помещается.',
        );
      case 'regular_saving':
        final days = [3, 6, 8][tier];
        final daily = practice ? 4 : 5;
        final total = days * daily;
        final daysText = switch (days) {
          3 => 'трёх',
          6 => 'шести',
          _ => 'восьми',
        };
        return LearningScenario(
          prompt:
              'Барсик откладывает по $daily коткоинов каждый день в течение $daysText дней. Сколько он накопит? Хватит ли на саженец за $total?',
          kind: LearningAnswerKind.amount,
          correctAmount: total,
          hint: 'Прибавь $daily столько раз, сколько прошло дней: $days.',
          steps: List.generate(
            days,
            (index) => '${index + 1}-й день: ${(index + 1) * daily}',
          ).join('\n'),
          explanation:
              '$daily коткоинов каждый день в течение $days дней — это $total. На саженец хватит.',
        );
      case 'saving_target':
        final reward = [12, 30, 50][tier] + (practice ? 1 : 0);
        final saved = [5, 4, 23][tier] + (practice ? 1 : 0);
        final goal = [10, 10, 40][tier];
        final deposit = goal - saved;
        return LearningScenario(
          prompt:
              'Барсик получил $reward коткоинов. В копилке уже $saved, а цель — $goal. Сколько ровно нужно отложить из награды?',
          kind: LearningAnswerKind.amount,
          correctAmount: deposit,
          hint: 'Досчитай от $saved до $goal.',
          steps:
              '$goal − $saved = $deposit нужно отложить.\nИз награды останется $reward − $deposit = ${reward - deposit}.',
          explanation:
              'До $goal не хватает $deposit. После перевода из награды останется ${reward - deposit}.',
        );
      case 'compare_price':
        final a = [6, 18, 35][tier] - (practice ? 1 : 0);
        final delivery = [2, 4, 7][tier];
        final b = [9, 21, 39][tier] - (practice ? 1 : 0);
        final wallet = [10, 25, 50][tier];
        final winner = a + delivery < b ? 'a' : 'b';
        final price = winner == 'a' ? a + delivery : b;
        return LearningScenario(
          prompt:
              'Одинаковая книжка: киоск А — $a и доставка $delivery; киоск Б — $b и бесплатная доставка. В кошельке $wallet. Где полная цена меньше?',
          kind: LearningAnswerKind.choice,
          options: [
            const LearningOption('a', 'Киоск А'),
            const LearningOption('b', 'Киоск Б'),
          ],
          correctChoice: winner,
          hint: 'К цене в киоске А добавь доставку.',
          steps:
              'Киоск А: $a + $delivery = ${a + delivery}.\nКиоск Б: $b + 0 = $b.\nДешевле киоск ${winner == 'a' ? 'А' : 'Б'}.',
          explanation:
              'Полная цена в А — ${a + delivery}, в Б — $b. Дешевле киоск ${winner == 'a' ? 'А' : 'Б'}; останется ${wallet - price}.',
        );
      case 'free_paid':
        final wallet = [10, 20, 50][tier];
        final transport = [2, 5, 12][tier] + (practice ? 1 : 0);
        final treat = [3, 8, 17][tier];
        final spent = transport + treat;
        return LearningScenario(
          prompt:
              'У Барсика $wallet коткоинов. ${tier == 0
                  ? 'Площадка'
                  : tier == 1
                  ? 'Библиотека'
                  : 'Прогулка'} бесплатна (0), проезд стоит $transport, а угощение — $treat. Сколько останется после всех дел?',
          kind: LearningAnswerKind.amount,
          correctAmount: wallet - spent,
          hint: 'Бесплатное дело стоит 0. Сложи только проезд и угощение.',
          steps:
              '$transport + $treat = $spent потрачено.\n$wallet − $spent = ${wallet - spent} останется.',
          explanation:
              'Бесплатное дело стоит 0. Проезд и угощение стоят $spent; из $wallet останется ${wallet - spent}.',
        );
      default:
        throw ArgumentError.value(
          taskId,
          'taskId',
          'Unknown learning scenario',
        );
    }
  }
}
