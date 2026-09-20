# Flutter и Android на Ubuntu

## Текущее состояние

Обновлено 17 сентября 2026 года. Пользователь установил зависимости; его вывод
`flutter doctor -v` подтверждает Ubuntu 26.04.1 x86_64, Flutter stable 3.47.2,
Dart 3.13.2, Android SDK / Build-Tools 36.0.0 и JDK 21.0.12. Лицензии Android
приняты. Flutter использует `/usr/lib/jvm/java-21-openjdk-amd64`, независимо от
общесистемной Java 25. Android-каркас создан, пакеты разрешены (`pubspec.lock`).

Сейчас для запуска из корня проекта достаточно `flutter pub get`,
`flutter devices`, `flutter run -d DEVICE_ID` (ID Android-телефона/эмулятора).
Разделы установки ниже нужны при подготовке нового окружения.
Проверка `dart analyze` у пользователя прошла; `flutter analyze` ранее падал внутри
LSP-канала. Причина падения не доказана; кириллица в пути была только гипотезой.
Linux desktop toolchain не нужен для разработки Android-приложения на Ubuntu.

Первая APK-сборка дополнительно установила NDK `28.2.13676358` (версия из Flutter),
платформу Android 35 и CMake 3.22.1. Для нового окружения их можно поставить так:

```bash
sdkmanager --sdk_root=/home/dmitriy/Android/Sdk "ndk;28.2.13676358" "platforms;android-35" "cmake;3.22.1"
```

Isar Android-модуль использует `compileSdkVersion 35`; SDK 36 при этом остаётся.
Предупреждение `Still waiting for package manifests` означает ожидание сетевого
каталога; успех установки подтверждается завершением команды, а не этим сообщением.

