import 'package:daggerheart_game_master_companion/l10n/app_localizations.dart';
import 'package:daggerheart_game_master_companion/ui/base/daggerheart_state.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/add_campaign_dialog/add_character_dialog/add_character_dialog_view_model.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/add_campaign_dialog/add_character_dialog/choice_ui_model.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/add_campaign_dialog/add_character_dialog/class_ui_model.dart';
import 'package:flutter/material.dart';

Future showAddCharacterDialog(BuildContext context) async {
  showDialog(context: context, builder: (context) =>)
}

class AddCharacterDialog extends StatefulWidget {
  const AddCharacterDialog({super.key});

  @override
  State<AddCharacterDialog> createState() => _AddCharacterDialogState();
}

class _AddCharacterDialogState extends DaggerheartState<AddCharacterDialog, AddCharacterDialogViewModel> {

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(localizations.addCharacterDialogTitle),
      content: Column(children: [
        _createDropdown(classUiModel, (selectedChild) {
          classUiModel = classUiModel.select(selectedChild);
        })
      ],),
    );
  }

  DropdownButton _createDropdown(ChoiceUiModel uiModel, Function(ChoiceChildUiModel?) onSelectedValueChanged) {
    return DropdownButton<ChoiceChildUiModel>(
      value: uiModel.selectedChild,
      hint: const Text('Seleziona una classe'),
      items: uiModel.children.map((option) {
        return DropdownMenuItem<ChoiceChildUiModel>(
          value: option,
          child: Text(option.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          onSelectedValueChanged(value);
        });
      },
    );
  }
}
