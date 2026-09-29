# КопиКот

Офлайн-игра для детей 7–11 лет о финансовых решениях и заботе о виртуальном
питомце. Android 8.0+, без регистрации, рекламы и реальных платежей.

## Материалы для ревью

- [Скачать подписанный APK](https://disk.yandex.ru/d/8f6emo0GrUkEkQ)
- [Презентация](https://disk.yandex.ru/client/disk/преза)

APK: `com.lexxar91.kopikot`, версия `0.1.0+1`. Для установки нужен Android 8.0
или новее.

## Что реализовано

- Планирование бюджета, покупки, история и накопления на три цели.
- 6 финансовых заданий, котодерево, ветеринар и гардероб питомца.
- Сытость, энергия и радость меняются со временем; прогресс хранится локально.
- Отдельный демопрофиль для проверки игровых дней.

## Запуск из исходников

Нужны Flutter, Android SDK и JDK. Подробная настройка — в [инструкции сборки](docs/setup_ubuntu.md).

```bash
flutter pub get
dart analyze
flutter test
flutter run
```

## Проверка

APK собран в release-режиме, подпись проверена. 

## Документация

- Реализация: [архитектура](docs/architecture.md), [матрица требований](docs/requirements.md), [правила и задания](docs/content_map.md), [учебная основа](docs/educational_basis.md).
- Пользовательские данные и UX: [профили и приватность](docs/data_privacy.md), [доступность](docs/ux_accessibility.md), [графика](docs/assets.md), [контент JSON](assets/content/README.md).
- Проверка и сдача: [сценарий демо](docs/demo_scenario.md), [протокол устройства](docs/device_test_report.md), [отчёт тестов](docs/verification.md), [комплект сдачи](docs/interim_submission.md).
- Сборка и зависимости: [Ubuntu/Android](docs/setup_ubuntu.md), [Pub и Android](docs/third_party.md),[черновик RuStore](docs/store/listing.md).
- Дополнительно: [сборка PDF](docs/delivery/README.md), [исходник презентации](docs/presentation.md).


