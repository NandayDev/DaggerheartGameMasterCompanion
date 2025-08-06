import 'dart:convert';

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
      _PLAYER_CLASS: playerCharacter.daggerheartClass.name,
      _PLAYER_LEVEL: playerCharacter.level,
      _PLAYER_DOMAIN: playerCharacter.domain.name,
      _PLAYER_SUBCLASS: playerCharacter.subclass.name,
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

    DaggerheartClass daggerheartClass = await _srdParser.getClass(playerCharacterJson[_PLAYER_CLASS]);
  }

  static const _PLAYER_KEY = "key";
  static const _PLAYER_CLASS = "class";
  static const _PLAYER_LEVEL = "level";
  static const _PLAYER_DOMAIN = "domain";
  static const _PLAYER_SUBCLASS = "subclass";
  static const _PLAYER_NOTES = "notes";
}
