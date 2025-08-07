import 'package:daggerheart_game_master_companion/models/srd/domain.dart';

class Ability {
  final String name;
  final int level;
  final AbilityType type;
  final int recallCost;
  final List<String> descriptions;

  late Domain domain;

  Ability({required this.name, required this.level, required this.type, required this.recallCost, required this.descriptions});
}

enum AbilityType { Ability, Spell, Grimoire }
