import 'package:daggerheart_game_master_companion/ui/campaign_selection/add_campaign_dialog/add_character_dialog/choice_ui_model.dart';

class LoadedCharacterDialogUiState {
  final ChoiceUiModel? classUiModel;
  final ChoiceUiModel? subclassUiModel;
  final ChoiceUiModel? ancestryUiModel;
  final ChoiceUiModel? communityUiModel;

  LoadedCharacterDialogUiState({
    required this.classUiModel,
    required this.subclassUiModel,
    required this.ancestryUiModel,
    required this.communityUiModel,
  });
}
