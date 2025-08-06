import 'package:daggerheart_game_master_companion/models/srd/feature.dart';
import 'package:daggerheart_game_master_companion/models/srd/trait.dart';

class DaggerheartSubclass {
  final String name;
  final String description;
  final Trait? spellcastTrait;
  final List<Feature> foundationFeatures;
  final List<Feature> specializationFeatures;
  final List<Feature> masteryFeatures;

  DaggerheartSubclass({
    required this.name,
    required this.description,
    required this.spellcastTrait,
    required this.foundationFeatures,
    required this.specializationFeatures,
    required this.masteryFeatures,
  });
}
