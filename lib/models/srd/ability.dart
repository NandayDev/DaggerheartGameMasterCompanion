import 'package:daggerheart_game_master_companion/models/srd/domain.dart';

class Ability {
  final String name;
  final Domain domain;
  final int level;
  final AbilityType type;
  final int recallCost;
  final List<String> descriptions;

  Ability({required this.name, required this.domain, required this.level, required this.type, required this.recallCost, required this.descriptions});
}

enum AbilityType { ABILITY, SPELL }
