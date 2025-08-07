import 'dart:convert';

import 'package:daggerheart_game_master_companion/extensions/list_extensions.dart';
import 'package:daggerheart_game_master_companion/models/srd/ability.dart';
import 'package:daggerheart_game_master_companion/models/srd/daggerheart_class.dart';
import 'package:daggerheart_game_master_companion/models/srd/daggerheart_subclass.dart';
import 'package:daggerheart_game_master_companion/models/srd/domain.dart';
import 'package:daggerheart_game_master_companion/models/srd/feature.dart';
import 'package:daggerheart_game_master_companion/models/srd/trait.dart';
import 'package:flutter/services.dart';

abstract class SrdParser {
  Future<DaggerheartClass?> getClass(String name);

  Future<Domain?> getDomain(String name);

  Future<Ability?> getAbility(String name);

  Future<DaggerheartSubclass?> getSubclass(String name);
}

class SrdParserImpl implements SrdParser {
  Map<String, DaggerheartClass>? _classesCache;
  Map<String, Domain>? _domainsCache;
  Map<String, Ability>? _abilitiesCache;
  Map<String, DaggerheartSubclass>? _subclassesCache;

  @override
  Future<DaggerheartClass?> getClass(String name) async {
    if (_classesCache == null) {
      final map = <String, DaggerheartClass>{};
      final classesString = await rootBundle.loadString(_CLASSES);
      final classesJson = jsonDecode(classesString) as Map<String, dynamic>;
      for (final classEntry in classesJson.entries) {
        final classJson = classEntry.value;
        final String className = classJson["name"];
        final List<Domain> domains = [];
        for (final domainName in classJson["domains"]) {
          final domain = await getDomain(domainName);
          domains.add(domain!);
        }
        final List<DaggerheartSubclass> subclasses = [];
        for (final subclassName in classJson["subclasses"]) {
          final subclass = await getSubclass(subclassName);
          subclasses.add(subclass!);
        }
        final daggerheartClass = DaggerheartClass(
          name: className,
          description: classJson["description"],
          domains: domains,
          startingEvasion: classJson["startingEvasion"],
          startingHitPoints: classJson["startingHitPoints"],
          classItems: classJson["classItems"],
          hopeFeature: _parseFeature(classJson["hopeFeature"]),
          classFeatures: _parseFeatureList(classJson["classFeatures"]),
          subclasses: subclasses,
          backgroundQuestions: classJson["backgroundQuestions"].cast<String>().toList(),
          connections: classJson["connections"].cast<String>().toList(),
        );
        map[classEntry.key] = daggerheartClass;
      }
      _classesCache = map;
    }
    return _classesCache![name];
  }

  @override
  Future<Domain?> getDomain(String name) async {
    if (_domainsCache == null) {
      final map = <String, Domain>{};
      final domainsString = await rootBundle.loadString(_DOMAINS);
      final domainsJson = jsonDecode(domainsString) as Map<String, dynamic>;
      for (final domainEntry in domainsJson.entries) {
        final domainJson = domainEntry.value;
        final String domainName = domainJson["name"];
        final abilitiesByLevelJson = domainJson["abilitiesByLevel"] as Map<String, dynamic>;
        final abilitiesByLevel = <int, List<Ability>>{};
        for (final entry in abilitiesByLevelJson.entries) {
          final abilities = List<Ability>.empty(growable: true);
          final abilityJson = abilitiesByLevelJson[entry.key] as Map<String, dynamic>;
          final int level = abilityJson["level"];
          for (final abilityName in abilityJson["abilities"]) {
            final ability = await getAbility(abilityName);
            abilities.add(ability!);
          }
          abilitiesByLevel[level] = abilities;
        }
        final domain = Domain(name: domainName, description: domainJson["description"], abilitiesByLevel: abilitiesByLevel);
        for (final abilityList in abilitiesByLevel.values) {
          for (final ability in abilityList) {
            ability.domain = domain;
          }
        }
        map[domainEntry.key] = domain;
      }
      _domainsCache = map;
    }
    return _domainsCache![name];
  }

  @override
  Future<Ability?> getAbility(String name) async {
    if (_abilitiesCache == null) {
      final map = <String, Ability>{};
      final abilitiesString = await rootBundle.loadString(_ABILITIES);
      final abilitiesJson = jsonDecode(abilitiesString) as Map<String, dynamic>;
      for (final abilityEntry in abilitiesJson.entries) {
        final abilityJson = abilityEntry.value;
        final String abilityName = abilityJson["name"];

        final ability = Ability(
          name: abilityName,
          level: abilityJson["level"],
          type: _abilityTypeMap[abilityJson["type"]]!,
          recallCost: abilityJson["recallCost"],
          descriptions: (abilityJson["descriptions"] as List<dynamic>).cast<String>().toList(),
        );
        map[abilityEntry.key] = ability;
      }
      _abilitiesCache = map;
    }
    return _abilitiesCache![name];
  }

  @override
  Future<DaggerheartSubclass?> getSubclass(String name) async {
    if (_subclassesCache == null) {
      final map = <String, DaggerheartSubclass>{};
      final subclassesString = await rootBundle.loadString(_SUBCLASSES);
      final subclassesJson = jsonDecode(subclassesString) as Map<String, dynamic>;
      for (final subclassEntry in subclassesJson.entries) {
        final subclassJson = subclassEntry.value;
        final String subclassName = subclassJson["name"];
        final subclass = DaggerheartSubclass(
          name: subclassName,
          description: subclassJson["description"],
          spellcastTrait: subclassJson["spellcastTrait"] == null ? null : _traitMap[subclassJson["spellcastTrait"]],
          foundationFeatures: _parseFeatureList(subclassJson["foundationFeatures"]),
          specializationFeatures: _parseFeatureList(subclassJson["specializationFeatures"]),
          masteryFeatures: _parseFeatureList(subclassJson["masteryFeatures"]),
        );
        map[subclassEntry.key] = subclass;
      }
      _subclassesCache = map;
    }
    return _subclassesCache![name];
  }

  static Feature _parseFeature(dynamic json) =>
      Feature(name: json["name"], description: json["description"], hopeCost: json["hopeCost"], stressCost: json["stressCost"]);

  static List<Feature> _parseFeatureList(dynamic json) => (json as Iterable<dynamic>).mapToList((featureJson) => _parseFeature(featureJson));

  static final _abilityTypeMap = AbilityType.values.asNameMap();
  static final _traitMap = Trait.values.asNameMap();

  static const _FOLDER = "assets/srd";
  static const String _CLASSES = "$_FOLDER/classes.json";
  static const String _DOMAINS = "$_FOLDER/domains.json";
  static const String _ABILITIES = "$_FOLDER/abilities.json";
  static const String _SUBCLASSES = "$_FOLDER/subclasses.json";
}
