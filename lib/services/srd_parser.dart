import 'dart:convert';

import 'package:daggerheart_game_master_companion/models/srd/daggerheart_class.dart';
import 'package:daggerheart_game_master_companion/models/srd/domain.dart';
import 'package:daggerheart_game_master_companion/models/srd/feature.dart';
import 'package:flutter/services.dart';

abstract class SrdParser {
  Future<DaggerheartClass> getClass(String name);
}

class SrdParserImpl implements SrdParser {
  Map<String, DaggerheartClass>? classesCache;
  Map<String, Domain>? domainsCache;

  @override
  Future<DaggerheartClass?> getClass(String name) async {
    if (classesCache == null) {
      final classesString = await rootBundle.loadString(_CLASSES);
      final classesJson = jsonDecode(classesString) as Map<String, dynamic>;
      for (final classJson in classesJson.values) {
        final daggerheartClass = DaggerheartClass(
          name: classJson["name"],
          description: classJson["description"],
          domains: classJson["domains"],
          startingEvasion: classJson["startingEvasion"],
          startingHitPoints: classJson["startingHitPoints"],
          classItems: classJson["classItems"],
          hopeFeature: Feature(
            name: classJson["hopeFeature"]["name"],
            description: classJson["hopeFeature"]["description"],
            hopeCost: classJson["hopeFeature"]["hopeCost"],
            stressCost: classJson["hopeFeature"]["stressCost"],
          ),
          classFeatures: classJson["classFeatures"],
          subclasses: classJson["subclasses"],
          backgroundQuestions: classJson["backgroundQuestions"],
          connections: classJson["connections"],
        );
      }
    }
    return classesCache![name];
  }

  Future<Domain> _getDomain(String name) async {
    if (domainsCache == null) {}
    return domainsCache![name]!;
  }

  static const _FOLDER = "assets/srd";
  static const String _CLASSES = "$_FOLDER/classes.json";
}
