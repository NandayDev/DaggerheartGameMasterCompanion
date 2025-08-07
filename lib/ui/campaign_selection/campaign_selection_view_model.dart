import 'package:daggerheart_game_master_companion/extensions/list_extensions.dart';
import 'package:daggerheart_game_master_companion/services/data/campaign_repository.dart';
import 'package:daggerheart_game_master_companion/ui/base/view_model.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/campaign_selection_ui_state.dart';

class CampaignSelectionViewModel extends ViewModel {
  final CampaignRepository _campaignRepository;

  CampaignSelectionViewModel(this._campaignRepository);

  void initialize() async {
    final campaigns = await _campaignRepository.getAllCampaigns();
    final uiModels = campaigns.mapToList((campaign) {
      //return CampaignSelectionUiModel(key: campaign.key, name: campaign.name, startDate: campaign.created.toString(), characters: "" /*TODO*/);
    });
    throw UnimplementedError();

    final uiState = LoadedCampaignSelectionUiState(uiModels: []);
    notify(uiState);
  }
}
