class CampaignSelectionUiModel {
  final String key;
  final String name;
  final String startDate;
  final String characters;
  final bool isError;

  CampaignSelectionUiModel.success({required this.key, required this.name, required this.startDate, required this.characters}) : isError = false;

  CampaignSelectionUiModel.error() : key = "", name = "", startDate = "", characters = "", isError = true;
}
