import 'package:daggerheart_game_master_companion/models/srd/player_character.dart';

class Campaign {
  final String key;
  final String name;
  final DateTime created;
  final List<PlayerCharacter> characters;

  Campaign({required this.key, required this.name, required this.created, required this.characters});
}
