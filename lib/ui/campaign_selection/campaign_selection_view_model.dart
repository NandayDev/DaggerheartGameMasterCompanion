import 'package:daggerheart_game_master_companion/services/data/campaign_repository.dart';
import 'package:daggerheart_game_master_companion/ui/base/view_model.dart';

class CampaignSelectionViewModel extends ViewModel {
  final CampaignRepository _campaignRepository;

  CampaignSelectionViewModel(this._campaignRepository);

  void initialize() async {
    final campaigns = await _campaignRepository.getAllCampaigns();
  }
}
