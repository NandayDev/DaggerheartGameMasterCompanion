import 'package:daggerheart_game_master_companion/models/campaign.dart';

class CampaignSelectionUiModel {
  final String key;
  final String name;
  final String startDate;
  final String characters;
  final Campaign? campaign;
  final bool isError;

  CampaignSelectionUiModel.success({required this.key, required this.name, required this.startDate, required this.characters, required this.campaign})
    : isError = false;

  CampaignSelectionUiModel.error() : key = "", name = "", startDate = "", characters = "", campaign = null, isError = true;
}
