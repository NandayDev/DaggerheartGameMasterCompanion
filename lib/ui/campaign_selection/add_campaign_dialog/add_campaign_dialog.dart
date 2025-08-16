import 'package:daggerheart_game_master_companion/l10n/app_localizations.dart';
import 'package:daggerheart_game_master_companion/models/srd/player_character.dart';
import 'package:daggerheart_game_master_companion/ui/base/daggerheart_state.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/add_campaign_dialog/add_campaign_dialog_view_model.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/add_campaign_dialog/add_character_dialog/add_character_dialog.dart';
import 'package:flutter/material.dart';

class AddCampaignDialog extends StatefulWidget {
  const AddCampaignDialog({super.key});

  @override
  State<AddCampaignDialog> createState() => _AddCampaignDialogState();
}

class _AddCampaignDialogState extends DaggerheartState<AddCampaignDialog, AddCampaignDialogViewModel> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final characters = []; //TODO
    final localizations = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(localizations.addCampaignDialogNewCampaign),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: localizations.addCampaignDialogCampaignName),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("${localizations.addCampaignDialogCharacters}:", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            if (characters.isEmpty) Text(localizations.addCampaignDialogNoCharacterAdded),
            ...characters.map(
              (char) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(char),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      characters.remove(char);
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () async {
                  final character = await showDialog<PlayerCharacter>(context: context, builder: (context) => const AddCharacterDialog());
                  if (character != null) {
                    viewModel.createPlayerCharacter(character);
                  }
                },
                icon: const Icon(Icons.add),
                label: Text(localizations.addCampaignDialogAddCharacter),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(localizations.cancel)),
        TextButton(
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isNotEmpty && characters.isNotEmpty) {
              Navigator.of(context).pop({'name': name, 'characters': characters});
            } else {
              // TODO error?
            }
          },
          child: Text(localizations.save),
        ),
      ],
    );
  }
}
