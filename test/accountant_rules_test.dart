import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/local/accountant_session_codec.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/models/learning_task.dart';
import 'package:kopikot/domain/rules/accountant_rules.dart';
import 'package:kopikot/domain/rules/game_rules.dart';
import 'package:kopikot/domain/rules/learning_difficulty_rules.dart';

import 'game_rules_test.dart' show initialProfile;

GameProfile ready() => initialProfile.withPlan(
  GameRules.confirmBudget(initialProfile, needs: 40, wants: 20, savings: 10),
);

GameProfile solveClean(GameProfile profile, String id) {
  var next = AccountantRules.apply(profile, id, AccountantAction.start);
  for (final question in next.accountantSessions.last.questions) {
    next = AccountantRules.apply(
      next,
      id,
      AccountantAction.answer,
      answer: question.correctChange,
    );
  }
  return AccountantRules.apply(next, id, AccountantAction.finish);
}

void main() {
  test('оба примера имеют один правильный ответ и неотрицательную сдачу', () {
    for (final difficulty in LearningDifficulty.values) {
      final questions = AccountantRules.questionsFor(difficulty);
      expect(questions, hasLength(2));
      for (final question in questions) {
        expect(question.correctChange, greaterThanOrEqualTo(0));
        expect(
          question.paid,
          lessThanOrEqualTo(switch (difficulty) {
            LearningDifficulty.simple => 20,
            LearningDifficulty.medium => 60,
            LearningDifficulty.hard => 100,
          }),
        );
        expect(question.totalPrice, lessThanOrEqualTo(question.paid));
        expect(question.choices.where(question.isCorrect), hasLength(1));
        expect(question.choices.toSet(), hasLength(4));
      }
    }
    expect(AccountantRules.questions.first.correctChange, 35);
  });

  test('После двух ошибок доступен разбор без штрафа и звезды', () {
    var profile = AccountantRules.apply(
      ready(),
      'round-1',
      AccountantAction.start,
    );
    final question = profile.accountantSessions.single.questions.first;
    final wrong = question.choices.firstWhere(
      (value) => !question.isCorrect(value),
    );
    profile = AccountantRules.apply(
      profile,
      'round-1',
      AccountantAction.answer,
      answer: wrong,
    );
    expect(profile.accountantSessions.single.progress.first.hintUsed, isTrue);
    expect(
      () => AccountantRules.apply(
        profile,
        'round-1',
        AccountantAction.understood,
      ),
      throwsA(isA<GameRuleException>()),
    );
    profile = AccountantRules.apply(
      profile,
      'round-1',
      AccountantAction.answer,
      answer: wrong,
    );
    profile = AccountantRules.apply(
      profile,
      'round-1',
      AccountantAction.understood,
    );
    expect(profile.accountantSessions.single.progress.first.reviewed, isTrue);
    final second = profile.accountantSessions.single.questions.last;
    profile = AccountantRules.apply(
      profile,
      'round-1',
      AccountantAction.answer,
      answer: second.correctChange,
    );
    profile = AccountantRules.apply(
      profile,
      'round-1',
      AccountantAction.finish,
    );
    expect(profile.accountantSessions.single.stars, 1);
    expect(profile.accountantSessions.single.paidReward, 6);
    expect(profile.balance, 106);
    expect(profile.learningTopic('accountant').cleanStreak, 0);
  });

  test('Повторная игра не платит, две чистые сессии повышают сложность', () {
    var profile = solveClean(ready(), 'first');
    expect(profile.balance, 106);
    expect(profile.accountantSessions.last.stars, 2);
    profile = solveClean(profile, 'second');
    expect(profile.balance, 106);
    expect(profile.accountantSessions.last.paidReward, 0);
    expect(
      profile.learningTopic('accountant').difficulty,
      LearningDifficulty.medium,
    );
    profile = AccountantRules.apply(profile, 'third', AccountantAction.start);
    expect(profile.accountantSessions.last.questions.first.correctChange, 35);
  });

  test(
    'Шкалы и вопросы фиксируются при старте; ответы переживают кодирование',
    () {
      var profile = ready().copyWith(energy: 49);
      profile = AccountantRules.apply(profile, 'saved', AccountantAction.start);
      final wrong = profile.accountantSessions.last.questions.first.choices[1];
      profile = AccountantRules.apply(
        profile,
        'saved',
        AccountantAction.answer,
        answer: wrong,
      );
      final decoded = decodeAccountantSessions(
        encodeAccountantSessions(profile.accountantSessions),
      ).single;
      expect(decoded.progress.first.answers, [wrong]);
      expect(AccountantRules.snapshot(decoded).gameReward, 5);
      profile = profile.copyWith(energy: 100);
      final first = profile.accountantSessions.single.questions.first;
      profile = AccountantRules.apply(
        profile,
        'saved',
        AccountantAction.answer,
        answer: first.correctChange,
      );
      final second = profile.accountantSessions.single.questions.last;
      profile = AccountantRules.apply(
        profile,
        'saved',
        AccountantAction.answer,
        answer: second.correctChange,
      );
      profile = AccountantRules.apply(
        profile,
        'saved',
        AccountantAction.finish,
      );
      expect(profile.accountantSessions.single.paidReward, 5);
    },
  );

  test('Сменившийся день не позволяет начислить награду старой сессии', () {
    final profile = AccountantRules.apply(
      ready(),
      'old',
      AccountantAction.start,
    );
    expect(
      () => AccountantRules.apply(
        profile.copyWith(period: 2),
        'old',
        AccountantAction.hint,
      ),
      throwsA(isA<GameRuleException>()),
    );
  });

  test('После трёх сессий с помощью предлагается ступень проще', () {
    var profile = LearningDifficultyRules.choose(
      ready(),
      'accountant',
      LearningDifficulty.medium,
    );
    for (var round = 1; round <= 3; round++) {
      final id = 'help-$round';
      profile = AccountantRules.apply(profile, id, AccountantAction.start);
      final first = profile.accountantSessions.last.questions.first;
      profile = AccountantRules.apply(
        profile,
        id,
        AccountantAction.answer,
        answer: first.choices.firstWhere((value) => !first.isCorrect(value)),
      );
      profile = AccountantRules.apply(
        profile,
        id,
        AccountantAction.answer,
        answer: first.correctChange,
      );
      final second = profile.accountantSessions.last.questions.last;
      profile = AccountantRules.apply(
        profile,
        id,
        AccountantAction.answer,
        answer: second.correctChange,
      );
      profile = AccountantRules.apply(profile, id, AccountantAction.finish);
    }
    expect(
      profile.learningTopic('accountant').difficulty,
      LearningDifficulty.medium,
    );
    expect(profile.learningTopic('accountant').downgradePending, isTrue);
  });
}
