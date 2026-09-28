import '../models/game_catalog.dart';
import '../models/game_profile.dart';
import '../models/game_transaction.dart';
import '../models/learning_task.dart';
import '../models/learning_scenario.dart';
import 'activity_reward_rules.dart';
import 'game_rules.dart';
import 'learning_difficulty_rules.dart';

/// Обратная связь учебной ситуации без изменения профиля.
class QuestFeedback {
  const QuestFeedback({
    required this.title,
    required this.explanation,
    required this.consequence,
    required this.remedy,
    required this.canClaim,
    this.perfect = false,
    this.fixButton,
    this.fixedText,
  });

  final String title;
  final String explanation;
  final String consequence;
  final String remedy;
  final bool canClaim;
  final bool perfect;
  final String? fixButton;
  final String? fixedText;

  String get message =>
      '$title\n$explanation\nЧто будет: $consequence\nКак исправиться: $remedy';
}

/// Учебные монеты моделируют ситуацию; в основном балансе меняется только награда.
abstract final class LearningRules {
  static const scenarioIds = <String>{
    'need_first',
    'day_plan',
    'regular_saving',
    'saving_target',
    'compare_price',
    'free_paid',
  };

  static QuestFeedback evaluateWeeklyBudget(TaskAnswer answer) {
    final total = answer.needs + answer.wants + answer.savings;
    if (answer.needs < 0 ||
        answer.wants < 0 ||
        answer.savings < 0 ||
        total != 60) {
      return const QuestFeedback(
        title: 'Распредели все 60 коткоинов',
        explanation: 'Сумма в трёх корзинках должна быть равна 60.',
        consequence: 'Пока в плане остались нераспределённые коткоины.',
        remedy: 'Поправь суммы и проверь снова — ничего не теряется.',
        canClaim: false,
      );
    }
    if (answer.needs < 30) {
      return const QuestFeedback(
        title: 'Ой, корм пропал из плана',
        explanation:
            'На „Нужное“ ушло меньше 30 коткоинов — на еду и уход не хватит.',
        consequence:
            'Котик останется голодным и грустным до следующей награды.',
        remedy:
            'Это легко исправить: переведи коткоины в „Нужное“ — план просто поправится, ничего не потеряно.',
        canClaim: false,
      );
    }
    if (answer.savings < 5) {
      return const QuestFeedback(
        title: 'Почти получилось!',
        explanation:
            'Нужное закрыто, но в копилку ушло совсем мало или ничего.',
        consequence: 'Без отложенных коткоинов мечта будет ждать очень долго.',
        remedy:
            'Добавь в копилку хотя бы 5 коткоинов — и план станет ещё лучше.',
        canClaim: true,
      );
    }
    return const QuestFeedback(
      title: 'Отличный план!',
      explanation: 'Нужное закрыто, и в копилке что-то есть.',
      consequence:
          'Неделя пройдёт спокойно: корм есть, а коткоины в копилке приближают мечту.',
      remedy: 'Так держать! Заглядывай в бюджет и в следующие дни.',
      canClaim: true,
      perfect: true,
    );
  }

  static const dayPlanPrices = <String, int>{
    'feed': 15,
    'vet': 20,
    'bow': 20,
    'mouse': 10,
  };

  static QuestFeedback evaluateDayPlan(TaskAnswer answer) {
    final selected = answer.products.toSet();
    if (selected.length != answer.products.length ||
        !dayPlanPrices.keys.toSet().containsAll(selected)) {
      return const QuestFeedback(
        title: 'Проверь план дня',
        explanation: 'Выбери каждое дело не больше одного раза.',
        consequence: 'Пока нельзя посчитать сумму плана.',
        remedy: 'Выбери дела из списка и проверь снова.',
        canClaim: false,
      );
    }
    final total = selected.fold<int>(0, (sum, id) => sum + dayPlanPrices[id]!);
    if (total > 45) {
      return QuestFeedback(
        title: 'План больше бюджета',
        explanation: 'Сумма плана $total / 45.',
        consequence: 'Не хватает ${total - 45} коткоинов.',
        remedy: 'Убери необязательное дело и проверь снова.',
        canClaim: false,
      );
    }
    if (!selected.contains('feed') || !selected.contains('vet')) {
      return const QuestFeedback(
        title: 'Нужное пропустили',
        explanation:
            'Корм и осмотр у ветеринара — самое важное, без них день не получится.',
        consequence:
            'Голодный котик и пропущенный осмотр — плохой план на день.',
        remedy: 'Добавь в план корм и осмотр — их нельзя пропускать.',
        canClaim: false,
      );
    }
    if (total == 45) {
      return const QuestFeedback(
        title: 'Нужное закрыто!',
        explanation: 'Корм и осмотр в плане, и в бюджет мы уложились.',
        consequence:
            'Но на завтра не осталось ни коткоина — хорошо бы оставлять маленький запас.',
        remedy:
            'Убери одну необязательную покупку, чтобы что-то осталось на потом.',
        canClaim: true,
      );
    }
    return QuestFeedback(
      title: 'Бюджет под контролем!',
      explanation: 'Нужное в плане, и в кошельке ещё остались коткоины.',
      consequence: '${45 - total} коткоинов можно отложить на мечту.',
      remedy: 'Отличная привычка — планировать и оставлять запас на потом.',
      canClaim: true,
      perfect: true,
    );
  }

