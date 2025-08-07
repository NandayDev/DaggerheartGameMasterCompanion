import 'dart:convert';
import 'dart:io';

import 'package:daggerheart_game_master_companion/extensions/list_extensions.dart';
import 'package:daggerheart_game_master_companion/models/srd/daggerheart_class.dart';
import 'package:daggerheart_game_master_companion/models/srd/player_character.dart';
import 'package:daggerheart_game_master_companion/services/data/data_source.dart';
import 'package:daggerheart_game_master_companion/services/srd_parser.dart';
import 'package:daggerheart_game_master_companion/shared/attempt.dart';
import 'package:daggerheart_game_master_companion/shared/result.dart';

abstract class PlayerCharacterRepository {
  Future<Attempt> savePlayerCharacter(PlayerCharacter playerCharacter);

  Future<Result<PlayerCharacter>> loadPlayerCharacter(String key);
}

class PlayerCharacterRepositoryImpl implements PlayerCharacterRepository {
  final LocalDataSource _dataSource;
  final JsonEncoder _jsonEncoder;
  final SrdParser _srdParser;

  PlayerCharacterRepositoryImpl(this._dataSource, this._jsonEncoder, this._srdParser);

  @override
  Future<Attempt> savePlayerCharacter(PlayerCharacter playerCharacter) async {
    final json = {
      _PLAYER_KEY: playerCharacter.key,
      _PLAYER_CLASS_KEY: playerCharacter.daggerheartClass.key,
      _PLAYER_LEVEL: playerCharacter.level,
      _PLAYER_DOMAIN_KEY: playerCharacter.domain.key,
      _PLAYER_SUBCLASS_KEY: playerCharacter.subclass.key,
      _PLAYER_NOTES: playerCharacter.notes,
    };
    final jsonString = _jsonEncoder.convert(json);
    try {
      await _dataSource.savePlayerCharacter(key: playerCharacter.key, playerCharacter: jsonString);
      return Attempt.success();
    } on Exception catch (e) {
      return Attempt.failure(e);
    }
  }

  @override
  Future<Result<PlayerCharacter>> loadPlayerCharacter(String key) async {
    final String playerCharacterString;
    try {
      playerCharacterString = await _dataSource.getPlayerCharacter(key);
    } on PlayerCharacterNotFoundException catch (e) {
      return Result.failure(e);
    }
    final playerCharacterJson = jsonDecode(playerCharacterString);

    final classKey = playerCharacterJson[_PLAYER_CLASS_KEY];
    DaggerheartClass? daggerheartClass = await _srdParser.getClass(classKey);
    if (daggerheartClass == null) {
      final exception = DaggerheartNotFoundException("class", classKey);
      return Result.failure(exception);
    }

    final domainKey = playerCharacterJson[_PLAYER_DOMAIN_KEY];
    final domain = daggerheartClass.domains.firstWhereOrNull((d) => d.key == domainKey);
    if (domain == null) {
      final exception = DaggerheartNotFoundException("domain", domainKey);
      return Result.failure(exception);
    }

    final subclassKey = playerCharacterJson[_PLAYER_SUBCLASS_KEY];
    final subclass = daggerheartClass.subclasses.firstWhereOrNull((d) => d.key == subclassKey);
    if (subclass == null) {
      final exception = DaggerheartNotFoundException("subclass", subclassKey);
      return Result.failure(exception);
    }

    final playerCharacter = PlayerCharacter(
        key: key,
        daggerheartClass: daggerheartClass,
        level: playerCharacterJson[_PLAYER_LEVEL],
        domain: domain,
        subclass: subclass,
        notes: (playerCharacterJson[_PLAYER_NOTES] as Iterable<dynamic>).castToList<String>()
    );

    return Result.success(playerCharacter);
  }

  static const _PLAYER_KEY = "key";
  static const _PLAYER_CLASS_KEY = "class";
  static const _PLAYER_LEVEL = "level";
  static const _PLAYER_DOMAIN_KEY = "domain";
  static const _PLAYER_SUBCLASS_KEY = "subclass";
  static const _PLAYER_NOTES = "notes";
}

class DaggerheartNotFoundException implements IOException {
  final String message;

  DaggerheartNotFoundException(String objectType, String key) : message = "Can't find $objectType with key $key";
}