import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:isar_community/isar.dart';

/// Находит установленную зависимость, не привязываясь к имени пользователя.
Future<Uri> packageRoot(String name) async {
  final file = File('.dart_tool/package_config.json').absolute;
  final config = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  final package = (config['packages'] as List<dynamic>)
      .cast<Map<String, dynamic>>()
      .singleWhere((entry) => entry['name'] == name);
  final root = package['rootUri'] as String;
  return file.uri.resolve(root.endsWith('/') ? root : '$root/');
}

/// Использует установленное ядро Isar на Linux x64, без скачивания во время теста.
Future<void> initializeTestIsar() async {
  final root = await packageRoot('isar_community_flutter_libs');
  await Isar.initializeIsarCore(
    libraries: {Abi.linuxX64: root.resolve('linux/libisar.so').toFilePath()},
  );
}
