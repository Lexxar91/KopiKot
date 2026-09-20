import 'package:isar_community/isar.dart';

import 'profile_record.dart';
import 'app_settings_record.dart';
import '../../domain/rules/game_rules.dart';

/// Владеет подключением Isar и предоставляет атомарное чтение-изменение-запись.
class LocalGameStore {
  LocalGameStore._(this._isar);

  final Isar _isar;

  static Future<LocalGameStore> open({
    required String directory,
    String name = 'finny',
  }) async {
    final Isar isar = await Isar.open(
      [ProfileRecordSchema, AppSettingsRecordSchema],
      directory: directory,
      name: name,
      inspector: false,
    );
    return LocalGameStore._(isar);
  }

  Future<int> _activeId() async =>
      (await _isar.appSettingsRecords.get(1))?.testProfile == true ? 2 : 1;

  Future<ProfileRecord?> readProfile() =>
      _isar.txn(() async => _isar.profileRecords.get(await _activeId()));

  Future<ProfileRecord> updateProfile(
    ProfileRecord Function(ProfileRecord? current) update,
  ) => _isar.writeTxn(() async {
    final id = await _activeId();
    final ProfileRecord? current = await _isar.profileRecords.get(id);
    final ProfileRecord next = update(current)..id = id;
    await _isar.profileRecords.put(next);
    return next;
  });

  /// Создание тестового профиля и его выбор фиксируются вместе.
  Future<ProfileRecord?> switchProfile({
    required bool testProfile,
    required ProfileRecord? Function(ProfileRecord?) prepare,
  }) => _isar.writeTxn(() async {
    final id = testProfile ? 2 : 1;
    final next = prepare(await _isar.profileRecords.get(id));
    if (next != null) {
      next.id = id;
      await _isar.profileRecords.put(next);
    }
    final settings =
        await _isar.appSettingsRecords.get(1) ?? AppSettingsRecord();
    settings.testProfile = testProfile;
    await _isar.appSettingsRecords.put(settings);
    return next;
  });

  /// Сброс не читает и не изменяет обычное сохранение.
  Future<ProfileRecord> resetTestProfile(ProfileRecord initial) =>
      _isar.writeTxn(() async {
        if (await _activeId() != 2) {
          throw const GameRuleException('Сначала открой тестовый профиль.');
        }
        initial.id = 2;
        await _isar.profileRecords.put(initial);
        return initial;
      });

  /// Удаляет весь агрегат обычного профиля; тестовый сбрасывается отдельно.
  Future<void> deleteRegularProfile() => _isar.writeTxn(() async {
    if (await _activeId() != 1) {
      throw const GameRuleException(
        'Вернись в обычный профиль перед удалением.',
      );
    }
    await _isar.profileRecords.delete(1);
  });

  Future<bool> readReduceMotion() async =>
      (await _isar.appSettingsRecords.get(1))?.reduceMotion ?? false;

  Future<void> saveReduceMotion(bool value) => _isar.writeTxn(() async {
    final settings =
        await _isar.appSettingsRecords.get(1) ?? AppSettingsRecord();
    settings.reduceMotion = value;
    await _isar.appSettingsRecords.put(settings);
  });

  Future<void> close() async {
    await _isar.close();
  }
}
