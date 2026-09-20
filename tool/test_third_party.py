"""Проверяет реестр на локальных данных, без сети и запуска Gradle."""

import gzip
import json
from pathlib import Path
import tempfile
import unittest
import zipfile

from export_third_party import (
    OUTPUT, ROOT, android_coordinates, digest, inherited_licenses,
    installed_roots, license_source, lock_versions, reachable,
)


class ThirdPartyTest(unittest.TestCase):
    def test_graph_cycles_and_main_reachability(self):
        packages = {'a': {'dependencies': ['b']}, 'b': {'dependencies': ['a']},
                    'dev': {'dependencies': []}}
        self.assertEqual(reachable(packages, ['a']), {'a', 'b'})
        with self.assertRaises(KeyError):
            reachable(packages, ['missing'])

    def test_lock_versions(self):
        value = 'packages:\n  foo:\n    version: "1.2.3"\n  flutter:\n    version: "0.0.0"\nsdks:\n  dart: ">=3.0.0"'
        self.assertEqual(lock_versions(value), {'foo': '1.2.3', 'flutter': '0.0.0'})
        with self.assertRaises(ValueError):
            lock_versions('empty')

    def test_gradle_selected_versions_and_constraints(self):
        value = '''+--- org.example:one:1.0 -> 2.0
|    +--- org.example:one:2.0 (*)
|    +--- org.example:constraint:3.0 (c)
\\--- project :plugin
BUILD SUCCESSFUL in 2s'''
        self.assertEqual(android_coordinates(value), [('org.example', 'one', '2.0')])
        for value in ('BUILD FAILED', '+--- org.example:one:1.0', 'BUILD SUCCESSFUL'):
            with self.assertRaises(ValueError):
                android_coordinates(value)

    def test_missing_license_does_not_inherit_arbitrary_parent(self):
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaises(ValueError):
                license_source('unknown', Path(directory), Path(directory))

    def test_parent_pom_license_keeps_evidence(self):
        with tempfile.TemporaryDirectory() as directory:
            cache = Path(directory)
            path = cache / 'org.example/parent/1/hash/parent-1.pom'
            path.parent.mkdir(parents=True)
            data = b'<project><licenses><license><name>Apache-2.0</name></license></licenses></project>'
            path.write_bytes(data)
            child = b'<project><parent><groupId>org.example</groupId><artifactId>parent</artifactId><version>1</version></parent></project>'
            files = {}
            licenses, parents = inherited_licenses(child, cache, files)
            self.assertEqual(licenses[0]['name'], 'Apache-2.0')
            self.assertEqual(parents[0]['sha256'], digest(data))
            self.assertEqual(files[parents[0]['file']], data)

    def test_parent_pom_cycle_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            cache = Path(directory)
            path = cache / 'org.example/parent/1/hash/parent-1.pom'
            path.parent.mkdir(parents=True)
            data = b'<project><parent><groupId>org.example</groupId><artifactId>parent</artifactId><version>1</version></parent></project>'
            path.write_bytes(data)
            with self.assertRaises(ValueError):
                inherited_licenses(data, cache, {})

    def test_export_matches_lock_and_original_licenses(self):
        manifest = json.loads((OUTPUT / 'manifest.json').read_text())
        rows = manifest['pub_packages']
        self.assertEqual({r['name']: r['version'] for r in rows},
                         lock_versions((ROOT / 'pubspec.lock').read_text()))
        roots = installed_roots(ROOT / '.dart_tool/package_config.json')
        sdk = roots['flutter'].parents[1]
        for row in rows:
            source, _ = license_source(row['name'], roots[row['name']], sdk)
            data = (OUTPUT / row['license_file']).read_bytes()
            self.assertEqual(data, source.read_bytes(), row['name'])
            self.assertEqual(digest(data), row['license_sha256'])
        for row in manifest['android_components']:
            self.assertEqual(digest((OUTPUT / row['pom_file']).read_bytes()), row['pom_sha256'])
            for parent in row['parent_poms']:
                self.assertEqual(digest((OUTPUT / parent['file']).read_bytes()), parent['sha256'])

    def test_notices_equal_apk_payload(self):
        manifest = json.loads((OUTPUT / 'manifest.json').read_text())
        path = ROOT / 'build/app/outputs/flutter-apk' / manifest['apk_name']
        with zipfile.ZipFile(path) as apk:
            notices = gzip.decompress(apk.read('assets/flutter_assets/NOTICES.Z'))
        self.assertEqual((OUTPUT / 'APK_NOTICES.txt').read_bytes(), notices)
        self.assertEqual(digest(notices), manifest['apk_notices_sha256'])

    def test_native_source_copies_match_recorded_hashes(self):
        directory = OUTPUT / 'native'
        sources = json.loads((directory / 'sources.json').read_text())
        manifest = json.loads((OUTPUT / 'manifest.json').read_text())
        isar = next(p for p in manifest['pub_packages'] if p['name'] == 'isar_community')
        self.assertEqual(sources['isar_version'], isar['version'])
        self.assertEqual(len(sources['files']), 5)
        for source in sources['files']:
            data = (directory / source['file']).read_bytes()
            if source['newline_added']:
                self.assertTrue(data.endswith(b'\n'))
                data = data[:-1]
            self.assertEqual(digest(data), source['upstream_sha256'], source['file'])


if __name__ == '__main__':
    unittest.main()
