import '../models/accountant_session.dart';
import '../models/game_profile.dart';
import '../models/learning_task.dart';
import 'activity_reward_rules.dart';
import 'game_rules.dart';
import 'learning_difficulty_rules.dart';
import 'mini_game_rules.dart';

enum AccountantAction { start, answer, hint, understood, finish }

/// Задачи игры отделены от виджета, чтобы проверка не зависела от интерфейса.
abstract final class AccountantRules {
  static ActivityRewardSnapshot snapshot(AccountantSession session) =>
      ActivityRewardSnapshot(
        period: session.period,
        dayKey: session.dayKey,
        satiety: session.startSatiety,
        energy: session.startEnergy,
        mood: session.startMood,
      );

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

  static const simpleQuestions = <AccountantQuestion>[
    AccountantQuestion(
      product: 'Корм',
      price: 8,
      paid: 20,
      choices: [12, 10, 8, 15],
    ),
    AccountantQuestion(
      product: 'Молочко',
      price: 6,
      paid: 15,
      choices: [7, 9, 11, 6],
    ),
  ];

  static const hardQuestions = <AccountantQuestion>[
    AccountantQuestion(
      product: 'Корм',
      price: 25,
      secondProduct: 'Щётка',
      secondPrice: 15,
      paid: 80,
      choices: [40, 35, 45, 30],
    ),
    AccountantQuestion(
      product: 'Игрушка',
      price: 30,
      secondProduct: 'Молочко',
      secondPrice: 25,
      paid: 100,
      choices: [40, 45, 35, 55],
    ),
  ];

  static List<AccountantQuestion> questionsFor(LearningDifficulty difficulty) =>
      switch (difficulty) {
        LearningDifficulty.simple => simpleQuestions,
        LearningDifficulty.medium => questions,
        LearningDifficulty.hard => hardQuestions,
      };

  static GameProfile apply(
    GameProfile profile,
    String sessionId,
    AccountantAction action, {
    int? answer,
  }) {
    if (sessionId.trim().isEmpty) {
      throw ArgumentError.value(sessionId, 'sessionId');
    }
    if (action == AccountantAction.start) {
      GameRules.requirePlan(profile);
      if (profile.accountantSessions.any((entry) => entry.id == sessionId)) {
        return profile;
      }
      final difficulty = profile.learningTopic('accountant').difficulty;
      final questions = questionsFor(difficulty);
      return profile.copyWith(
        accountantSessions: [
          ...profile.accountantSessions,
          AccountantSession(
            id: sessionId,
            period: profile.period,
            dayKey: profile.dayKey,
            difficulty: difficulty,
            questions: questions,
            progress: [
              for (final _ in questions) const AccountantAnswerState(),
            ],
            startSatiety: profile.satiety,
            startEnergy: profile.energy,
            startMood: profile.mood,
          ),
        ],
      );
    }
    final session = profile.accountantSessions
        .where((entry) => entry.id == sessionId)
        .firstOrNull;
    if (session == null) {
      throw const GameRuleException('Сессия не найдена. Начни игру заново.');
    }
    if (session.completed) return profile;
    snapshot(session).requireCurrentDay(profile);
    final index = session.currentIndex;
    final current = session.progress[index];
    AccountantSession updated;
    if (action == AccountantAction.finish) {
      if (!session.readyToFinish) {
        throw const GameRuleException('Сначала закончи оба примера.');
      }
      final paid = MiniGameRules.claim(
        profile,
        MiniGameKind.accountant,
        sessionId,
        snapshot: snapshot(session),
      );
      final reward =
          paid.transactions
              .where((entry) => entry.id == 'mini-game-$sessionId')
              .firstOrNull
              ?.amount ??
          0;
      updated = session.copyWith(completed: true, paidReward: reward);
      final advanced = LearningDifficultyRules.afterTask(
        paid,
        'accountant',
        clean: session.stars == session.questions.length,
      );
      return _replace(advanced, updated);
    }
    if (current.solved) return profile;
    AccountantAnswerState next;
    switch (action) {
      case AccountantAction.answer:
        if (answer == null ||
            !session.questions[index].choices.contains(answer)) {
          throw const GameRuleException('Выбери один из предложенных ответов.');
        }
        final answers = [...current.answers, answer];
        next = AccountantAnswerState(
          answers: answers,
          hintUsed:
              current.hintUsed || !session.questions[index].isCorrect(answer),
          solved: session.questions[index].isCorrect(answer),
        );
      case AccountantAction.hint:
        next = AccountantAnswerState(answers: current.answers, hintUsed: true);
      case AccountantAction.understood:
        if (current.errors < 2) {
          throw const GameRuleException('Сначала попробуй ответить ещё раз.');
        }
        next = AccountantAnswerState(
          answers: current.answers,
          hintUsed: true,
          reviewed: true,
          solved: true,
        );
      case AccountantAction.start || AccountantAction.finish:
        throw StateError('Unexpected accountant action');
    }
    final progress = [...session.progress]..[index] = next;
    updated = session.copyWith(progress: progress);
    return _replace(profile, updated);
  }

  static GameProfile _replace(GameProfile profile, AccountantSession session) =>
      profile.copyWith(
        accountantSessions: [
          for (final entry in profile.accountantSessions)
            entry.id == session.id ? session : entry,
        ],
      );
}
