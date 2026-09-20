# Сторонние библиотеки и лицензии

Автоматический снимок установленных зависимостей: Flutter 3.47.2,
Dart 3.13.2. Включены 92 пакета Pub и
49 компонентов разрешённого `debugRuntimeClasspath`.
Источник версий — `pubspec.lock` и локальный граф Gradle; тексты взяты из
установленных пакетов/POM, а не из текущей главной ветки их репозиториев.

## Границы и оставшиеся проверки

Это реестр зависимостей и уведомлений, **не заключение о полной лицензионной
готовности APK**. Нативные компоненты внутри `libisar.so`, полный набор
дополнительных NOTICE и финальная release-сборка требуют отдельной сверки.
Уже найденные декларации Isar/libmdbx и их различия описаны в
[проверке нативных источников](native_licenses.md).
Права и условия распространения собственного кода/рисунков определяет команда;
лицензия проекта пока не выбрана. Публикация ещё не выполнена.

Прямая зависимость указана в `dependencies`, прямая dev — в `dev_dependencies`.
Остальные пакеты косвенные. «Связь с основными» означает достижимость по графу
из `dependencies`, не доказательство включения всего пакета в APK. Граф содержит
другие платформы и тестовые пакеты, которые могут быть зависимостями библиотек.
Метки BSD/MIT/Apache служат указателем по основному LICENSE; условия и авторство
смотрите в полном тексте. Для `flutter_test` используется общий LICENSE SDK,
на который ссылаются его исходники. `sky_engine` содержит много разных лицензий.

Полные тексты сохранены рядом в `docs/licenses`, их контрольные суммы — в
[машиночитаемом реестре](licenses/manifest.json). Исходные тексты не изменялись.
Графика, шрифты и отсутствие звуков описаны в [реестре материалов](assets.md).

## Пакеты Pub

