import 'package:daggerheart_game_master_companion/ui/base/view_model.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/campaign_selection_ui_model.dart';

class LoadedCampaignSelectionUiState extends BaseState {
  final List<CampaignSelectionUiModel> uiModels;

  LoadedCampaignSelectionUiState({required this.uiModels}) : super(isLoading: false);
}