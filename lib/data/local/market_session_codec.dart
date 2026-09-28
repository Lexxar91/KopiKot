import 'dart:convert';

import '../../domain/models/learning_task.dart';
import '../../domain/models/market_session.dart';

/// Хранит цены сценария вместе с ответами, даже если каталог игры изменится.
String encodeMarketSessions(List<MarketSession> sessions) => jsonEncode([
  for (final session in sessions)
    {
      'id': session.id,
      'period': session.period,
      'dayKey': session.dayKey,
      'difficulty': session.difficulty.name,
      'version': session.scenario.version,
      'budget': session.scenario.budget,
      'reserve': session.scenario.reserve,
      'items': [
        for (final item in session.scenario.items)
          {
            'id': item.id,
            'title': item.title,
            'price': item.price,
            'needed': item.needed,
          },
      ],
      'startSatiety': session.startSatiety,
      'startEnergy': session.startEnergy,
      'startMood': session.startMood,
      'selectedIds': session.selectedIds,
      'attempts': session.attempts,
      'hintUsed': session.hintUsed,
      'reviewed': session.reviewed,
      'solved': session.solved,
      'completed': session.completed,
      'paidReward': session.paidReward,
      'lastFeedback': session.lastFeedback,
    },
]);

List<MarketSession> decodeMarketSessions(String? source) {
  if (source == null || source.isEmpty) return const [];
  final data = (jsonDecode(source) as List).cast<Map<String, dynamic>>();
  return List.unmodifiable([
    for (final session in data)
      MarketSession(
        id: session['id'] as String,
        period: session['period'] as int,
        dayKey: session['dayKey'] as String?,
        difficulty: LearningDifficulty.values.byName(
          session['difficulty'] as String,
        ),
        scenario: MarketScenario(
          version: session['version'] as int,
          budget: session['budget'] as int,
          reserve: session['reserve'] as int,
          items: List.unmodifiable([
            for (final item
                in (session['items'] as List).cast<Map<String, dynamic>>())
              MarketGameItem(
                id: item['id'] as String,
                title: item['title'] as String,
                price: item['price'] as int,
                needed: item['needed'] as bool,
              ),
          ]),
        ),
        startSatiety: session['startSatiety'] as int,
        startEnergy: session['startEnergy'] as int,
        startMood: session['startMood'] as int,
        selectedIds: (session['selectedIds'] as List).cast<String>(),
        attempts: session['attempts'] as int,
        hintUsed: session['hintUsed'] as bool,
        reviewed: session['reviewed'] as bool,
        solved: session['solved'] as bool,
        completed: session['completed'] as bool,
        paidReward: session['paidReward'] as int,
        lastFeedback: session['lastFeedback'] as String?,
      ),
  ]);
}
