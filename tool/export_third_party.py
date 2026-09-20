#!/usr/bin/env python3
"""Экспортирует лицензии установленных пакетов и уведомления выбранного APK.

Не устанавливает пакеты и не выбирает лицензию собственного проекта.
Все выходные файлы в docs/licenses и docs/third_party.md — артефакты экспорта.
"""

import argparse
import gzip
import hashlib
import json
from pathlib import Path
import re
import subprocess
from urllib.parse import unquote, urljoin, urlsplit
import xml.etree.ElementTree as ET
import zipfile


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / 'docs/licenses'


def digest(data):
    return hashlib.sha256(data).hexdigest()


def file_digest(path):
    with path.open('rb') as source:
        return hashlib.file_digest(source, 'sha256').hexdigest()


def installed_roots(config):
    result = {}
    for package in json.loads(config.read_text())['packages']:
        uri = urlsplit(urljoin(config.as_uri(), package['rootUri']))
        if uri.scheme != 'file' or uri.netloc:
            raise ValueError('Ожидался локальный путь установленного пакета')
        result[package['name']] = Path(unquote(uri.path)).resolve()
    return result


def lock_versions(value):
    """Читает только имена/версии из фиксированной структуры pubspec.lock."""
    versions = {}
    name = None
    for line in value.splitlines():
        if match := re.fullmatch(r'  ([a-z_][a-z_0-9]*):', line):
            name = match[1]
        elif match := re.fullmatch(r'    version: "([^"]+)"', line):
            if name is None or name in versions:
                raise ValueError('Неожиданная структура pubspec.lock')
            versions[name] = match[1]
    if not versions:
        raise ValueError('Не найдены версии в pubspec.lock')
    return versions


def reachable(packages, starts):
    found = set()
    pending = list(starts)
    while pending:
        name = pending.pop()
        if name not in found:
            found.add(name)
            pending.extend(packages[name]['dependencies'])
    return found


def license_label(name, data):
    """Навигационная метка основного LICENSE; полный текст остаётся источником."""
    value = data.decode('utf-8')
    if name == 'sky_engine':
        return 'Сборник лицензий движка'
    if 'Apache License' in value and 'Version 2.0' in value:
        return 'Apache-2.0'
    if 'Permission is hereby granted, free of charge' in value:
        return 'MIT'
    if 'Redistribution and use in source and binary forms' in value and 'Neither the name' in value:
        return 'BSD-3-Clause'
    return 'Требует ручной проверки'


def license_source(name, package_root, flutter_sdk):
    source = package_root / 'LICENSE'
    if source.is_file():
        return source, 'LICENSE пакета'
    if name == 'flutter_test' and package_root == flutter_sdk / 'packages/flutter_test':
        return flutter_sdk / 'LICENSE', 'LICENSE корня Flutter SDK'
    raise ValueError(f'Не найден LICENSE пакета {name}; автоматическая подстановка запрещена')


def android_coordinates(report):
    if 'BUILD SUCCESSFUL' not in report or 'FAILED' in report:
        raise ValueError('Gradle не подтвердил разрешение графа')
    coordinates = set()
    for line in report.splitlines():
        if '(c)' in line:
            continue
        match = re.search(r'(?:\+---|\\---) ([\w.\-]+):([\w.\-]+):([^\s]+)(?: -> ([^\s]+))?', line)
        if match:
            coordinates.add((match[1], match[2], match[4] or match[3]))
    if not coordinates:
        raise ValueError('Пустой Android-граф')
    return sorted(coordinates)


def pom_licenses(data):
    root = ET.fromstring(data)
    return [
        {'name': node.findtext('{*}name', ''), 'url': node.findtext('{*}url', '')}
        for node in root.findall('{*}licenses/{*}license')
    ]


def cached_pom(cache, coordinate):
    group, name, version = coordinate
    contents = {p.read_bytes() for p in (cache / group / name / version).glob(f'*/{name}-{version}.pom')}
    if len(contents) != 1:
        raise ValueError(f'Нет однозначного локального POM: {group}:{name}:{version}')
    return contents.pop()


def inherited_licenses(data, cache, files, seen=None):
    """Сохраняет цепочку родительских POM, если лицензия объявлена там."""
    licenses = pom_licenses(data)
    if licenses:
        return licenses, []
    parent = ET.fromstring(data).find('{*}parent')
    if parent is None:
        return [], []
    coordinate = tuple(parent.findtext('{*}' + name, '') for name in ('groupId', 'artifactId', 'version'))
    if not all(re.fullmatch(r'[\w.\-]+', part) for part in coordinate):
        raise ValueError('Неоднозначный координатный путь родительского POM')
    seen = set() if seen is None else set(seen)
    if coordinate in seen:
        raise ValueError('Цикл родительских POM')
    seen.add(coordinate)
    data = cached_pom(cache, coordinate)
    path = 'android/' + '__'.join(coordinate) + '.pom'
    files[path] = data
    licenses, chain = inherited_licenses(data, cache, files, seen)
    return licenses, [{'file': path, 'sha256': digest(data)}] + chain