  static QuestFeedback evaluateFirstPurchase(TaskAnswer answer) {
    switch (answer.choice) {
      case 'food':
        return const QuestFeedback(
          title: 'Сначала нужное!',
          explanation: 'Корм закрывает главное — котик не останется голодным.',
          consequence:
              'Останется 10 коткоинов, которые можно отложить на мышку.',
          remedy: 'Помни правило: сначала нужное, потом радость.',
          canClaim: true,
          perfect: true,
        );
      case 'mouse':
        return const QuestFeedback(
          title: 'Мышка подождёт',
          explanation: 'Радость приятна, но корм важнее: без еды котику плохо.',
          consequence:
              'Потратив 25 коткоинов на мышку, на корм останется всего 5 — сегодня его не купить.',
          remedy: 'Откажись от мышки и купи корм — так котик будет сыт.',
          canClaim: false,
          fixButton: 'Вернуть мышку и купить корм',
          fixedText:
              'Теперь корм в корзине, котик сыт, а 10 коткоинов можно отложить на мышку позже.',
        );
      default:
        return const QuestFeedback(
          title: 'Выбери покупку',
          explanation: 'Сначала реши, что купить для котика.',
          consequence: 'Пока покупка не выбрана.',
          remedy: 'Выбери корм или мышку и проверь решение.',
          canClaim: false,
        );
    }
  }

  static QuestFeedback evaluateFullPrice(TaskAnswer answer) {
    switch (answer.choice) {
      case 'yes':
        return const QuestFeedback(
          title: 'Проверим цену ещё раз',
          explanation:
              'Полная цена 15 + 20 + 25 = 60, а в кошельке только 40 — не хватает 20.',
          consequence:
              'На кассе не хватит денег, и что-то придётся вернуть на полку.',
          remedy:
              'Выбери корм и лекарство за 35 — самого нужного хватит, а рыбку купим в другой раз.',
          canClaim: false,
          fixButton: 'Выбрать корм и лекарство',
          fixedText:
              'Корм и лекарство стоят 35, в кошельке останется 5 коткоинов. Рыбка подождёт.',
        );
      case 'no':
        return const QuestFeedback(
          title: 'Точно подсчитано!',
          explanation:
              'Полная цена 60 коткоинов, а есть только 40 — на всё сразу не хватит.',
          consequence:
              'Значит, берём самое нужное: корм и лекарство за 35, а рыбку — после награды.',
          remedy:
              'В магазине сначала смотрим полную цену — так приятнее у кассы!',
          canClaim: true,
          perfect: true,
        );
      default:
        return const QuestFeedback(
          title: 'Посчитай полную цену',
          explanation: 'Корм, лекарство и рыбка вместе стоят 60 коткоинов.',
          consequence: 'Ответ пока не выбран.',
          remedy: 'Сравни полную цену с 40 коткоинами в кошельке.',
          canClaim: false,
        );
    }
  }

