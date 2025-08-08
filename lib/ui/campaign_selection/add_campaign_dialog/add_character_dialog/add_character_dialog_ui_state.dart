import 'package:daggerheart_game_master_companion/ui/base/view_model.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/add_campaign_dialog/add_character_dialog/choice_ui_model.dart';

class LoadedAddCharacterDialogUiState extends BaseState {
  final ChoiceUiModel classUiModel;
  final ChoiceUiModel subclassUiModel;
  final ChoiceUiModel ancestryUiModel;
  final ChoiceUiModel communityUiModel;
  final ChoiceUiModel agilityUiModel;
  final ChoiceUiModel strengthUiModel;
  final ChoiceUiModel finesseUiModel;
  final ChoiceUiModel instinctUiModel;
  final ChoiceUiModel presenceUiModel;
  final ChoiceUiModel knowledgeUiModel;

  LoadedAddCharacterDialogUiState({
    required this.classUiModel,
    required this.subclassUiModel,
    required this.ancestryUiModel,
    required this.communityUiModel,
    required this.agilityUiModel,
    required this.strengthUiModel,
    required this.finesseUiModel,
    required this.instinctUiModel,
    required this.presenceUiModel,
    required this.knowledgeUiModel,
  }) : super(isLoading: false);

  LoadedAddCharacterDialogUiState copy({
    ChoiceUiModel? newClassUiModel,
    ChoiceUiModel? newSubclassUiModel,
    ChoiceUiModel? newAncestryUiModel,
    ChoiceUiModel? newCommunityUiModel,
    ChoiceUiModel? newAgilityUiModel,
    ChoiceUiModel? newStrengthUiModel,
    ChoiceUiModel? newFinesseUiModel,
    ChoiceUiModel? newInstinctUiModel,
    ChoiceUiModel? newPresenceUiModel,
    ChoiceUiModel? newKnowledgeUiModel,
  }) => LoadedAddCharacterDialogUiState(
    classUiModel: newClassUiModel ?? classUiModel,
    subclassUiModel: newSubclassUiModel ?? subclassUiModel,
    ancestryUiModel: newAncestryUiModel ?? ancestryUiModel,
    communityUiModel: newCommunityUiModel ?? communityUiModel,
    agilityUiModel: newAgilityUiModel ?? agilityUiModel,
    strengthUiModel: newStrengthUiModel ?? strengthUiModel,
    finesseUiModel: newFinesseUiModel ?? finesseUiModel,
    instinctUiModel: newInstinctUiModel ?? instinctUiModel,
    presenceUiModel: newPresenceUiModel ?? presenceUiModel,
    knowledgeUiModel: newKnowledgeUiModel ?? knowledgeUiModel,
  );
}
