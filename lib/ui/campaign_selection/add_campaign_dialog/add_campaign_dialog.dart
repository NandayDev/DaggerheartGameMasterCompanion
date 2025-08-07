import 'package:daggerheart_game_master_companion/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

Future showCreateCampaignDialog(BuildContext context) async {
  final TextEditingController nameController = TextEditingController();
  final List<String> characters = [];
  final localizations = AppLocalizations.of(context)!;
  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(localizations.addCampaignDialogNewCampaign),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Campo per il nome
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: localizations.addCampaignDialogCampaignName),
                  ),
                  const SizedBox(height: 16),
                  // Lista dei personaggi
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
                  // Bottone per aggiungere un personaggio
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        // Secondo dialog per inserire personaggio
                        // TODO
                        // _showAddCharacterDialog(context, (newCharacter) {
                        //   setState(() {
                        //     characters.add(newCharacter);
                        //   });
                        // });
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
                    // Esegui qualcosa con i dati raccolti
                    Navigator.of(context).pop({'name': name, 'characters': characters});
                  } else {
                    // Puoi aggiungere un messaggio di errore se vuoi
                  }
                },
                child: Text(localizations.save),
              ),
            ],
          );
        },
      );
    },
  );
}
