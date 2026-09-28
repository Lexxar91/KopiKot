import '../models/game_profile.dart';
import '../models/learning_task.dart';

/// Ступени независимы: успехи в покупках не меняют задания о сбережениях.
abstract final class LearningDifficultyRules {
  static GameProfile choose(
    GameProfile profile,
    String topic,
    LearningDifficulty difficulty,
  ) {
    if (profile.learningTopic(topic).difficulty == difficulty) return profile;
    final next = LearningTopicProgress(topic: topic, difficulty: difficulty);
    return profile.copyWith(
      learningTopics: [
        ...profile.learningTopics.where((entry) => entry.topic != topic),
        next,
      ],
    );
  }

  static GameProfile dismissDowngrade(GameProfile profile, String topic) {
    final old = profile.learningTopic(topic);
    return profile.copyWith(
      learningTopics: [
        ...profile.learningTopics.where((entry) => entry.topic != topic),
        LearningTopicProgress(
          topic: topic,
          difficulty: old.difficulty,
          cleanStreak: old.cleanStreak,
          helpStreak: old.helpStreak,
          downgradeOffered: true,
        ),
      ],
    );
  }

  static GameProfile afterTask(
    GameProfile profile,
    String topic, {
    required bool clean,
  }) {
    final old = profile.learningTopic(topic);
    final cleanStreak = clean ? old.cleanStreak + 1 : 0;
    final helpStreak = clean ? 0 : old.helpStreak + 1;
    final advance =
        cleanStreak >= 2 && old.difficulty != LearningDifficulty.hard;
    final difficulty = advance
        ? LearningDifficulty.values[old.difficulty.index + 1]
        : old.difficulty;
    final offer =
        !clean &&
        helpStreak >= 3 &&
        difficulty != LearningDifficulty.simple &&
        !old.downgradeOffered;
    return profile.copyWith(
      learningTopics: [
        ...profile.learningTopics.where((entry) => entry.topic != topic),
        LearningTopicProgress(
          topic: topic,
          difficulty: difficulty,
          cleanStreak: advance ? 0 : cleanStreak,
          helpStreak: offer ? 0 : helpStreak,
          downgradeOffered: advance ? false : old.downgradeOffered || offer,
          downgradePending: advance ? false : old.downgradePending || offer,
        ),
      ],
    );
  }
}
