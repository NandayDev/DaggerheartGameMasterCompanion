import 'dart:io';

import 'package:path/path.dart' as path;

abstract class LocalDataSource {
  Future<Iterable<String>> getAllCampaigns();

  Future<void> saveCampaign(String key, String campaign);
}

class LocalJsonDataSource implements LocalDataSource {
  final Directory _storageDirectory = _getStorageDirectory();

  @override
  Future<Iterable<String>> getAllCampaigns() async {
    final files = await _getCollection(_CAMPAIGNS_COLLECTION);
    return files.map((fileSystemEntity) {
      final file = File(fileSystemEntity.path);
      return file.readAsStringSync();
    });
  }

  @override
  Future<void> saveCampaign(String key, String campaign) async {
    final file = File(path.join(_storageDirectory.path, _CAMPAIGNS_COLLECTION, "$key.json"));
    await file.create();
    await file.writeAsString(campaign);
  }

  Future<List<FileSystemEntity>> _getCollection(String name) async {
    final directoryPath = path.join(_storageDirectory.path, name);
    final directory = Directory(directoryPath);
    await directory.create(recursive: true);
    return directory.listSync();
  }

  static Directory _getStorageDirectory() {
    if (Platform.isWindows) {
      String directoryPath = path.join(Platform.environment['LOCALAPPDATA']!, "daggerheart_gm_companion");
      return Directory(directoryPath)..create(recursive: true);
    }
    throw UnimplementedError();
  }

  static const _CAMPAIGNS_COLLECTION = "campaigns";
}
