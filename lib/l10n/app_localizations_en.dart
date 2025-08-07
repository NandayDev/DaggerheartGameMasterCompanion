// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get campaignSelection => 'Campaign selection';

  @override
  String get combat => 'Combat';

  @override
  String get campaignSelectionAddCampaignHint => 'No campaigns saved. Why don\'t you start a new one?';

  @override
  String get campaignSelectionAddCampaign => 'Create new campaign';

  @override
  String get campaignSelectionError => 'Error while loading this campaign. Data may have been altered.';

  @override
  String get addCampaignDialogNewCampaign => 'New campaign';

  @override
  String get addCampaignDialogCampaignName => 'Campaign name';

  @override
  String get addCampaignDialogCharacters => 'Player characters';

  @override
  String get addCampaignDialogNoCharacterAdded => 'No character added';

  @override
  String get addCampaignDialogAddCharacter => 'Add character';
}
