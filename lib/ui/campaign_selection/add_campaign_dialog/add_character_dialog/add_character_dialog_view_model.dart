import 'package:daggerheart_game_master_companion/services/data/player_characters_repository.dart';
import 'package:daggerheart_game_master_companion/services/srd_parser.dart';
import 'package:daggerheart_game_master_companion/ui/base/view_model.dart';

class AddCharacterDialogViewModel extends ViewModel {
  final SrdParser _srdParser;
  final PlayerCharacterRepository _playerCharacterRepository;

  AddCharacterDialogViewModel(this._srdParser, this._playerCharacterRepository);

  void initialize() async {}
}
