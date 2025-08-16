import 'package:daggerheart_game_master_companion/models/srd/player_character.dart';
import 'package:daggerheart_game_master_companion/services/data/player_characters_repository.dart';
import 'package:daggerheart_game_master_companion/ui/base/view_model.dart';

class AddCampaignDialogViewModel extends ViewModel {
  AddCampaignDialogViewModel(this._playerCharacterRepository);

  final PlayerCharacterRepository _playerCharacterRepository;

  void initialize() async {}

  void createPlayerCharacter(PlayerCharacter character) {}
}
