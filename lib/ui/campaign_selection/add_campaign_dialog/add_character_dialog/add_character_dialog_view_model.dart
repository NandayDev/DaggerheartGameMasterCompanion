import 'package:daggerheart_game_master_companion/extensions/list_extensions.dart';
import 'package:daggerheart_game_master_companion/models/srd/player_character.dart';
import 'package:daggerheart_game_master_companion/services/data/player_characters_repository.dart';
import 'package:daggerheart_game_master_companion/services/srd_parser.dart';
import 'package:daggerheart_game_master_companion/ui/base/view_model.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/add_campaign_dialog/add_character_dialog/add_character_dialog_ui_state.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/add_campaign_dialog/add_character_dialog/choice_ui_model.dart';

class AddCharacterDialogViewModel extends ViewModel {
  final SrdParser _srdParser;
  final PlayerCharacterRepository _playerCharacterRepository;

  AddCharacterDialogViewModel(this._srdParser, this._playerCharacterRepository);

  var _traitBonusList = _originalTraitBonusList.toList();
  static const _originalTraitBonusList = [2, 1, 1, 0, 0, -1];

  void initialize() async {
    final classesFuture = _srdParser.getAllClasses();
    final ancestriesFuture = _srdParser.getAllAncestries();
    final communitiesFuture = _srdParser.getAllCommunities();
    final classUiModel = ChoiceUiModel(
      type: ChoiceType.Class,
      isEnabled: true,
      isError: false,
      selectedChild: null,
      children: (await classesFuture).mapToList((c) => ChoiceChildUiModel(key: c.key, name: c.name)),
    );
    final subclassUiModel = ChoiceUiModel(type: ChoiceType.Subclass, isEnabled: false, isError: false, selectedChild: null, children: []);
    final ancestryUiModel = ChoiceUiModel(
      type: ChoiceType.Ancestry,
      isEnabled: true,
      isError: false,
      selectedChild: null,
      children: (await ancestriesFuture).mapToList((c) => ChoiceChildUiModel(key: c.key, name: c.name)),
    );
    final communityUiModel = ChoiceUiModel(
      type: ChoiceType.Community,
      isEnabled: true,
      isError: false,
      selectedChild: null,
      children: (await communitiesFuture).mapToList((c) => ChoiceChildUiModel(key: c.key, name: c.name)),
    );
    final uiState = LoadedAddCharacterDialogUiState(
      classUiModel: classUiModel,
      subclassUiModel: subclassUiModel,
      ancestryUiModel: ancestryUiModel,
      communityUiModel: communityUiModel,
      agilityUiModel: _createTraitUiModel(ChoiceType.Agility),
      strengthUiModel: _createTraitUiModel(ChoiceType.Strength),
      finesseUiModel: _createTraitUiModel(ChoiceType.Finesse),
      instinctUiModel: _createTraitUiModel(ChoiceType.Instinct),
      presenceUiModel: _createTraitUiModel(ChoiceType.Presence),
      knowledgeUiModel: _createTraitUiModel(ChoiceType.Knowledge),
    );
    notify(uiState);
  }

  void classChanged(ChoiceChildUiModel? selectedChild) async {
    if (selectedChild != null) {
      final selectedClass = await _srdParser.getClass(selectedChild.key);
      final subclasses = selectedClass!.subclasses;
      final newSubclassUiModel = ChoiceUiModel(
        type: ChoiceType.Subclass,
        isEnabled: true,
        isError: false,
        selectedChild: null,
        children: subclasses.mapToList((c) => ChoiceChildUiModel(key: c.key, name: c.name)),
      );
      _updateState((currentUiState) {
        final newClassUiModel = currentUiState.classUiModel.select(selectedChild);
        return currentUiState.copy(newClassUiModel: newClassUiModel, newSubclassUiModel: newSubclassUiModel);
      });
    }
  }

  void subclassChanged(ChoiceChildUiModel? selectedChild) {
    if (selectedChild != null) {
      _updateState((currentUiState) {
        final newSubclassUiModel = currentUiState.subclassUiModel.select(selectedChild);
        return currentUiState.copy(newSubclassUiModel: newSubclassUiModel);
      });
    }
  }

  void ancestryChanged(ChoiceChildUiModel? selectedChild) {
    if (selectedChild != null) {
      _updateState((currentUiState) {
        final newAncestryUiModel = currentUiState.ancestryUiModel.select(selectedChild);
        return currentUiState.copy(newAncestryUiModel: newAncestryUiModel);
      });
    }
  }

