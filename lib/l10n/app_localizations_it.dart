// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get cancel => 'Annulla';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Conferma';

  @override
  String get save => 'Salva';

  @override
  String get campaignSelection => 'Selezione campagna';

  @override
  String get combat => 'Combattimento';

  @override
  String get campaignSelectionAddCampaignHint => 'Crea una nuova campagna per iniziare!';

  @override
  String get campaignSelectionAddCampaign => 'Crea una nuova campagna';

  @override
  String get campaignSelectionError => 'Errore nel caricamento della campagna. I dati potrebbero essere stati alterati.';

  @override
  String get addCampaignDialogNewCampaign => 'Nuova campagna';

  @override
  String get addCampaignDialogCampaignName => 'Nome della campagna';

  @override
  String get addCampaignDialogCharacters => 'Personaggi';

  @override
  String get addCampaignDialogNoCharacterAdded => 'Nessun personaggio aggiunto';

  @override
  String get addCampaignDialogAddCharacter => 'Aggiungi personaggio';
}