  static QuestFeedback evaluateRewardSaving(TaskAnswer answer) {
    final saved = answer.savings;
    if (saved < 0 || saved > 30) {
      return const QuestFeedback(
        title: 'Проверь сумму',
        explanation: 'Распределить можно только 30 коткоинов награды.',
        consequence: 'Пока сумма больше доступной награды.',
        remedy: 'Выбери от 0 до 30 коткоинов для копилки.',
        canClaim: false,
      );
    }
    if (saved < 5) {
      return const QuestFeedback(
        title: 'Копилка стоит пустая',
        explanation: 'Если не отложить ничего, мечта почти не двигается.',
        consequence:
            'Игрушка радует сегодня, а беговая дорожка не приближается.',
        remedy: 'Отложи хотя бы 10 коткоинов — и копилка оживёт.',
        canClaim: false,
      );
    }
    if (saved < 10) {
      return QuestFeedback(
        title: 'Неплохо, но можно больше',
        explanation:
            'Маленький вклад — хорошо, но $saved коткоинов — мало для беговой дорожки.',
        consequence: 'На игрушку уйдёт почти всё, а дорожка будет ждать долго.',
        remedy: 'Попробуй отложить хотя бы половину награды — 15 коткоинов.',
        canClaim: true,
      );
    }
    return QuestFeedback(
      title: 'Умное решение!',
      explanation:
          'Ты не тратишь всё сразу: ${30 - saved} коткоинов — на игрушку, а $saved — в копилку.',
      consequence: 'И радость сегодня есть, и мечта потихоньку приближается.',
      remedy: 'Откладывать часть любой награды — отличная привычка!',
      canClaim: true,
      perfect: true,
    );
  }

  static QuestFeedback evaluateDailySavings(TaskAnswer answer) {
    switch (answer.choice) {
      case 'fluffy':
        return const QuestFeedback(
          title: 'Верно! Копилка любит регулярность',
          explanation:
              'Пушок откладывает по 5 коткоинов каждый день и через 18 дней соберёт все 90.',
          consequence:
              'А большая награда может не прийти — тогда Уголёк останется ни с чем.',
          remedy: 'Копить понемногу, но регулярно — надёжнее всего!',
          canClaim: true,
          perfect: true,
        );
      case 'coal':
        return const QuestFeedback(
          title: 'Ждать большую награду рискованно',
          explanation:
              'Пока Уголёк ждёт, его копилка пустая, а Пушок уже собирает цель.',
          consequence: 'Большая награда может не прийти, и время пройдёт зря.',
          remedy:
              'Лучше откладывать понемногу каждый день — маленькие шаги приводят к цели.',
          canClaim: false,
          fixButton: 'Начать откладывать понемногу',
          fixedText:
              'Уголёк тоже начинает откладывать по 5 коткоинов в день — через 18 дней лежанка его!',
        );
      case 'same':
        return const QuestFeedback(
          title: 'Копить — это регулярно',
          explanation:
              'Пушок копит каждый день, а Уголёк нет — так они накопят по-разному.',
          consequence:
              'Пушок придёт к цели через 18 дней, а Уголёк будет ждать дольше.',
          remedy:
              'Выбирай регулярные маленькие накопления — они точно работают.',
          canClaim: false,
          fixButton: 'Понял! Маленькие шаги каждый день',
          fixedText:
              'Пушок молодец: по 5 коткоинов в день — и через 18 дней лежанка у него!',
        );
      default:
        return const QuestFeedback(
          title: 'Выбери способ копить',
          explanation: 'Сравни, кто пополняет копилку каждый день.',
          consequence: 'Ответ пока не выбран.',
          remedy: 'Выбери одного из котят или вариант «Оба одинаково».',
          canClaim: false,
        );
    }
  }

  static String hintFor(String taskId) => switch (taskId) {
    'budget_lunch' => 'Сначала выдели не меньше 30 на нужное и 5 в копилку.',
    'budget_reserve' => 'Сначала сложи цену корма и осмотра.',
    'basket_food' => 'Сравни, что котику необходимо сегодня.',
    'basket_care' => 'Сложи цены всех трёх товаров и сравни с 40.',
    'saving_start' =>
      'Часть награды можно отложить, а часть оставить на игрушку.',
    'saving_finish' => 'Регулярные взносы увеличивают копилку каждый день.',
    _ => 'Сравни сумму с бюджетом и проверь обязательные покупки.',
  };