| Пакет / версия | Роль | Связь с основными | Основной LICENSE |
| --- | --- | --- | --- |
| `_fe_analyzer_shared 96.0.0` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/_fe_analyzer_shared.txt) |
| `analyzer 10.2.0` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/analyzer.txt) |
| `args 2.7.0` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/args.txt) |
| `async 2.13.1` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/async.txt) |
| `boolean_selector 2.1.2` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/boolean_selector.txt) |
| `build 4.0.7` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/build.txt) |
| `build_config 1.3.3` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/build_config.txt) |
| `build_daemon 4.1.6` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/build_daemon.txt) |
| `build_runner 2.15.1` | Прямая dev | Только dev | [BSD-3-Clause](licenses/pub/build_runner.txt) |
| `built_collection 5.1.1` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/built_collection.txt) |
| `built_value 8.13.0` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/built_value.txt) |
| `characters 1.4.1` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/characters.txt) |
| `checked_yaml 2.0.4` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/checked_yaml.txt) |
| `clock 1.1.3` | Косвенная | Есть | [Apache-2.0](licenses/pub/clock.txt) |
| `code_assets 1.2.1` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/code_assets.txt) |
| `collection 1.19.1` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/collection.txt) |
| `convert 3.1.2` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/convert.txt) |
| `crypto 3.0.7` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/crypto.txt) |
| `dart_style 3.1.7` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/dart_style.txt) |
| `dartx 1.2.0` | Косвенная | Только dev | [Apache-2.0](licenses/pub/dartx.txt) |
| `fake_async 1.3.3` | Косвенная | Есть | [Apache-2.0](licenses/pub/fake_async.txt) |
| `ffi 2.2.0` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/ffi.txt) |
| `file 7.0.1` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/file.txt) |
| `fixnum 1.1.1` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/fixnum.txt) |
| `flutter 0.0.0 (SDK)` | Прямая | Есть | [BSD-3-Clause](licenses/pub/flutter.txt) |
| `flutter_lints 6.0.0` | Прямая dev | Только dev | [BSD-3-Clause](licenses/pub/flutter_lints.txt) |
| `flutter_riverpod 3.4.3` | Прямая | Есть | [MIT](licenses/pub/flutter_riverpod.txt) |
| `flutter_test 0.0.0 (SDK)` | Прямая dev | Есть | [BSD-3-Clause](licenses/pub/flutter_test.txt) |
| `glob 2.2.0` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/glob.txt) |
| `graphs 2.3.2` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/graphs.txt) |
| `hooks 2.0.2` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/hooks.txt) |
| `http_multi_server 3.2.2` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/http_multi_server.txt) |
| `http_parser 4.1.2` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/http_parser.txt) |
| `io 1.1.0` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/io.txt) |
| `isar_community 3.3.2` | Прямая | Есть | [Apache-2.0](licenses/pub/isar_community.txt) |
| `isar_community_flutter_libs 3.3.2` | Прямая | Есть | [Apache-2.0](licenses/pub/isar_community_flutter_libs.txt) |
| `isar_community_generator 3.3.2` | Прямая dev | Только dev | [Apache-2.0](licenses/pub/isar_community_generator.txt) |
| `jni 1.0.3` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/jni.txt) |
| `jni_flutter 1.0.3` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/jni_flutter.txt) |
| `jni_util 1.0.0` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/jni_util.txt) |
| `js 0.7.2` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/js.txt) |
| `json_annotation 4.12.0` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/json_annotation.txt) |
| `leak_tracker 11.0.2` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/leak_tracker.txt) |
| `leak_tracker_flutter_testing 3.0.10` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/leak_tracker_flutter_testing.txt) |
| `leak_tracker_testing 3.0.2` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/leak_tracker_testing.txt) |
| `lints 6.1.0` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/lints.txt) |
| `listen 1.0.1` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/listen.txt) |
| `logging 1.3.0` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/logging.txt) |
| `matcher 0.12.20` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/matcher.txt) |
| `material_color_utilities 0.13.0` | Косвенная | Есть | [Apache-2.0](licenses/pub/material_color_utilities.txt) |
| `meta 1.18.3` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/meta.txt) |
| `mime 2.1.0` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/mime.txt) |
| `objective_c 9.5.0` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/objective_c.txt) |
| `package_config 2.2.0` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/package_config.txt) |
| `path 1.9.1` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/path.txt) |
| `path_provider 2.1.6` | Прямая | Есть | [BSD-3-Clause](licenses/pub/path_provider.txt) |
| `path_provider_android 2.3.1` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/path_provider_android.txt) |
| `path_provider_foundation 2.6.0` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/path_provider_foundation.txt) |
| `path_provider_linux 2.2.2` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/path_provider_linux.txt) |
| `path_provider_platform_interface 2.1.3` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/path_provider_platform_interface.txt) |
| `path_provider_windows 2.3.0` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/path_provider_windows.txt) |
| `platform 3.2.0` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/platform.txt) |
| `plugin_platform_interface 2.1.8` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/plugin_platform_interface.txt) |
| `pool 1.5.3` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/pool.txt) |
| `pub_semver 2.2.1` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/pub_semver.txt) |
| `pubspec_parse 1.6.0` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/pubspec_parse.txt) |
| `record_use 0.6.0` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/record_use.txt) |
| `riverpod 3.4.3` | Косвенная | Есть | [MIT](licenses/pub/riverpod.txt) |
| `shelf 1.4.2` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/shelf.txt) |
| `shelf_web_socket 3.0.0` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/shelf_web_socket.txt) |
| `sky_engine 0.0.0 (SDK)` | Косвенная | Есть | [Сборник лицензий движка](licenses/pub/sky_engine.txt) |
| `source_gen 4.2.4` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/source_gen.txt) |
| `source_span 1.10.2` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/source_span.txt) |
| `stack_trace 1.12.2` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/stack_trace.txt) |
| `state_notifier 1.0.0` | Косвенная | Есть | [MIT](licenses/pub/state_notifier.txt) |
| `stream_channel 2.1.4` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/stream_channel.txt) |
| `stream_transform 2.1.2` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/stream_transform.txt) |
| `string_scanner 1.4.1` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/string_scanner.txt) |
| `term_glyph 1.2.2` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/term_glyph.txt) |
| `test_api 0.7.12` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/test_api.txt) |
| `time 2.1.6` | Косвенная | Только dev | [MIT](licenses/pub/time.txt) |
| `typed_data 1.4.0` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/typed_data.txt) |
| `uuid 4.6.0` | Косвенная | Есть | [MIT](licenses/pub/uuid.txt) |
| `vector_math 2.4.0` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/vector_math.txt) |
| `vm_service 15.3.0` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/vm_service.txt) |
| `watcher 1.2.1` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/watcher.txt) |
| `web 1.1.1` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/web.txt) |
| `web_socket 1.0.1` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/web_socket.txt) |
| `web_socket_channel 3.0.3` | Косвенная | Только dev | [BSD-3-Clause](licenses/pub/web_socket_channel.txt) |
| `xdg_directories 1.1.0` | Косвенная | Есть | [BSD-3-Clause](licenses/pub/xdg_directories.txt) |
| `xxh3 1.2.0` | Косвенная | Только dev | [MIT](licenses/pub/xxh3.txt) |
| `yaml 3.1.4` | Косвенная | Есть | [MIT](licenses/pub/yaml.txt) |

Версия `0.0.0` у SDK-пакетов — техническое значение Pub, не версия Flutter.
Точная версия SDK указана выше и вместе с revision сохранена в JSON.

## Android: разрешённые компоненты debug

