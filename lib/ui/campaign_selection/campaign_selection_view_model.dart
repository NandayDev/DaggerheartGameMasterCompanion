import 'package:daggerheart_game_master_companion/extensions/list_extensions.dart';
import 'package:daggerheart_game_master_companion/models/campaign.dart';
import 'package:daggerheart_game_master_companion/services/data/campaign_repository.dart';
import 'package:daggerheart_game_master_companion/ui/base/view_model.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/campaign_selection_ui_model.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/campaign_selection_ui_state.dart';

class CampaignSelectionViewModel extends ViewModel {
  final CampaignRepository _campaignRepository;

  CampaignSelectionViewModel(this._campaignRepository);

  Campaign? get selectedCampaign => _campaignRepository.selectedCampaign;

  set selectedCampaign(Campaign? campaign) {
    _campaignRepository.selectedCampaign = campaign;
  }

  void initialize() async {
    final campaignResult = await _campaignRepository.getAllCampaigns();
    final BaseState uiState;

    if (campaignResult.isEmpty) {
      uiState = EmptyCampaignSelectionUiState();
    } else {
      final uiModels = campaignResult.mapToList((result) {
        if (result.isSuccess()) {
          final campaign = result.getOrThrow();
          return CampaignSelectionUiModel.success(
              key: campaign.key,
              name: campaign.name,
              startDate: campaign.created.toString(),
              characters: campaign.characters.mapToList((c) => c.name).join(", "),
              campaign: campaign
          );
        } else {
          return CampaignSelectionUiModel.error();
        }
      });
      uiState = LoadedCampaignSelectionUiState(uiModels: uiModels);
    }
    notify(uiState);
  }
}
