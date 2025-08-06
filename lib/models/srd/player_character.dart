import 'package:daggerheart_game_master_companion/models/srd/daggerheart_class.dart';
import 'package:daggerheart_game_master_companion/models/srd/daggerheart_subclass.dart';
import 'package:daggerheart_game_master_companion/models/srd/domain.dart';

class PlayerCharacter {
  final String key;
  final DaggerheartClass daggerheartClass;
  final int level;
  final Domain domain;
  final DaggerheartSubclass subclass;
  final List<String> notes;

  PlayerCharacter({
    required this.key,
    required this.daggerheartClass,
    required this.level,
    required this.domain,
    required this.subclass,
    required this.notes,
  });
}
