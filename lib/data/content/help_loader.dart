import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/models/help_topic.dart';

/// Загружает справку из assets; изменение текста не требует правок виджетов.
Future<List<HelpTopic>> loadHelpTopics() async {
  final String source = await rootBundle.loadString('assets/content/help.json');
  final List<dynamic> values = jsonDecode(source) as List<dynamic>;
  return List<HelpTopic>.unmodifiable(
    values.map((dynamic value) {
      final Map<String, dynamic> item = value as Map<String, dynamic>;
      final String title = item['title'] as String;
      final String text = item['text'] as String;
      if (title.trim().isEmpty || text.trim().isEmpty) {
        throw const FormatException('Help topic must not be empty');
      }
      return HelpTopic(title: title, text: text);
    }),
  );
}
