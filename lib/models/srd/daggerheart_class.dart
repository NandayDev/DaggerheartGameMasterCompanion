import 'package:daggerheart_game_master_companion/models/srd/daggerheart_subclass.dart';
import 'package:daggerheart_game_master_companion/models/srd/domain.dart';
import 'package:daggerheart_game_master_companion/models/srd/feature.dart';

class DaggerheartClass {
  final String key;
  final String name;
  final String description;
  final List<Domain> domains;
  final int startingEvasion;
  final int startingHitPoints;
  final String classItems;
  final Feature hopeFeature;
  final List<Feature> classFeatures;
  final List<DaggerheartSubclass> subclasses;
  final List<String> backgroundQuestions;
  final List<String> connections;

  DaggerheartClass({
    required this.key,
    required this.name,
    required this.description,
    required this.domains,
    required this.startingEvasion,
    required this.startingHitPoints,
    required this.classItems,
    required this.hopeFeature,
    required this.classFeatures,
    required this.subclasses,
    required this.backgroundQuestions,
    required this.connections,
  });
}