  void communityChanged(ChoiceChildUiModel? selectedChild) {
    if (selectedChild != null) {
      _updateState((currentUiState) {
        final newCommunityUiModel = currentUiState.communityUiModel.select(selectedChild);
        return currentUiState.copy(newCommunityUiModel: newCommunityUiModel);
      });
    }
  }

  void traitChanged(ChoiceType choiceType, ChoiceChildUiModel? selectedChild) {
    if (selectedChild != null) {
      _updateState((currentUiState) {
        final ChoiceUiModel currentUiModel;
        switch (choiceType) {
          case ChoiceType.Agility:
            currentUiModel = currentUiState.agilityUiModel;
            break;
          case ChoiceType.Strength:
            currentUiModel = currentUiState.strengthUiModel;
            break;
          case ChoiceType.Finesse:
            currentUiModel = currentUiState.finesseUiModel;
            break;
          case ChoiceType.Instinct:
            currentUiModel = currentUiState.instinctUiModel;
            break;
          case ChoiceType.Presence:
            currentUiModel = currentUiState.presenceUiModel;
            break;
          case ChoiceType.Knowledge:
            currentUiModel = currentUiState.knowledgeUiModel;
            break;
          default:
            throw Exception();
        }
        final previousSelectedTraitBonus = currentUiModel.selectedChild?.key;
        if (previousSelectedTraitBonus != null) {
          _traitBonusList.add(previousSelectedTraitBonus);
        }
        final newUiModel = currentUiModel.select(selectedChild);
        final removedTraitBonus = selectedChild.key as int;
        _traitBonusList.remove(removedTraitBonus);
        return currentUiState.copy(
          newAgilityUiModel: choiceType == ChoiceType.Agility
              ? newUiModel
              : _createTraitUiModel(ChoiceType.Agility, previousUiModel: currentUiState.agilityUiModel),
          newStrengthUiModel: choiceType == ChoiceType.Strength
              ? newUiModel
              : _createTraitUiModel(ChoiceType.Strength, previousUiModel: currentUiState.strengthUiModel),
          newFinesseUiModel: choiceType == ChoiceType.Finesse
              ? newUiModel
              : _createTraitUiModel(ChoiceType.Finesse, previousUiModel: currentUiState.finesseUiModel),
          newInstinctUiModel: choiceType == ChoiceType.Instinct
              ? newUiModel
              : _createTraitUiModel(ChoiceType.Instinct, previousUiModel: currentUiState.instinctUiModel),
          newPresenceUiModel: choiceType == ChoiceType.Presence
              ? newUiModel
              : _createTraitUiModel(ChoiceType.Presence, previousUiModel: currentUiState.presenceUiModel),
          newKnowledgeUiModel: choiceType == ChoiceType.Knowledge
              ? newUiModel
              : _createTraitUiModel(ChoiceType.Knowledge, previousUiModel: currentUiState.knowledgeUiModel),
        );
      });
    }
  }

  void resetTraits() {
    _updateState((currentUiState) {
      _traitBonusList = _originalTraitBonusList.toList();
      return currentUiState.copy(
        newAgilityUiModel: _createTraitUiModel(ChoiceType.Agility),
        newStrengthUiModel: _createTraitUiModel(ChoiceType.Strength),
        newFinesseUiModel: _createTraitUiModel(ChoiceType.Finesse),
        newInstinctUiModel: _createTraitUiModel(ChoiceType.Instinct),
        newPresenceUiModel: _createTraitUiModel(ChoiceType.Presence),
        newKnowledgeUiModel: _createTraitUiModel(ChoiceType.Knowledge),
      );
    });
  }

  PlayerCharacter? buildPlayerCharacter() {
    // TODO
  }

  void _updateState(LoadedAddCharacterDialogUiState Function(LoadedAddCharacterDialogUiState) function) {
    final currentUiState = currentState;
    if (currentUiState is LoadedAddCharacterDialogUiState) {
      final newUiState = function(currentUiState);
      notify(newUiState);
    }
  }

  ChoiceUiModel _createTraitUiModel(ChoiceType choiceType, {ChoiceUiModel? previousUiModel}) {
    return ChoiceUiModel(
      type: choiceType,
      isEnabled: true,
      isError: previousUiModel?.isError ?? false,
      selectedChild: previousUiModel?.selectedChild,
      children: _traitBonusList.mapToList((traitBonus) => ChoiceChildUiModel(key: traitBonus, name: _traitBonusToString(traitBonus))),
    );
  }

  String _traitBonusToString(int bonus) => '${bonus >= 0 ? '+' : ''}$bonus';
}