  static String stepsFor(String taskId) => switch (taskId) {
    'budget_lunch' =>
      '1. Всего 60 коткоинов.\n'
          '2. На нужное выдели хотя бы 30.\n'
          '3. В копилку — хотя бы 5. Например: 30 + 20 + 10 = 60.',
    'budget_reserve' =>
      '1. Корм стоит 15, осмотр — 20.\n'
          '2. Нужное вместе: 15 + 20 = 35.\n'
          '3. Из 45 остаётся 10 коткоинов.',
    'basket_food' =>
      '1. Корм нужен сегодня и стоит 20.\n'
          '2. В кошельке 30.\n'
          '3. После корма останется 10; мышку можно купить позже.',
    'basket_care' =>
      '1. Сложи цены: 15 + 20 + 25 = 60.\n'
          '2. Есть только 40.\n'
          '3. На всё сразу не хватает 20 коткоинов.',
    'saving_start' =>
      '1. Награда — 30 коткоинов.\n'
          '2. Отложи 10 в копилку.\n'
          '3. Остаток 20 можно потратить на игрушку.',
    'saving_finish' =>
      '1. Цель стоит 90 коткоинов.\n'
          '2. Если откладывать по 5 в день, сумма растёт ежедневно.\n'
          '3. 90 ÷ 5 = 18 игровых дней.',
    _ =>
      '1. Найди обязательные расходы.\n'
          '2. Сложи их.\n3. Сравни сумму с учебным бюджетом.',
  };

  static GameProfile submit(
    GameProfile profile,
    GameCatalog catalog,
    LearningTask task,
    TaskAnswer answer, {
    ActivityRewardSnapshot? snapshot,
  }) {
    if (scenarioIds.contains(task.id)) {
      return _submitScenario(profile, task, answer, snapshot: snapshot);
    }
    if (profile.completedTask(task.id)) {
      return profile.copyWith(
        feedback: 'Задание уже выполнено. Награда выдана один раз.',
      );
    }
    if (profile.plan == null) {
      throw const GameRuleException(
        'Сначала подтверди бюджет, затем переходи к заданиям.',
      );
    }
    final started = snapshot ?? ActivityRewardSnapshot.fromProfile(profile);
    started.requireCurrentDay(profile);
    bool correct = false;
    String result = '';
    final questFeedback = switch (task.id) {
      'budget_lunch' => evaluateWeeklyBudget(answer),
      'budget_reserve' => evaluateDayPlan(answer),
      'basket_food' => evaluateFirstPurchase(answer),
      'basket_care' => evaluateFullPrice(answer),
      'saving_start' => evaluateRewardSaving(answer),
      'saving_finish' => evaluateDailySavings(answer),
      _ => null,
    };
    if (questFeedback != null) {
      correct = questFeedback.canClaim;
      result = questFeedback.message;
    } else if (answer.needs < 0 || answer.wants < 0 || answer.savings < 0) {
      result = 'Суммы не могут быть отрицательными. ';
    } else {
      switch (task.kind) {
        case TaskKind.budget:
          final total = answer.needs + answer.wants + answer.savings;
          correct =
              total <= task.budget &&
              answer.needs >= task.minimumNeeds &&
              answer.savings >= task.minimumSavings;
          result = total > task.budget
              ? 'Не хватает ${total - task.budget} учебных монет. '
              : 'Распределено $total из ${task.budget}, осталось ${task.budget - total}. ';
        case TaskKind.basket:
          final ids = answer.products.toSet();
          if (ids.length != answer.products.length ||
              !task.products.toSet().containsAll(ids)) {
            result =
                'Используй только товары этой учебной корзины, каждый по одному разу. ';
            break;
          }
          final total = ids.fold<int>(
            0,
            (sum, id) => sum + catalog.product(id).price,
          );
          correct =
              total <= task.budget && ids.containsAll(task.requiredProducts);
          result = 'Корзина стоит $total из ${task.budget} учебных монет. ';
        case TaskKind.saving:
          correct =
              answer.savings >= task.minimumSavings &&
              answer.savings <= task.goalRemaining &&
              answer.savings <= task.budget - task.minimumNeeds;
          result = answer.savings <= task.budget
              ? 'После учебного перевода осталось бы ${task.budget - answer.savings} монет. '
              : 'Такого количества учебных монет пока нет. ';
        case TaskKind.choice:
          result = 'Выбери один вариант и проверь снова. ';
      }
    }
    final old = profile.taskProgress
        .where((progress) => progress.taskId == task.id)
        .firstOrNull;
    final reward = started.taskReward;
    final attempts = (old?.attempts ?? 0) + 1;
    final feedback = correct
        ? '$result ${started.taskExplanation} '
              'Уже заработанные коткоины остаются у тебя.'
        : attempts == 1
        ? 'Подсказка: ${hintFor(task.id)} Попробуй ещё раз — коткоины не потеряны.'
        : 'Разбор по шагам:\n${stepsFor(task.id)}\n'
              'Можешь попробовать ещё раз или нажать «Понятно». '
              'Награда не уменьшается.';
    final progress = TaskProgress(
      taskId: task.id,
      attempts: attempts,
      completed: correct,
      feedback: feedback,
      hintUsed: old?.hintUsed == true || !correct,
      solutionShown: old?.solutionShown == true || (!correct && attempts >= 2),
    );
    final balance = profile.balance + (correct ? reward : 0);
    return profile.copyWith(
      balance: balance,
      feedback: feedback,
      taskProgress: [
        ...profile.taskProgress.where((entry) => entry.taskId != task.id),
        progress,
      ],
      transactions: [
        ...profile.transactions,
        if (correct)
          GameTransaction(
            id: 'task-reward-${task.id}',
            period: profile.period,
            kind: TransactionKind.income,
            amount: reward,
            label: 'Задание: ${task.title}',
            referenceId: task.id,
            startSatiety: started.satiety,
            startEnergy: started.energy,
            startMood: started.mood,
            baseReward: 12,
            balanceAfter: balance,
            savingsAfter: profile.savings,
            satietyAfter: profile.satiety,
            moodAfter: profile.mood,
          ),
      ],
    );
  }

