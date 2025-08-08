import 'package:daggerheart_game_master_companion/extensions/list_extensions.dart';
import 'package:daggerheart_game_master_companion/l10n/app_localizations.dart';
import 'package:daggerheart_game_master_companion/ui/base/daggerheart_state.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/add_campaign_dialog/add_character_dialog/add_character_dialog_ui_state.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/add_campaign_dialog/add_character_dialog/add_character_dialog_view_model.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/add_campaign_dialog/add_character_dialog/choice_ui_model.dart';
import 'package:daggerheart_game_master_companion/ui/shared/button.dart';
import 'package:flutter/material.dart';

class AddCharacterDialog extends StatefulWidget {
  const AddCharacterDialog({super.key});

  @override
  State<AddCharacterDialog> createState() => _AddCharacterDialogState();
}

class _AddCharacterDialogState extends DaggerheartState<AddCharacterDialog, AddCharacterDialogViewModel> {
  @override
  void initState() {
    viewModel.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    final uiState = state as LoadedAddCharacterDialogUiState;
    return AlertDialog(
      title: Text(localizations.addCharacterDialogTitle),
      content: SizedBox(
        width: 1000,
        child: Column(
          spacing: 15.0,
          children: [
            Row(
              spacing: 100.0,
              children: [
                _createDropdown(
                    uiState.classUiModel, 450, localizations.daggerheartClass, localizations.addCharacterDialogSelectClass, (selectedChild,) {
                  viewModel.classChanged(selectedChild);
                }),
                _createDropdown(
                    uiState.subclassUiModel, 450, localizations.subclass, localizations.addCharacterDialogSelectSubclass, (selectedChild,) {
                  viewModel.subclassChanged(selectedChild);
                }),
              ],
            ),
            Row(
              spacing: 100.0,
              children: [
                _createDropdown(
                    uiState.ancestryUiModel, 450, localizations.ancestry, localizations.addCharacterDialogSelectAncestry, (selectedChild,) {
                  viewModel.ancestryChanged(selectedChild);
                }),
                _createDropdown(
                    uiState.communityUiModel, 450, localizations.community, localizations.addCharacterDialogSelectCommunity, (selectedChild,) {
                  viewModel.communityChanged(selectedChild);
                }),
              ],
            ),
            Row(
              spacing: 20.0,

              children: [
                _createDropdown(uiState.agilityUiModel, 130, localizations.agility, "", (selectedChild) {
                  viewModel.traitChanged(ChoiceType.Agility, selectedChild);
                }),
                _createDropdown(uiState.strengthUiModel, 130, localizations.strength, "", (selectedChild) {
                  viewModel.traitChanged(ChoiceType.Strength, selectedChild);
                }),
                _createDropdown(uiState.finesseUiModel, 130, localizations.finesse, "", (selectedChild) {
                  viewModel.traitChanged(ChoiceType.Finesse, selectedChild);
                }),
                _createDropdown(uiState.instinctUiModel, 130, localizations.instinct, "", (selectedChild) {
                  viewModel.traitChanged(ChoiceType.Instinct, selectedChild);
                }),
                _createDropdown(uiState.presenceUiModel, 130, localizations.presence, "", (selectedChild) {
                  viewModel.traitChanged(ChoiceType.Presence, selectedChild);
                }),
                _createDropdown(uiState.knowledgeUiModel, 130, localizations.knowledge, "", (selectedChild) {
                  viewModel.traitChanged(ChoiceType.Knowledge, selectedChild);
                }),
                Column(
                  children: [
                    SizedBox(height: 20,),
                    SizedBox(
                      width: 100,
                      child: DaggerheartButton(
                        text: localizations.addCharacterDialogResetTraits,
                        onPressed: () {
                          viewModel.resetTraits();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            DaggerheartButton(
              text: localizations.save,
              onPressed: () {
                final playerCharacter = viewModel.buildPlayerCharacter();
                if (playerCharacter != null) {
                  Navigator.of(context).pop(playerCharacter);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localizations.addCharacterDialogSaveError)));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDropdown(ChoiceUiModel uiModel, double width, String title, String hint, Function(ChoiceChildUiModel?) onSelectedValueChanged) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5.0,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(title, style: theme.textTheme.labelSmall),
        ),
        DropdownMenu(
          key: ValueKey(uiModel.key),
          enabled: uiModel.isEnabled,
          width: width,
          hintText: hint,
          enableFilter: false,
          requestFocusOnTap: false,
          initialSelection: uiModel.selectedChild,
          onSelected: (child) {
            onSelectedValueChanged(child);
          },
          dropdownMenuEntries: uiModel.children.mapToList((choice) {
            return DropdownMenuEntry<ChoiceChildUiModel>(value: choice, label: choice.name);
          }),
        ),
      ],
    );
  }
}
