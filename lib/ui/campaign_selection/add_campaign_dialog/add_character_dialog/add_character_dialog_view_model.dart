import 'dart:async';

import 'package:daggerheart_game_master_companion/constants.dart';
import 'package:daggerheart_game_master_companion/extensions/list_extensions.dart';
import 'package:daggerheart_game_master_companion/models/srd/player_character.dart';
import 'package:daggerheart_game_master_companion/services/data/player_characters_repository.dart';
import 'package:daggerheart_game_master_companion/services/srd_parser.dart';
import 'package:daggerheart_game_master_companion/ui/base/view_model.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/add_campaign_dialog/add_character_dialog/add_character_dialog_ui_state.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/add_campaign_dialog/add_character_dialog/choice_ui_model.dart';
import 'package:uuid/uuid.dart';

class AddCharacterDialogViewModel extends ViewModel {
  final SrdParser _srdParser;
  final PlayerCharacterRepository _playerCharacterRepository;

  AddCharacterDialogViewModel(this._srdParser, this._playerCharacterRepository);

  String get name =>
      (currentState is LoadedAddCharacterDialogUiState)
          ? (currentState as LoadedAddCharacterDialogUiState).name
          : "";
  var _traitBonusList = _originalTraitBonusList.toList();
  List<ChoiceChildUiModel> _domainAbilities = List.empty(growable: true);
  static const _originalTraitBonusList = [2, 1, 1, 0, 0, -1];

  PlayerCharacter? _characterToUpdate;
  final uuid = Uuid();

  final _eventStreamController = StreamController<PlayerCharacter>();

  Stream get eventStream => _eventStreamController.stream;

  void initialize(PlayerCharacter? playerCharacter) async {
    _characterToUpdate = playerCharacter;
    final classes = await _srdParser.getAllClasses();
    final ancestries = await _srdParser.getAllAncestries();
    final communities = await _srdParser.getAllCommunities();
    final classUiModels = classes.mapToList((c) => ChoiceChildUiModel(key: c.key, name: c.name));
    final classUiModel = ChoiceUiModel(
      type: ChoiceType.Class,
      isEnabled: true,
      isError: false,
      selectedChild: classUiModels.firstWhereOrNull(
            (c) => playerCharacter?.daggerheartClass.key == c.key,
      ),
      children: classUiModels,
    );

    final List<ChoiceChildUiModel> subclassUiModels;
    ChoiceChildUiModel? selectedSubclassUiModel;
    if (playerCharacter == null) {
      subclassUiModels = [];
      selectedSubclassUiModel = null;
    } else {
      subclassUiModels = playerCharacter.daggerheartClass.subclasses.mapToList(
            (c) => ChoiceChildUiModel(key: c.key, name: c.name),
      );
      selectedSubclassUiModel = subclassUiModels.firstWhere(
            (subclass) => subclass.key == playerCharacter.subclass.key,
      );
    }

    final subclassUiModel = ChoiceUiModel(
      type: ChoiceType.Subclass,
      isEnabled: playerCharacter != null,
      isError: false,
      selectedChild: selectedSubclassUiModel,
      children: subclassUiModels,
    );

    final ancestryUiModels = ancestries.mapToList((c) =>
        ChoiceChildUiModel(key: c.key, name: c.name));
    final ancestryUiModel = ChoiceUiModel(
      type: ChoiceType.Ancestry,
      isEnabled: true,
      isError: false,
      selectedChild: ancestryUiModels.firstWhereOrNull((ancestry) =>
      playerCharacter?.ancestry.key == ancestry.key),
      children: ancestryUiModels,
    );

    final communityUiModels = communities.mapToList((c) =>
        ChoiceChildUiModel(key: c.key, name: c.name));
    final communityUiModel = ChoiceUiModel(
      type: ChoiceType.Community,
      isEnabled: true,
      isError: false,
      selectedChild: communityUiModels.firstWhereOrNull((community) =>
      playerCharacter?.community.key == community.key),
      children: communityUiModels,
    );

    final List<ChoiceChildUiModel> domainUiModels;
    ChoiceChildUiModel? firstSelectedDomainUiModel;
    ChoiceChildUiModel? secondSelectedDomainUiModel;
    if (playerCharacter == null) {
      domainUiModels = [];
      firstSelectedDomainUiModel = null;
      secondSelectedDomainUiModel = null;
    } else {
      domainUiModels = playerCharacter.daggerheartClass.domains.mapToList(
            (c) => ChoiceChildUiModel(key: c.key, name: c.name),
      );
      firstSelectedDomainUiModel = domainUiModels.firstWhere(
            (domain) => domain.key == playerCharacter.domainAbilities[0].key,
      );
      secondSelectedDomainUiModel = domainUiModels.firstWhere(
            (domain) => domain.key == playerCharacter.domainAbilities[1].key,
      );
    }
    final firstDomainUiModel = ChoiceUiModel(
      type: ChoiceType.FirstDomainAbility,
      isEnabled: playerCharacter != null,
      isError: false,
      selectedChild: firstSelectedDomainUiModel,
      children: domainUiModels,
    );
    final secondDomainUiModel = ChoiceUiModel(
      type: ChoiceType.SecondDomainAbility,
      isEnabled: playerCharacter != null,
      isError: false,
      selectedChild: secondSelectedDomainUiModel,
      children: domainUiModels,
    );
    final uiState = LoadedAddCharacterDialogUiState(
      name: playerCharacter?.name ?? "",
      isNameError: false,
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
      firstDomainAbilityUiModel: firstDomainUiModel,
      secondDomainAbilityUiModel: secondDomainUiModel,
      thirdDomainAbilityUiModel: null,
    );
    notify(uiState);
  }

