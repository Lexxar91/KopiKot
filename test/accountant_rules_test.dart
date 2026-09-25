import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/domain/rules/accountant_rules.dart';

void main() {
  test('оба примера имеют один правильный ответ и неотрицательную сдачу', () {
    expect(AccountantRules.questions, hasLength(2));
    for (final question in AccountantRules.questions) {
      expect(question.correctChange, greaterThanOrEqualTo(0));
      expect(question.choices.where(question.isCorrect), hasLength(1));
      expect(question.choices.toSet(), hasLength(question.choices.length));
    }
    expect(AccountantRules.questions.first.correctChange, 35);
  });
}
