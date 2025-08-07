import 'package:daggerheart_game_master_companion/models/srd/ability.dart';

class Domain {
  final String name;
  final String description;
  final Map<int, List<Ability>> abilitiesByLevel;

  Domain({required this.name, required this.description, required this.abilitiesByLevel});
}
