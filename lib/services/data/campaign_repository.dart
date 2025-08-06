import 'dart:convert';

import 'package:daggerheart_game_master_companion/models/campaign.dart';
import 'package:daggerheart_game_master_companion/models/srd/player_character.dart';
import 'package:daggerheart_game_master_companion/services/data/data_source.dart';
import 'package:daggerheart_game_master_companion/services/data/player_characters_repository.dart';
import 'package:daggerheart_game_master_companion/services/srd_parser.dart';
import 'package:daggerheart_game_master_companion/shared/result.dart';

abstract class CampaignRepository {
  Campaign? selectedCampaign;

  Future<Iterable<Result<Campaign>>> getAllCampaigns();

  Future<void> saveCampaign(Campaign campaign);
}

class CampaignRepositoryImpl implements CampaignRepository {
  final LocalDataSource _dataSource;
  final PlayerCharacterRepository _playerCharacterRepository;
  final JsonEncoder _jsonEncoder;
  final SrdParser _srdParser;

  CampaignRepositoryImpl(this._dataSource, this._playerCharacterRepository, this._jsonEncoder, this._srdParser);

  @override
  Campaign? selectedCampaign;

  @override
  Future<Iterable<Result<Campaign>>> getAllCampaigns() async {
    final campaignsJson = await _dataSource.getAllCampaigns();
    final List<Result<Campaign>> campaignResults = [];
    for (final campaignJson in campaignsJson) {
      final result = await _campaignFromJsonString(campaignJson);
      campaignResults.add(result);
    }
    return campaignResults;
  }

  @override
  Future<void> saveCampaign(Campaign campaign) {
    final campaignString = _campaignToJsonString(campaign);
    return _dataSource.saveCampaign(key: campaign.key, campaign: campaignString);
  }

  String _campaignToJsonString(Campaign campaign) {
    final json = {
      _CAMPAIGN_GUID: campaign.key,
      _CAMPAIGN_NAME: campaign.name,
      _CAMPAIGN_CREATED: campaign.created.millisecondsSinceEpoch,
      _CAMPAIGN_CHARACTERS: campaign.characters.map((c) => c.key),
    };
    return _jsonEncoder.convert(json);
  }

  Future<Result<Campaign>> _campaignFromJsonString(String jsonString) async {
    final json = jsonDecode(jsonString);
    final characterKeys = json[_CAMPAIGN_CHARACTERS] as Iterable<String>;
    final List<PlayerCharacter> playerCharacters = [];
    for (final characterKey in characterKeys) {
      final playerCharacterResult = await _playerCharacterRepository.loadPlayerCharacter(characterKey);
      if (!playerCharacterResult.isSuccess()) {
        return Result.failure(playerCharacterResult.exceptionOrThrow());
      }
      final playerCharacter = playerCharacterResult.getOrThrow();
      playerCharacters.add(playerCharacter);
    }
    final campaign = Campaign(
      key: json[_CAMPAIGN_GUID],
      name: json[_CAMPAIGN_NAME],
      created: DateTime.fromMillisecondsSinceEpoch(json[_CAMPAIGN_CREATED]),
      characters: playerCharacters,
    );
    return Result.success(campaign);
  }
}

const _CAMPAIGN_GUID = "guid";
const _CAMPAIGN_NAME = "name";
const _CAMPAIGN_CREATED = "created";
const _CAMPAIGN_CHARACTERS = "characters";