  /// После разбора «Понятно» закрывает задание той же первой наградой.
  static GameProfile acknowledge(
    GameProfile profile,
    LearningTask task, {
    ActivityRewardSnapshot? snapshot,
  }) {
    if (scenarioIds.contains(task.id)) {
      return _acknowledgeScenario(profile, task, snapshot: snapshot);
    }
    if (profile.completedTask(task.id)) return profile;
    GameRules.requirePlan(profile);
    final old = profile.taskProgress
        .where((entry) => entry.taskId == task.id)
        .firstOrNull;
    if (old == null || !old.solutionShown) {
      throw const GameRuleException(
        'Сначала посмотри разбор после двух попыток.',
      );
    }
    final started = snapshot ?? ActivityRewardSnapshot.fromProfile(profile);
    started.requireCurrentDay(profile);
    final reward = started.taskReward;
    final balance = profile.balance + reward;
    final feedback =
        'Разбор понятен. ${started.taskExplanation} '
        'Уже заработанные коткоины остаются у тебя.';
    return profile.copyWith(
      balance: balance,
      feedback: feedback,
      taskProgress: [
        ...profile.taskProgress.where((entry) => entry.taskId != task.id),
        TaskProgress(
          taskId: task.id,
          attempts: old.attempts,
          completed: true,
          feedback: feedback,
          hintUsed: true,
          solutionShown: true,
          reviewed: true,
        ),
      ],
      transactions: [
        ...profile.transactions,
        GameTransaction(
          id: 'task-reward-${task.id}',
          period: profile.period,
          kind: TransactionKind.income,
          amount: reward,
          label: 'Разобранное задание: ${task.title}',
          referenceId: task.id,
          startSatiety: started.satiety,
          startEnergy: started.energy,
          startMood: started.mood,
          baseReward: 12,
          balanceAfter: balance,
          savingsAfter: profile.savings,
          satietyAfter: profile.satiety,
          moodAfter: profile.mood,
        ),
      ],
    );
  }

