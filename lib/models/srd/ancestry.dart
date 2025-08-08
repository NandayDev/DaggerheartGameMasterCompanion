import 'package:daggerheart_game_master_companion/models/srd/feature.dart';

class Ancestry {
  final String key;
  final String name;
  final String description;
  final List<Feature> features;

  Ancestry({required this.key, required this.name, required this.description, required this.features});
}
