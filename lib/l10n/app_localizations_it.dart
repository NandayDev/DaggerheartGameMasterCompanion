// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

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
}