  static GameProfile _submitScenario(
    GameProfile profile,
    LearningTask task,
    TaskAnswer answer, {
    ActivityRewardSnapshot? snapshot,
  }) {
    GameRules.requirePlan(profile);
    final old = profile.taskProgress
        .where((entry) => entry.taskId == task.id)
        .firstOrNull;
    final practice = old?.completed == true;
    final scenario = LearningScenario.forTask(
      task.id,
      profile.learningTopic(task.topic).difficulty,
      practice: practice,
    );
    final correct = scenario.accepts(answer);
    final attempts = practice
        ? (old?.practiceAttempts ?? 0) + 1
        : (old?.attempts ?? 0) + 1;
    final reward = correct && !practice;
    final started = snapshot ?? ActivityRewardSnapshot.fromProfile(profile);
    started.requireCurrentDay(profile);
    final balance = profile.balance + (reward ? started.taskReward : 0);
    final feedback = correct
        ? '${scenario.explanation} ${practice ? 'Это тренировка без повторной награды.' : '${started.taskExplanation} Уже заработанные коткоины остаются у тебя.'}'
        : attempts == 1
        ? 'Подсказка: ${scenario.hint} Попробуй ещё раз — коткоины не потеряны.'
        : 'Разбор по шагам:\n${scenario.steps}\nМожешь попробовать ещё раз или нажать «Понятно». Награда не уменьшается.';
    final progress = practice
        ? TaskProgress(
            taskId: task.id,
            attempts: old!.attempts,
            completed: true,
            feedback: feedback,
            hintUsed: old.hintUsed,
            solutionShown: old.solutionShown,
            reviewed: old.reviewed,
            practiceAttempts: correct ? 0 : attempts,
          )
        : TaskProgress(
            taskId: task.id,
            attempts: attempts,
            completed: correct,
            feedback: feedback,
            hintUsed: old?.hintUsed == true || !correct,
            solutionShown:
                old?.solutionShown == true || (!correct && attempts >= 2),
          );
    var next = profile.copyWith(
      balance: balance,
      feedback: feedback,
      taskProgress: [
        ...profile.taskProgress.where((entry) => entry.taskId != task.id),
        progress,
      ],
      transactions: [
        ...profile.transactions,
        if (reward)
          GameTransaction(
            id: 'task-reward-${task.id}',
            period: profile.period,
            kind: TransactionKind.income,
            amount: started.taskReward,
            label: 'Задание: ${task.title}',
            referenceId: task.id,
            startSatiety: started.satiety,
            startEnergy: started.energy,
            startMood: started.mood,
            baseReward: 12,
            balanceAfter: balance,
            savingsAfter: profile.savings,
            satietyAfter: profile.satiety,
            moodAfter: profile.mood,
          ),
      ],
    );
    if (correct) {
      next = LearningDifficultyRules.afterTask(
        next,
        task.topic,
        clean: attempts == 1,
      );
    }
    return next;
  }

  static GameProfile _acknowledgeScenario(
    GameProfile profile,
    LearningTask task, {
    ActivityRewardSnapshot? snapshot,
  }) {
    GameRules.requirePlan(profile);
    final old = profile.taskProgress
        .where((entry) => entry.taskId == task.id)
        .firstOrNull;
    if (old == null ||
        (old.completed ? old.practiceAttempts < 2 : !old.solutionShown)) {
      throw const GameRuleException(
        'Сначала посмотри разбор после двух попыток.',
      );
    }
    if (old.completed) {
      return LearningDifficultyRules.afterTask(
        profile.copyWith(
          feedback: 'Разбор понятен. Это тренировка без повторной награды.',
          taskProgress: [
            ...profile.taskProgress.where((entry) => entry.taskId != task.id),
            TaskProgress(
              taskId: task.id,
              attempts: old.attempts,
              completed: true,
              feedback: 'Разбор понятен. Это тренировка без повторной награды.',
              hintUsed: old.hintUsed,
              solutionShown: old.solutionShown,
              reviewed: old.reviewed,
            ),
          ],
        ),
        task.topic,
        clean: false,
      );
    }
    final started = snapshot ?? ActivityRewardSnapshot.fromProfile(profile);
    started.requireCurrentDay(profile);
    final balance = profile.balance + started.taskReward;
    final feedback =
        'Разбор понятен. ${started.taskExplanation} Уже заработанные коткоины остаются у тебя.';
    final next = profile.copyWith(
      balance: balance,
      feedback: feedback,
      taskProgress: [
        ...profile.taskProgress.where((entry) => entry.taskId != task.id),
        TaskProgress(
          taskId: task.id,
          attempts: old.attempts,
          completed: true,
          feedback: feedback,
          hintUsed: true,
          solutionShown: true,
          reviewed: true,
        ),
      ],
      transactions: [
        ...profile.transactions,
        GameTransaction(
          id: 'task-reward-${task.id}',
          period: profile.period,
          kind: TransactionKind.income,
          amount: started.taskReward,
          label: 'Разобранное задание: ${task.title}',
          referenceId: task.id,
          startSatiety: started.satiety,
          startEnergy: started.energy,
          startMood: started.mood,
          baseReward: 12,
          balanceAfter: balance,
          savingsAfter: profile.savings,
          satietyAfter: profile.satiety,
          moodAfter: profile.mood,
        ),
      ],
    );
    return LearningDifficultyRules.afterTask(next, task.topic, clean: false);
  }
}
