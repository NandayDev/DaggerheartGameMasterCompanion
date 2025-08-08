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
  final ChoiceUiModel firstDomainAbilityUiModel;
  final ChoiceUiModel secondDomainAbilityUiModel;
  final ChoiceUiModel? thirdDomainAbilityUiModel;

  const LoadedAddCharacterDialogUiState({
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
    required this.firstDomainAbilityUiModel,
    required this.secondDomainAbilityUiModel,
    required this.thirdDomainAbilityUiModel,
  }) : super(isLoading: false);

  LoadedAddCharacterDialogUiState copy({
    ChoiceUiModel newClassUiModel = _unchanged,
    ChoiceUiModel newSubclassUiModel = _unchanged,
    ChoiceUiModel newAncestryUiModel = _unchanged,
    ChoiceUiModel newCommunityUiModel = _unchanged,
    ChoiceUiModel newAgilityUiModel = _unchanged,
    ChoiceUiModel newStrengthUiModel = _unchanged,
    ChoiceUiModel newFinesseUiModel = _unchanged,
    ChoiceUiModel newInstinctUiModel = _unchanged,
    ChoiceUiModel newPresenceUiModel = _unchanged,
    ChoiceUiModel newKnowledgeUiModel = _unchanged,
    ChoiceUiModel newFirstDomainAbilityUiModel = _unchanged,
    ChoiceUiModel newSecondDomainAbilityUiModel = _unchanged,
    ChoiceUiModel? newThirdDomainAbilityUiModel = _unchanged,
  }) => LoadedAddCharacterDialogUiState(
    classUiModel: newClassUiModel == _unchanged ? classUiModel : newClassUiModel,
    subclassUiModel: newSubclassUiModel == _unchanged ? subclassUiModel : newSubclassUiModel,
    ancestryUiModel: newAncestryUiModel == _unchanged ? ancestryUiModel : newAncestryUiModel,
    communityUiModel: newCommunityUiModel == _unchanged ? communityUiModel : newCommunityUiModel,
    agilityUiModel: newAgilityUiModel == _unchanged ? agilityUiModel : newAgilityUiModel,
    strengthUiModel: newStrengthUiModel == _unchanged ? strengthUiModel : newStrengthUiModel,
    finesseUiModel: newFinesseUiModel == _unchanged ? finesseUiModel : newFinesseUiModel,
    instinctUiModel: newInstinctUiModel == _unchanged ? instinctUiModel : newInstinctUiModel,
    presenceUiModel: newPresenceUiModel == _unchanged ? presenceUiModel : newPresenceUiModel,
    knowledgeUiModel: newKnowledgeUiModel == _unchanged ? knowledgeUiModel : newKnowledgeUiModel,
    firstDomainAbilityUiModel: newFirstDomainAbilityUiModel == _unchanged ? firstDomainAbilityUiModel : newFirstDomainAbilityUiModel,
    secondDomainAbilityUiModel: newSecondDomainAbilityUiModel == _unchanged ? secondDomainAbilityUiModel : newSecondDomainAbilityUiModel,
    thirdDomainAbilityUiModel: newThirdDomainAbilityUiModel == _unchanged ? thirdDomainAbilityUiModel : newThirdDomainAbilityUiModel,
  );

  static const ChoiceUiModel _unchanged = ChoiceUiModel(
    type: ChoiceType.Unchanged,
    isEnabled: false,
    isError: true,
    selectedChild: null,
    children: [],
  );
}
