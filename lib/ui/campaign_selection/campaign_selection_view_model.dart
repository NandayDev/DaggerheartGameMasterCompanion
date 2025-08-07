import 'package:daggerheart_game_master_companion/extensions/list_extensions.dart';
import 'package:daggerheart_game_master_companion/services/data/campaign_repository.dart';
import 'package:daggerheart_game_master_companion/ui/base/view_model.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/campaign_selection_ui_model.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/campaign_selection_ui_state.dart';

class CampaignSelectionViewModel extends ViewModel {
  final CampaignRepository _campaignRepository;

  CampaignSelectionViewModel(this._campaignRepository);

  void initialize() async {
    final campaignResult = await _campaignRepository.getAllCampaigns();

    final uiModels = campaignResult.mapToList((result) {
      if (result.isSuccess()) {
        final campaign = result.getOrThrow();
        return CampaignSelectionUiModel.success(
          key: campaign.key,
          name: campaign.name,
          startDate: campaign.created.toString(),
          characters: campaign.characters.mapToList((c) => c.name).join(", "),
        );
      } else {
        return CampaignSelectionUiModel.error();
      }
    });
    final uiState = LoadedCampaignSelectionUiState(uiModels: uiModels);
    notify(uiState);
  }
}