Названия лицензий ниже скопированы из локального POM или его родителя;
цепочка родительских POM сохранена в JSON вместе с контрольными суммами.
POM — декларация
поставщика, а не полный сборник NOTICE вложенных библиотек. Ограничения `(c)`
не считаются отдельной библиотекой; при `->` используется выбранная версия.
Для компонентов Flutter без поля licenses явно оставлена отметка о пробеле;
уведомления движка доступны в сборнике `sky_engine` и APK. Gradle-плагины и
системные инструменты сборки не входят в этот runtime-граф.

| Компонент | Декларация лицензии | Источник |
| --- | --- | --- |
| `androidx.activity:activity:1.8.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.activity__activity__1.8.1.pom) |
| `androidx.annotation:annotation:1.8.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.annotation__annotation__1.8.1.pom) |
| `androidx.annotation:annotation-experimental:1.4.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.annotation__annotation-experimental__1.4.0.pom) |
| `androidx.annotation:annotation-jvm:1.8.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.annotation__annotation-jvm__1.8.1.pom) |
| `androidx.arch.core:core-common:2.2.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.arch.core__core-common__2.2.0.pom) |
| `androidx.arch.core:core-runtime:2.2.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.arch.core__core-runtime__2.2.0.pom) |
| `androidx.collection:collection:1.1.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.collection__collection__1.1.0.pom) |
| `androidx.concurrent:concurrent-futures:1.1.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.concurrent__concurrent-futures__1.1.0.pom) |
| `androidx.core:core:1.13.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.core__core__1.13.1.pom) |
| `androidx.core:core-ktx:1.13.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.core__core-ktx__1.13.1.pom) |
| `androidx.customview:customview:1.0.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.customview__customview__1.0.0.pom) |
| `androidx.exifinterface:exifinterface:1.4.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.exifinterface__exifinterface__1.4.1.pom) |
| `androidx.fragment:fragment:1.7.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.fragment__fragment__1.7.1.pom) |
| `androidx.interpolator:interpolator:1.0.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.interpolator__interpolator__1.0.0.pom) |
| `androidx.lifecycle:lifecycle-common:2.7.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.lifecycle__lifecycle-common__2.7.0.pom) |
| `androidx.lifecycle:lifecycle-common-java8:2.7.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.lifecycle__lifecycle-common-java8__2.7.0.pom) |
| `androidx.lifecycle:lifecycle-livedata:2.7.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.lifecycle__lifecycle-livedata__2.7.0.pom) |
| `androidx.lifecycle:lifecycle-livedata-core:2.7.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.lifecycle__lifecycle-livedata-core__2.7.0.pom) |
| `androidx.lifecycle:lifecycle-livedata-core-ktx:2.7.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.lifecycle__lifecycle-livedata-core-ktx__2.7.0.pom) |
| `androidx.lifecycle:lifecycle-process:2.7.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.lifecycle__lifecycle-process__2.7.0.pom) |
| `androidx.lifecycle:lifecycle-runtime:2.7.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.lifecycle__lifecycle-runtime__2.7.0.pom) |
| `androidx.lifecycle:lifecycle-viewmodel:2.7.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.lifecycle__lifecycle-viewmodel__2.7.0.pom) |
| `androidx.lifecycle:lifecycle-viewmodel-savedstate:2.7.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.lifecycle__lifecycle-viewmodel-savedstate__2.7.0.pom) |
| `androidx.loader:loader:1.0.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.loader__loader__1.0.0.pom) |
| `androidx.profileinstaller:profileinstaller:1.3.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.profileinstaller__profileinstaller__1.3.1.pom) |
| `androidx.savedstate:savedstate:1.2.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.savedstate__savedstate__1.2.1.pom) |
| `androidx.startup:startup-runtime:1.1.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.startup__startup-runtime__1.1.1.pom) |
| `androidx.tracing:tracing:1.2.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.tracing__tracing__1.2.0.pom) |
| `androidx.versionedparcelable:versionedparcelable:1.1.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.versionedparcelable__versionedparcelable__1.1.1.pom) |
| `androidx.viewpager:viewpager:1.0.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.viewpager__viewpager__1.0.0.pom) |
| `androidx.window:window:1.2.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.window__window__1.2.0.pom) |
| `androidx.window:window-java:1.2.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.window__window-java__1.2.0.pom) |
| `androidx.window.extensions.core:core:1.0.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/androidx.window.extensions.core__core__1.0.0.pom) |
| `com.getkeepsafe.relinker:relinker:1.4.5` | The Apache Software License, Version 2.0 | [POM](licenses/android/com.getkeepsafe.relinker__relinker__1.4.5.pom) |
| `com.google.guava:listenablefuture:1.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/com.google.guava__listenablefuture__1.0.pom) |
| `io.flutter:arm64_v8a_debug:1.0.0-a804b261645ef8c13eb3d5c44a5c2fb0340c5539` | В POM не указана — требуется отдельная сверка | [POM](licenses/android/io.flutter__arm64_v8a_debug__1.0.0-a804b261645ef8c13eb3d5c44a5c2fb0340c5539.pom) |
| `io.flutter:armeabi_v7a_debug:1.0.0-a804b261645ef8c13eb3d5c44a5c2fb0340c5539` | В POM не указана — требуется отдельная сверка | [POM](licenses/android/io.flutter__armeabi_v7a_debug__1.0.0-a804b261645ef8c13eb3d5c44a5c2fb0340c5539.pom) |
| `io.flutter:flutter_embedding_debug:1.0.0-a804b261645ef8c13eb3d5c44a5c2fb0340c5539` | В POM не указана — требуется отдельная сверка | [POM](licenses/android/io.flutter__flutter_embedding_debug__1.0.0-a804b261645ef8c13eb3d5c44a5c2fb0340c5539.pom) |
| `io.flutter:x86_64_debug:1.0.0-a804b261645ef8c13eb3d5c44a5c2fb0340c5539` | В POM не указана — требуется отдельная сверка | [POM](licenses/android/io.flutter__x86_64_debug__1.0.0-a804b261645ef8c13eb3d5c44a5c2fb0340c5539.pom) |
| `org.jetbrains:annotations:23.0.0` | The Apache Software License, Version 2.0 | [POM](licenses/android/org.jetbrains__annotations__23.0.0.pom) |
| `org.jetbrains.kotlin:kotlin-stdlib:2.4.0` | Apache-2.0 | [POM](licenses/android/org.jetbrains.kotlin__kotlin-stdlib__2.4.0.pom) |
| `org.jetbrains.kotlin:kotlin-stdlib-common:2.4.0` | Apache-2.0 | [POM](licenses/android/org.jetbrains.kotlin__kotlin-stdlib-common__2.4.0.pom) |
| `org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.8.20` | The Apache License, Version 2.0 | [POM](licenses/android/org.jetbrains.kotlin__kotlin-stdlib-jdk7__1.8.20.pom) |
| `org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.8.20` | The Apache License, Version 2.0 | [POM](licenses/android/org.jetbrains.kotlin__kotlin-stdlib-jdk8__1.8.20.pom) |
| `org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/org.jetbrains.kotlinx__kotlinx-coroutines-android__1.7.1.pom) |
| `org.jetbrains.kotlinx:kotlinx-coroutines-bom:1.7.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/org.jetbrains.kotlinx__kotlinx-coroutines-bom__1.7.1.pom) |
| `org.jetbrains.kotlinx:kotlinx-coroutines-core:1.7.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/org.jetbrains.kotlinx__kotlinx-coroutines-core__1.7.1.pom) |
| `org.jetbrains.kotlinx:kotlinx-coroutines-core-jvm:1.7.1` | The Apache Software License, Version 2.0 | [POM](licenses/android/org.jetbrains.kotlinx__kotlinx-coroutines-core-jvm__1.7.1.pom) |
| `org.jspecify:jspecify:1.0.0` | The Apache License, Version 2.0 | [POM](licenses/android/org.jspecify__jspecify__1.0.0.pom) |

## Уведомления проверочной APK-сборки

Из `app-debug.apk` извлечён неизменённый после распаковки
[NOTICES](licenses/APK_NOTICES.txt). Этот файл содержит сведения Flutter и
пакетов, в том числе используемых при разработке; это не точный список
всех исполняемых компонентов Android.

SHA-256 APK: `07238d28ec8353bd451d0b8a05ed1b1b8c2dd829e68da2f422dab3aa15ac4d02`.
SHA-256 распакованного NOTICES: `8445ac5d6fef4f82fc5d1c518ad78f0214478abe0c691d14a15d3dd5acdb3573`.
SHA-256 pubspec.lock: `d9b5d8fb7d44f93535d35b2bf2980c0053b179795f5eba261ea86a1eb3b99478`.

После смены SDK, зависимостей или сборки повторить экспорт и проверку.

## Воспроизведение

Из корня проекта, при уже установленных Flutter, JDK 21 и зависимостях:

```bash
JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64 python3 -B tool/export_third_party.py
python3 -B -m unittest discover -s tool -p 'test_third_party.py' -v
```

Скрипт читает `flutter pub deps --json`, `pubspec.lock`, package_config и локальные
LICENSE; запускает Gradle с `--offline` для `debugRuntimeClasspath`, читает
кеш POM и распаковывает NOTICES указанного APK. Ничего не устанавливает.
Без нужных кешированных метаданных экспорт завершится ошибкой, а не подменой версии.
`--check` проверяет актуальность без перезаписи реестра. Иной APK можно передать `--apk PATH`,
но Android-граф этого скрипта всё равно debug: это не готовый экспорт для release.
