import 'dart:convert';

import '../../domain/models/accountant_session.dart';
import '../../domain/models/learning_task.dart';

/// Снимок сессии хранится целиком, чтобы новые наборы вопросов не меняли старые.
String encodeAccountantSessions(List<AccountantSession> sessions) =>
    jsonEncode([
      for (final session in sessions)
        {
          'id': session.id,
          'period': session.period,
          'dayKey': session.dayKey,
          'difficulty': session.difficulty.name,
          'satiety': session.startSatiety,
          'energy': session.startEnergy,
          'mood': session.startMood,
          'completed': session.completed,
          'paidReward': session.paidReward,
          'questions': [
            for (final question in session.questions)
              {
                'product': question.product,
                'price': question.price,
                'secondProduct': question.secondProduct,
                'secondPrice': question.secondPrice,
                'paid': question.paid,
                'choices': question.choices,
              },
          ],
          'progress': [
            for (final answer in session.progress)
              {
                'answers': answer.answers,
                'hintUsed': answer.hintUsed,
                'reviewed': answer.reviewed,
                'solved': answer.solved,
              },
          ],
        },
    ]);

List<AccountantSession> decodeAccountantSessions(String? source) {
  if (source == null || source.isEmpty) return const [];
  final data = (jsonDecode(source) as List).cast<Map<String, dynamic>>();
  return List.unmodifiable([
    for (final session in data)
      AccountantSession(
        id: session['id'] as String,
        period: session['period'] as int,
        dayKey: session['dayKey'] as String?,
        difficulty: LearningDifficulty.values.byName(
          session['difficulty'] as String,
        ),
        startSatiety: session['satiety'] as int,
        startEnergy: session['energy'] as int,
        startMood: session['mood'] as int,
        completed: session['completed'] as bool,
        paidReward: session['paidReward'] as int,
        questions: List.unmodifiable([
          for (final question
              in (session['questions'] as List).cast<Map<String, dynamic>>())
            AccountantQuestion(
              product: question['product'] as String,
              price: question['price'] as int,
              secondProduct: question['secondProduct'] as String?,
              secondPrice: question['secondPrice'] as int,
              paid: question['paid'] as int,
              choices: (question['choices'] as List).cast<int>(),
            ),
        ]),
        progress: List.unmodifiable([
          for (final answer
              in (session['progress'] as List).cast<Map<String, dynamic>>())
            AccountantAnswerState(
              answers: (answer['answers'] as List).cast<int>(),
              hintUsed: answer['hintUsed'] as bool,
              reviewed: answer['reviewed'] as bool,
              solved: answer['solved'] as bool,
            ),
        ]),
      ),
  ]);
}
