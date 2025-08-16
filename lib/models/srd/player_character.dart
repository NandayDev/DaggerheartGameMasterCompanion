import 'package:daggerheart_game_master_companion/models/srd/ability.dart';
import 'package:daggerheart_game_master_companion/models/srd/ancestry.dart';
import 'package:daggerheart_game_master_companion/models/srd/community.dart';
import 'package:daggerheart_game_master_companion/models/srd/daggerheart_class.dart';
import 'package:daggerheart_game_master_companion/models/srd/daggerheart_subclass.dart';

class PlayerCharacter {
  final String key;
  final String name;
  final DaggerheartClass daggerheartClass;
  final Ancestry ancestry;
  final Community community;
  final int level;
  final List<Ability> domainAbilities;
  final DaggerheartSubclass subclass;
  final List<String> backgroundAnswers;
  final List<String> notes;

  PlayerCharacter({
    required this.key,
    required this.name,
    required this.daggerheartClass,
    required this.ancestry,
    required this.community,
    required this.level,
    required this.domainAbilities,
    required this.subclass,
    required this.backgroundAnswers,
    required this.notes,
  });
}