def collect(graph, roots, lock, sdk, apk, android_report, gradle_cache):
    packages = {p['name']: p for p in graph['packages']}
    root = packages[graph['root']]
    third_party = {k: v for k, v in packages.items() if k != root['name']}
    if {k: v['version'] for k, v in third_party.items()} != lock:
        raise ValueError('Граф Pub не совпадает с pubspec.lock')
    main = reachable(packages, root['directDependencies'])
    files = {}
    rows = []
    for name, package in sorted(third_party.items()):
        if not re.fullmatch(r'[a-z_][a-z_0-9]*', name):
            raise ValueError('Небезопасное имя пакета')
        source, origin = license_source(name, roots[name], sdk)
        data = source.read_bytes()
        path = f'pub/{name}.txt'
        files[path] = data
        direct = name in root['directDependencies']
        dev = name in root['devDependencies']
        rows.append({
            'name': name, 'version': package['version'], 'source': package['source'],
            'role': 'Прямая' if direct else 'Прямая dev' if dev else 'Косвенная',
            'reachable_from_main': name in main,
            'dependencies': package['dependencies'],
            'license': license_label(name, data), 'license_origin': origin,
            'license_file': path, 'license_sha256': digest(data),
        })
    android = []
    for group, name, version in android_coordinates(android_report):
        data = cached_pom(gradle_cache, (group, name, version))
        path = f'android/{group}__{name}__{version}.pom'
        files[path] = data
        licenses, parents = inherited_licenses(data, gradle_cache, files)
        android.append({
            'coordinate': f'{group}:{name}:{version}',
            'licenses': licenses, 'pom_file': path, 'pom_sha256': digest(data),
            'parent_poms': parents,
        })
    with zipfile.ZipFile(apk) as archive:
        notices = gzip.decompress(archive.read('assets/flutter_assets/NOTICES.Z'))
    notices.decode('utf-8')
    files['APK_NOTICES.txt'] = notices
    # Только сведения о версиях SDK: без локальных путей пользователя.
    sdk_version = json.loads((sdk / 'bin/cache/flutter.version.json').read_text())
    manifest = {
        'scope': 'Installed Pub packages and debugRuntimeClasspath; not a complete native SBOM',
        'pubspec_lock_sha256': file_digest(ROOT / 'pubspec.lock'),
        'flutter_version': sdk_version['frameworkVersion'],
        'flutter_revision': sdk_version['frameworkRevision'],
        'engine_revision': sdk_version['engineRevision'],
        'dart_version': sdk_version['dartSdkVersion'],
        'apk_name': apk.name, 'apk_sha256': file_digest(apk),
        'apk_notices_sha256': digest(notices),
        'pub_packages': rows, 'android_components': android,
    }
    files['manifest.json'] = (json.dumps(manifest, ensure_ascii=False, indent=2) + '\n').encode()
    return manifest, files


def report(manifest):
    rows = manifest['pub_packages']
    android = manifest['android_components']
    text = f'''# Сторонние библиотеки и лицензии

Автоматический снимок установленных зависимостей: Flutter {manifest['flutter_version']},
Dart {manifest['dart_version']}. Включены {len(rows)} пакета Pub и
{len(android)} компонентов разрешённого `debugRuntimeClasspath`.
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
'''
    for row in rows:
        label = row['name'] + ' ' + row['version']
        if row['source'] == 'sdk':
            label += ' (SDK)'
        text += f"| `{label}` | {row['role']} | {'Есть' if row['reachable_from_main'] else 'Только dev'} | [{row['license']}](licenses/{row['license_file']}) |\n"
    text += '''
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
'''
    for row in android:
        licenses = '; '.join(item['name'] for item in row['licenses']) or 'В POM не указана — требуется отдельная сверка'
        text += f"| `{row['coordinate']}` | {licenses} | [POM](licenses/{row['pom_file']}) |\n"
    text += f'''
## Уведомления проверочной APK-сборки

Из `{manifest['apk_name']}` извлечён неизменённый после распаковки
[NOTICES](licenses/APK_NOTICES.txt). Этот файл содержит сведения Flutter и
пакетов, в том числе используемых при разработке; это не точный список
всех исполняемых компонентов Android.

SHA-256 APK: `{manifest['apk_sha256']}`.
SHA-256 распакованного NOTICES: `{manifest['apk_notices_sha256']}`.
SHA-256 pubspec.lock: `{manifest['pubspec_lock_sha256']}`.

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
'''
    return text


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apk', type=Path, default=ROOT / 'build/app/outputs/flutter-apk/app-debug.apk')
    parser.add_argument('--gradle-cache', type=Path, default=Path.home() / '.gradle/caches/modules-2/files-2.1')
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    roots = installed_roots(ROOT / '.dart_tool/package_config.json')
    sdk = roots['flutter'].parents[1]
    graph = json.loads(subprocess.check_output([str(sdk / 'bin/flutter'), 'pub', 'deps', '--json'], cwd=ROOT, text=True))
    gradle = subprocess.run([
        './gradlew', 'app:dependencies', '--configuration', 'debugRuntimeClasspath', '--offline', '--console=plain',
    ], cwd=ROOT / 'android', capture_output=True, text=True, timeout=55)
    if gradle.returncode:
        raise SystemExit(gradle.stderr[-1500:] + gradle.stdout[-1500:])
    manifest, files = collect(graph, roots, lock_versions((ROOT / 'pubspec.lock').read_text()),
                              sdk, args.apk, gradle.stdout, args.gradle_cache)
    outputs = {OUTPUT / name: data for name, data in files.items()}
    outputs[ROOT / 'docs/third_party.md'] = report(manifest).encode()
    if args.check:
        stale = [str(path.relative_to(ROOT)) for path, data in outputs.items()
                 if not path.is_file() or path.read_bytes() != data]
        if stale:
            raise SystemExit('Устаревшие файлы: ' + ', '.join(stale))
        print('Реестр, лицензии и NOTICES соответствуют текущим входным данным')
    else:
        for path, data in outputs.items():
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)
        print(f"Экспорт: {len(manifest['pub_packages'])} пакета Pub, {len(manifest['android_components'])} компонентов Android")


if __name__ == '__main__':
    main()