Это подготовка Android-приложения. Отдельно устанавливать Dart не нужно:
он входит в Flutter SDK. Инструкции основаны на
[установке Flutter](https://docs.flutter.dev/install/manual) и
[настройке Android](https://docs.flutter.dev/platform-integration/android/setup).

## 1. Системные пакеты

В терминале:

```bash
sudo apt update
sudo apt install git curl unzip xz-utils zip libglu1-mesa openjdk-21-jdk
```

Пакет `openjdk-21-jdk` доступен в подключённых репозиториях этой Ubuntu.
Вместо установленной Java 25 для Flutter используем JDK 21: Java 25 требует
Gradle 9.1 или новее, а Java 21 поддерживается с Gradle 8.5.
Источник: [матрица совместимости Gradle](https://docs.gradle.org/current/userguide/compatibility.html).
Общесистемную Java переключать не нужно — ниже задаётся JDK только для Flutter.

## 2. Flutter SDK

Откройте [официальный архив Flutter](https://docs.flutter.dev/install/archive),
выберите **Linux → stable → x64** и скачайте архив `.tar.xz`.
Для зависимостей проекта нужен Flutter с Dart **3.12 или новее**.

Создайте каталог:

```bash
mkdir -p /home/dmitriy/development
```

Распакуйте скачанный архив в этот каталог через файловый менеджер.
Результирующий путь должен быть `/home/dmitriy/development/flutter/bin/flutter`.

Откройте `/home/dmitriy/.bashrc` в редакторе и добавьте строку один раз:

```bash
export PATH="/home/dmitriy/development/flutter/bin:$PATH"
```

Затем в терминале:

```bash
source /home/dmitriy/.bashrc
flutter --version
dart --version
flutter config --jdk-dir=/usr/lib/jvm/java-21-openjdk-amd64
```

Первый запуск может загружать дополнительные файлы. Перезапустите IDE, чтобы она
увидела новый PATH. Если IDE попросит путь к Flutter SDK, укажите
`/home/dmitriy/development/flutter`.

## 3. Android SDK

Скачайте Linux-версию [Android Studio](https://developer.android.com/studio)
и установите по [официальной инструкции](https://developer.android.com/studio/install).
Запустите мастер первоначальной настройки. Android Studio удобно использовать
для SDK и эмулятора, а писать код можно в текущей IDE.

В **More Actions → SDK Manager**:

1. На вкладке **SDK Platforms** установите Android API 36.
2. На вкладке **SDK Tools** установите Android SDK Platform-Tools,
   Android SDK Command-line Tools (latest), Android SDK Build-Tools,
   NDK (Side by side) и CMake. Android Emulator нужен при запуске на эмуляторе.
3. Нажмите **Apply** и дождитесь завершения загрузок.

Если созданный Flutter-проект запросит другую версию SDK или NDK,
установите именно её через SDK Manager: версии определяет установленный Flutter.

Укажите каталог SDK (ниже стандартный путь; проверьте его в SDK Manager):

```bash
flutter config --android-sdk=/home/dmitriy/Android/Sdk
flutter doctor --android-licenses
flutter doctor -v
```

Команда лицензий покажет условия — прочитайте их и подтвердите принятие в терминале.
В `flutter doctor` важны успешные проверки Flutter и Android toolchain.
Замечания о Chrome или Linux desktop не блокируют Android-сборку.

## 4. Инициализация проекта и зависимости

Исходники лежат в каталоге с пробелами и кириллицей. Если Android/Gradle выдаст
ошибку пути, перенесите проект, например, в `/home/dmitriy/development/KopiKot`
и откройте новое расположение в IDE.

В текущем расположении выполните:

```bash
cd '/home/dmitriy/Рабочий стол/KopiKot'
flutter pub get
dart format lib
dart analyze
flutter test
```

Android-обвязка уже есть в репозитории, повторять `flutter create` не нужно.
Идентификатор по умолчанию `com.example.kopikot`
нужно заменить своим перед финальной сдачей: уникальное имя пакета требуется ТЗ.

В `android/app/build.gradle.kts` уже задан
`minSdk = 26` — это минимальный Android 8.0 по ТЗ. `compileSdk` и `targetSdk`
не нужно понижать до 26: они отвечают за другие параметры сборки.
Проверьте, что зависимости не требуют более нового минимального Android.

После настройки соберите проверочный APK:

```bash
flutter build apk --debug
```

В `pubspec.yaml` уже указаны все зависимости основы. Pub подбирает совместимые
версии в заданных диапазонах; разрешение зависимостей выполнено.
Не обходите ошибки разрешения с помощью `dependency_overrides` — при конфликте
нужно подобрать совместимые версии генератора и `build_runner` по тексту ошибки.
После успешной загрузки сохраните `pubspec.lock` в Git.

Isar не требует отдельного сервера: его нативное ядро поставляется пакетом
`isar_community_flutter_libs`. После изменения коллекций запускайте:

```bash
dart run build_runner build
```

Генератор создаёт схемы `*.g.dart` из классов `@collection`.
Коллекция `ProfileRecord` уже реализована, сгенерированная схема хранится рядом. Документация:
[Isar Community](https://pub.dev/packages/isar_community).

## 5. Запуск

На телефоне включите режим разработчика и отладку по USB, подключите его кабелем
и разрешите отладку. Или создайте виртуальный телефон в **Device Manager** Android Studio
и запустите его.

```bash
flutter devices
flutter run
```

Если устройств несколько, используйте `flutter run -d DEVICE_ID`, подставив
идентификатор из `flutter devices`.

Для тестов правил, репозитория и интерфейса запускайте `flutter test`.
Наличие стартового экрана само по себе ещё не подтверждает работу локальной базы:
сохранение после перезапуска проверено в тестах Isar, а на телефоне его нужно
проверить по [протоколу Android-приёмки](device_test_report.md).

## 6. Релизная сборка для сдачи

ТЗ требует подписанный release APK, устанавливаемый без IDE. Этот этап выполняется
после реализации и проверки игрового сценария; текущий этап ещё не финальная сборка.
Полная инструкция подписи: [Android release в Flutter](https://docs.flutter.dev/deployment/android#sign-the-app).

1. Выберите уникальный `applicationId` команды, обновите `namespace` и пакет
   `MainActivity` согласованно. `com.example.kopikot` не оставляйте для сдачи.
2. Создайте и сохраните ключ подписи вне репозитория. Например, если этого файла
   ещё нет, выполните команду ниже. Пароль введите в интерактивном запросе:

   ```bash
   keytool -genkeypair -v -keystore /home/dmitriy/kopikot-release.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias kopikot
   ```

3. Создайте локальный `android/key.properties` в UTF-8 по образцу
   `android/key.properties.example`. Укажите абсолютный путь `storeFile`,
   `storePassword`, `keyAlias=kopikot` и `keyPassword`. Пароли вводите только
   локально, не отправляйте их в чат и не публикуйте. Ограничьте доступ:

   ```bash
   chmod 600 android/key.properties
   chmod 600 /home/dmitriy/kopikot-release.jks
   ```

   Во второй команде подставьте свой путь к уже созданному ключу. Сохраните
   защищённую резервную копию ключа и паролей вне репозитория. Файл свойств и
   расширения `.jks`, `.keystore`, `.p12` исключены из Git.
4. Настройка `signingConfigs.release` уже подключена. Release не использует
   debug-ключ: задача `verifyReleaseSigning` проверяет постоянный applicationId,
   наличие свойств и файла ключа, затем Android проверяет подпись. Сам ключ пока
   не создан, имя пакета остаётся шаблонным до решения команды. Debug-сборка
   не требует `key.properties`.

   Предварительная проверка без сборки APK, из корня проекта:

   ```bash
   cd android
   JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64 ./gradlew app:verifyReleaseSigning
   cd ..
   ```

   До заполнения настроек команда ожидаемо завершается ошибкой «Release не настроен».
   Успех этой предварительной проверки ещё не доказывает корректность пароля
   или сертификата: это выясняется при подписи APK и последующей проверке.
5. Проверьте версию в `pubspec.yaml` (сейчас `0.1.0+1`) и выполните:

   ```bash
   flutter analyze
   flutter test
   flutter build apk --release
   ```

   Тесты игры уже добавлены. Если `flutter analyze` снова падает внутри LSP,
   используйте `dart analyze` и отдельно сохраните сообщение о сбое инструмента.

Файл для установки: `build/app/outputs/flutter-apk/app-release.apk`.
Перед сдачей проверьте подпись утилитой `apksigner verify --verbose --print-certs`
из установленной версии Android SDK Build-Tools, передав ей путь к APK.
Сверьте сертификат с собственным ключом, затем установите APK на физический телефон
и пройдите [сценарий проверки](requirements.md). Успешная сборка сама по себе
не подтверждает сохранение прогресса, работу офлайн или все требования ТЗ.

В отчёте зафиксируйте `flutter --version`, `dart --version`, `flutter doctor -v`,
версии Android SDK/Gradle, версию APK и результаты проверки устройства.
Результаты выполненных проверок: [verification.md](verification.md).
Релизная подпись и проверка на устройстве ещё не выполнены.
