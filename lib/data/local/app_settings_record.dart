import 'package:isar_community/isar.dart';

part 'app_settings_record.g.dart';

/// Выбор профиля переживает перезапуск; отсутствие записи означает обычный режим.
@collection
class AppSettingsRecord {
  Id id = 1;
  bool testProfile = false;
  bool reduceMotion = false;
}