  void nameChanged(String newName) {
    _updateState((currentUiState) {
      return currentUiState.copy(newName: newName, newIsNameError: false);
    });
  }

  void classChanged(ChoiceChildUiModel? selectedChild) async {
    if (selectedChild != null) {
      final selectedClass = await _srdParser.getClass(selectedChild.key);
      final abilities = selectedClass!.domains.flatMap(
            (domain) => domain.abilitiesByLevel[1]!.mapToList((a) => (domain, a)),
      ); //TODO next levels
      _domainAbilities = abilities
          .map((domainAndAbility) {
            final domain = domainAndAbility.$1;
            final ability = domainAndAbility.$2;
            return ChoiceChildUiModel(
              key: ability.key,
              name: "${ability.name} (${domain.name} lvl ${ability.level})",
            );
          })
          .toList(growable: true);
      final firstDomainUiModel = _createChoiceUiModel(ChoiceType.FirstDomainAbility);
      final secondDomainUiModel = _createChoiceUiModel(ChoiceType.SecondDomainAbility);
      final subclasses = selectedClass.subclasses;
      final newSubclassUiModel = ChoiceUiModel(
        type: ChoiceType.Subclass,
        isEnabled: true,
        isError: false,
        selectedChild: null,
        children: subclasses.mapToList((c) => ChoiceChildUiModel(key: c.key, name: c.name)),
      );
      _updateState((currentUiState) {
        final newClassUiModel = currentUiState.classUiModel.select(selectedChild);
        return currentUiState.copy(
          newClassUiModel: newClassUiModel,
          newSubclassUiModel: newSubclassUiModel,
          newFirstDomainAbilityUiModel: firstDomainUiModel,
          newSecondDomainAbilityUiModel: secondDomainUiModel,
        );
      });
    }
  }

  ChoiceUiModel _createChoiceUiModel(ChoiceType choiceType) {
    return ChoiceUiModel(
      type: choiceType,
      isEnabled: true,
      isError: false,
      selectedChild: null,
      children: _domainAbilities,
    );
  }

