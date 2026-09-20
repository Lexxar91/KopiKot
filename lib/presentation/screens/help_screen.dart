import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_controller.dart';
import '../widgets/accessible_motion.dart';

/// Повторное знакомство с тремя решениями доступно до и после создания питомца.
class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Как играть')),
    body: ref
        .watch(helpProvider)
        .when(
          loading: () => const Center(child: LoadingStatus()),
          error: (error, stack) => Center(
            child: TextButton(
              onPressed: () => ref.invalidate(helpProvider),
              child: const Text('Не удалось открыть подсказки. Повторить'),
            ),
          ),
          data: (topics) => ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: topics.length,
            separatorBuilder: (_, _) => const SizedBox(height: 20),
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topics[index].title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(topics[index].text),
              ],
            ),
          ),
        ),
  );
}
