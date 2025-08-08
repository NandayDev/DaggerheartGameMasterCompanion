import 'package:daggerheart_game_master_companion/models/srd/feature.dart';

class Community {
  final String key;
  final String name;
  final String description;
  final String individualDescription;
  final Feature communityFeature;

  Community({required this.key, required this.name, required this.description, required this.individualDescription, required this.communityFeature});
}