  void subclassChanged(ChoiceChildUiModel? selectedChild) async {
    if (selectedChild != null) {
      _updateState((currentUiState) {
        final newSubclassUiModel = currentUiState.subclassUiModel.select(selectedChild);
        final ChoiceUiModel? thirdDomainAbilityUiModel;
        if (selectedChild.key == SUBCLASS_SCHOOL_OF_KNOWLEDGE) {
          thirdDomainAbilityUiModel = ChoiceUiModel(
            type: ChoiceType.ThirdDomainAbility,
            isEnabled: true,
            isError: false,
            selectedChild: null,
            children: _domainAbilities.mapToList(
                  (ability) => ChoiceChildUiModel(key: ability.key, name: ability.name),
            ),
          );
        } else {
          thirdDomainAbilityUiModel = null;
        }
        return currentUiState.copy(
          newSubclassUiModel: newSubclassUiModel,
          newThirdDomainAbilityUiModel: thirdDomainAbilityUiModel,
        );
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
            return currentUiState;
        }
        final previousSelectedTraitBonus = currentUiModel.selectedChild?.key;
        if (previousSelectedTraitBonus != null) {
          _traitBonusList.add(previousSelectedTraitBonus);
        }
        final newUiModel = currentUiModel.select(selectedChild);
        final removedTraitBonus = selectedChild.key as int;
        _traitBonusList.remove(removedTraitBonus);
        _traitBonusList.sort((a, b) => b.compareTo(a));
        return currentUiState.copy(
          newAgilityUiModel: choiceType == ChoiceType.Agility
              ? newUiModel
              : _createTraitUiModel(
            ChoiceType.Agility,
            previousUiModel: currentUiState.agilityUiModel,
          ),
          newStrengthUiModel: choiceType == ChoiceType.Strength
              ? newUiModel
              : _createTraitUiModel(
            ChoiceType.Strength,
            previousUiModel: currentUiState.strengthUiModel,
          ),
          newFinesseUiModel: choiceType == ChoiceType.Finesse
              ? newUiModel
              : _createTraitUiModel(
            ChoiceType.Finesse,
            previousUiModel: currentUiState.finesseUiModel,
          ),
          newInstinctUiModel: choiceType == ChoiceType.Instinct
              ? newUiModel
              : _createTraitUiModel(
            ChoiceType.Instinct,
            previousUiModel: currentUiState.instinctUiModel,
          ),
          newPresenceUiModel: choiceType == ChoiceType.Presence
              ? newUiModel
              : _createTraitUiModel(
            ChoiceType.Presence,
            previousUiModel: currentUiState.presenceUiModel,
          ),
          newKnowledgeUiModel: choiceType == ChoiceType.Knowledge
              ? newUiModel
              : _createTraitUiModel(
            ChoiceType.Knowledge,
            previousUiModel: currentUiState.knowledgeUiModel,
          ),
        );
      });
    }
  }

  void domainAbilityChanged(ChoiceType choiceType, ChoiceChildUiModel? selectedChild) {
    if (selectedChild != null) {
      _updateState((currentUiState) {
        final ChoiceUiModel currentUiModel;
        switch (choiceType) {
          case ChoiceType.FirstDomainAbility:
            currentUiModel = currentUiState.firstDomainAbilityUiModel;
            break;
          case ChoiceType.SecondDomainAbility:
            currentUiModel = currentUiState.secondDomainAbilityUiModel;
            break;
          case ChoiceType.ThirdDomainAbility:
            currentUiModel = currentUiState.thirdDomainAbilityUiModel!;
            break;
          default:
            return currentUiState;
        }
        final currentSelectedChild = currentUiModel.selectedChild;
        if (currentSelectedChild != null) {
          _domainAbilities.add(currentSelectedChild);
        }
        final newUiModel = currentUiModel.select(selectedChild);
        _domainAbilities.remove(selectedChild);
        final ChoiceUiModel? thirdDomainAbilityUiModel;
        if (choiceType == ChoiceType.ThirdDomainAbility) {
          thirdDomainAbilityUiModel = newUiModel;
        } else if (currentUiState.subclassUiModel.selectedChild?.key ==
            SUBCLASS_SCHOOL_OF_KNOWLEDGE) {
          thirdDomainAbilityUiModel = _createChoiceUiModel(ChoiceType.ThirdDomainAbility);
        } else {
          thirdDomainAbilityUiModel = null;
        }
        return currentUiState.copy(
          newFirstDomainAbilityUiModel: choiceType == ChoiceType.FirstDomainAbility
              ? newUiModel
              : _createChoiceUiModel(ChoiceType.FirstDomainAbility),
          newSecondDomainAbilityUiModel: choiceType == ChoiceType.SecondDomainAbility
              ? newUiModel
              : _createChoiceUiModel(ChoiceType.SecondDomainAbility),
          newThirdDomainAbilityUiModel: thirdDomainAbilityUiModel,
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

  void savePlayerCharacter() async {
    final currentUiState = currentState;
    if (currentUiState is LoadedAddCharacterDialogUiState) {
      final bool isNameError = currentUiState.name.isEmpty;
      final bool isClassUiModelError = currentUiState.classUiModel.selectedChild == null;
      final bool isSubclassUiModelError = currentUiState.subclassUiModel.selectedChild == null;
      final bool isAncestryUiModelError = currentUiState.ancestryUiModel.selectedChild == null;
      final bool isCommunityUiModelError = currentUiState.communityUiModel.selectedChild == null;
      final bool isAgilityUiModelError = currentUiState.agilityUiModel.selectedChild == null;
      final bool isStrengthUiModelError = currentUiState.strengthUiModel.selectedChild == null;
      final bool isFinesseUiModelError = currentUiState.finesseUiModel.selectedChild == null;
      final bool isInstinctUiModelError = currentUiState.instinctUiModel.selectedChild == null;
      final bool isPresenceUiModelError = currentUiState.presenceUiModel.selectedChild == null;
      final bool isKnowledgeUiModelError = currentUiState.knowledgeUiModel.selectedChild == null;
      final bool isFirstDomainAbilityUiModelError =
          currentUiState.firstDomainAbilityUiModel.selectedChild == null;
      final bool isSecondDomainAbilityUiModelError =
          currentUiState.secondDomainAbilityUiModel.selectedChild == null;
      final bool isThirdDomainAbilityUiModelError;
      if (currentUiState.thirdDomainAbilityUiModel == null) {
        isThirdDomainAbilityUiModelError = false;
      } else {
        isThirdDomainAbilityUiModelError =
            currentUiState.thirdDomainAbilityUiModel!.selectedChild == null;
      }

      if (isNameError ||
          isClassUiModelError ||
          isSubclassUiModelError ||
          isAncestryUiModelError ||
          isCommunityUiModelError ||
          isAgilityUiModelError ||
          isStrengthUiModelError ||
          isFinesseUiModelError ||
          isInstinctUiModelError ||
          isPresenceUiModelError ||
          isKnowledgeUiModelError ||
          isFirstDomainAbilityUiModelError ||
          isSecondDomainAbilityUiModelError ||
          isThirdDomainAbilityUiModelError) {
        LoadedAddCharacterDialogUiState newUiState = currentUiState;
        if (isNameError) {
          newUiState = newUiState.copy(newIsNameError: isNameError);
        }
        if (isClassUiModelError) {
          newUiState = newUiState.copy(newClassUiModel: newUiState.classUiModel.withError());
        }
        if (isSubclassUiModelError) {
          newUiState = newUiState.copy(newSubclassUiModel: newUiState.subclassUiModel.withError());
        }
        if (isAncestryUiModelError) {
          newUiState = newUiState.copy(newAncestryUiModel: newUiState.ancestryUiModel.withError());
        }
        if (isCommunityUiModelError) {
          newUiState = newUiState.copy(
            newCommunityUiModel: newUiState.communityUiModel.withError(),
          );
        }
        if (isAgilityUiModelError) {
          newUiState = newUiState.copy(newAgilityUiModel: newUiState.agilityUiModel.withError());
        }
        if (isStrengthUiModelError) {
          newUiState = newUiState.copy(newStrengthUiModel: newUiState.strengthUiModel.withError());
        }
        if (isFinesseUiModelError) {
          newUiState = newUiState.copy(newFinesseUiModel: newUiState.finesseUiModel.withError());
        }
        if (isInstinctUiModelError) {
          newUiState = newUiState.copy(newInstinctUiModel: newUiState.instinctUiModel.withError());
        }
        if (isPresenceUiModelError) {
          newUiState = newUiState.copy(newPresenceUiModel: newUiState.presenceUiModel.withError());
        }
        if (isKnowledgeUiModelError) {
          newUiState = newUiState.copy(
            newKnowledgeUiModel: newUiState.knowledgeUiModel.withError(),
          );
        }
        if (isFirstDomainAbilityUiModelError) {
          newUiState = newUiState.copy(
            newFirstDomainAbilityUiModel: newUiState.firstDomainAbilityUiModel.withError(),
          );
        }
        if (isSecondDomainAbilityUiModelError) {
          newUiState = newUiState.copy(
            newSecondDomainAbilityUiModel: newUiState.secondDomainAbilityUiModel.withError(),
          );
        }
        if (isThirdDomainAbilityUiModelError) {
          newUiState = newUiState.copy(
            newThirdDomainAbilityUiModel: newUiState.thirdDomainAbilityUiModel!.withError(),
          );
        }

        notify(newUiState);
        return;
      }

      final daggerheartClass = await _srdParser.getClass(
          currentUiState.classUiModel.selectedChild!.key);
      final ancestry = await _srdParser.getAncestry(
          currentUiState.ancestryUiModel.selectedChild!.key);
      final community = await _srdParser.getCommunity(
          currentUiState.communityUiModel.selectedChild!.key);
      final firstDomainAbility = await _srdParser.getAbility(
          currentUiState.firstDomainAbilityUiModel.selectedChild!.key);
      final secondDomainAbility = await _srdParser.getAbility(
          currentUiState.secondDomainAbilityUiModel.selectedChild!.key);
      final subclass = await _srdParser.getSubclass(
          currentUiState.subclassUiModel.selectedChild!.key);

      final playerCharacter = PlayerCharacter(
        key: _characterToUpdate?.key ?? uuid.v4(),
        name: name,
        daggerheartClass: daggerheartClass!,
        ancestry: ancestry!,
        community: community!,
        level: _characterToUpdate?.level ?? 1,
        domainAbilities: [firstDomainAbility!, secondDomainAbility!],
        subclass: subclass!,
        backgroundAnswers: [],
        notes: [],
      );

      final saveAttempt = await _playerCharacterRepository.savePlayerCharacter(playerCharacter);

      saveAttempt.onSuccess(() {
        _eventStreamController.add(playerCharacter);
      }).onFailure((exception) {
        _eventStreamController.addError(exception);
      });
    }
  }

  void _updateState(
      LoadedAddCharacterDialogUiState? Function(LoadedAddCharacterDialogUiState) function,) {
    final currentUiState = currentState;
    if (currentUiState is LoadedAddCharacterDialogUiState) {
      final newUiState = function(currentUiState);
      if (newUiState != null) {
        notify(newUiState);
      }
    }
  }

  ChoiceUiModel _createTraitUiModel(ChoiceType choiceType, {ChoiceUiModel? previousUiModel}) {
    return ChoiceUiModel(
      type: choiceType,
      isEnabled: true,
      isError: previousUiModel?.isError ?? false,
      selectedChild: previousUiModel?.selectedChild,
      children: _traitBonusList.mapToList(
            (traitBonus) =>
            ChoiceChildUiModel(key: traitBonus, name: _traitBonusToString(traitBonus)),
      ),
    );
  }

  String _traitBonusToString(int bonus) => '${bonus >= 0 ? '+' : ''}$bonus';
}
