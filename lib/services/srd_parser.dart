import 'dart:convert';

import 'package:daggerheart_game_master_companion/extensions/list_extensions.dart';
import 'package:daggerheart_game_master_companion/models/srd/ability.dart';
import 'package:daggerheart_game_master_companion/models/srd/ancestry.dart';
import 'package:daggerheart_game_master_companion/models/srd/community.dart';
import 'package:daggerheart_game_master_companion/models/srd/daggerheart_class.dart';
import 'package:daggerheart_game_master_companion/models/srd/daggerheart_subclass.dart';
import 'package:daggerheart_game_master_companion/models/srd/domain.dart';
import 'package:daggerheart_game_master_companion/models/srd/feature.dart';
import 'package:daggerheart_game_master_companion/models/srd/trait.dart';
import 'package:flutter/services.dart';

abstract class SrdParser {
  Future<Iterable<DaggerheartClass>> getAllClasses();

  Future<DaggerheartClass?> getClass(String key);

  Future<Iterable<Domain>> getAllDomains();

  Future<Domain?> getDomain(String key);

  Future<Ability?> getAbility(String key);

  Future<DaggerheartSubclass?> getSubclass(String key);

  Future<Iterable<Ancestry>> getAllAncestries();

  Future<Iterable<Community>> getAllCommunities();
}

class SrdParserImpl implements SrdParser {
  Map<String, DaggerheartClass>? _classesCache;
  Map<String, Domain>? _domainsCache;
  Map<String, Ability>? _abilitiesCache;
  Map<String, DaggerheartSubclass>? _subclassesCache;
  Map<String, Ancestry>? _ancestriesCache;
  Map<String, Community>? _communitiesCache;

  @override
  Future<Iterable<DaggerheartClass>> getAllClasses() async {
    await _fillClassesCache();
    return _classesCache!.values;
  }

  @override
  Future<DaggerheartClass?> getClass(String key) async {
    await _fillClassesCache();
    return _classesCache![key];
  }

  @override
  Future<Iterable<Domain>> getAllDomains() async {
    await _fillDomainsCache();
    return _domainsCache!.values;
  }

  @override
  Future<Domain?> getDomain(String key) async {
    await _fillDomainsCache();
    return _domainsCache![key];
  }

  @override
  Future<Ability?> getAbility(String key) async {
    if (_abilitiesCache == null) {
      final map = <String, Ability>{};
      final abilitiesString = await rootBundle.loadString(_ABILITIES);
      final abilitiesJson = jsonDecode(abilitiesString) as Map<String, dynamic>;
      for (final abilityEntry in abilitiesJson.entries) {
        final json = abilityEntry.value;
        final String abilityName = json["name"];

        final ability = Ability(
          key: json["key"],
          name: abilityName,
          level: json["level"],
          type: _abilityTypeMap[json["type"]]!,
          recallCost: json["recallCost"],
          descriptions: (json["descriptions"] as List<dynamic>).cast<String>().toList(),
        );
        map[abilityEntry.key] = ability;
      }
      _abilitiesCache = map;
    }
    return _abilitiesCache![key];
  }

  @override
  Future<DaggerheartSubclass?> getSubclass(String key) async {
    if (_subclassesCache == null) {
      final map = <String, DaggerheartSubclass>{};
      final subclassesString = await rootBundle.loadString(_SUBCLASSES);
      final subclassesJson = jsonDecode(subclassesString) as Map<String, dynamic>;
      for (final subclassEntry in subclassesJson.entries) {
        final json = subclassEntry.value;
        final String subclassName = json["name"];
        final subclass = DaggerheartSubclass(
          key: json["key"],
          name: subclassName,
          description: json["description"],
          spellcastTrait: json["spellcastTrait"] == null ? null : _traitMap[json["spellcastTrait"]],
          foundationFeatures: _parseFeatureList(json["foundationFeatures"]),
          specializationFeatures: _parseFeatureList(json["specializationFeatures"]),
          masteryFeatures: _parseFeatureList(json["masteryFeatures"]),
        );
        map[subclassEntry.key] = subclass;
      }
      _subclassesCache = map;
    }
    return _subclassesCache![key];
  }

  @override
  Future<Iterable<Ancestry>> getAllAncestries() async {
    if (_ancestriesCache == null) {
      final map = <String, Ancestry>{};
      final ancestriesString = await rootBundle.loadString(_ANCESTRIES);
      final ancestriesJson = jsonDecode(ancestriesString) as Map<String, dynamic>;
      for (final ancestryEntry in ancestriesJson.entries) {
        final json = ancestryEntry.value;
        map[ancestryEntry.key] = Ancestry(
          key: ancestryEntry.key,
          name: json["name"],
          description: json["description"],
          features: _parseFeatureList(json["features"]),
        );
        _ancestriesCache = map;
      }
    }
    return _ancestriesCache!.values;
  }

  @override
  Future<Iterable<Community>> getAllCommunities() async {
    if (_communitiesCache == null) {
      final map = <String, Community>{};
      final communitiesString = await rootBundle.loadString(_COMMUNITIES);
      final communitiesJson = jsonDecode(communitiesString) as Map<String, dynamic>;
      for (final communityEntry in communitiesJson.entries) {
        final json = communityEntry.value;
        map[communityEntry.key] = Community(
          key: communityEntry.key,
          name: json["name"],
          description: json["description"],
          individualDescription: json["individualDescription"],
          communityFeature: _parseFeature(json["communityFeature"]),
        );
        _communitiesCache = map;
      }
    }
    return _communitiesCache!.values;
  }

  Future<void> _fillClassesCache() async {
    if (_classesCache == null) {
      final map = <String, DaggerheartClass>{};
      final classesString = await rootBundle.loadString(_CLASSES);
      final classesJson = jsonDecode(classesString) as Map<String, dynamic>;
      for (final classEntry in classesJson.entries) {
        final json = classEntry.value;
        final String className = json["name"];
        final List<Domain> domains = [];
        for (final domainName in json["domains"]) {
          final domain = await getDomain(domainName);
          domains.add(domain!);
        }
        final List<DaggerheartSubclass> subclasses = [];
        for (final subclassName in json["subclasses"]) {
          final subclass = await getSubclass(subclassName);
          subclasses.add(subclass!);
        }
        final daggerheartClass = DaggerheartClass(
          key: json["key"],
          name: className,
          description: json["description"],
          domains: domains,
          startingEvasion: json["startingEvasion"],
          startingHitPoints: json["startingHitPoints"],
          classItems: json["classItems"],
          hopeFeature: _parseFeature(json["hopeFeature"]),
          classFeatures: _parseFeatureList(json["classFeatures"]),
          subclasses: subclasses,
          backgroundQuestions: json["backgroundQuestions"].cast<String>().toList(),
          connections: json["connections"].cast<String>().toList(),
        );
        map[classEntry.key] = daggerheartClass;
      }
      _classesCache = map;
    }
  }

  Future<void> _fillDomainsCache() async {
    if (_domainsCache == null) {
      final map = <String, Domain>{};
      final domainsString = await rootBundle.loadString(_DOMAINS);
      final domainsJson = jsonDecode(domainsString) as Map<String, dynamic>;
      for (final domainEntry in domainsJson.entries) {
        final json = domainEntry.value;
        final String domainName = json["name"];
        final abilitiesByLevelJson = json["abilitiesByLevel"] as Map<String, dynamic>;
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
        final domain = Domain(key: json["key"], name: domainName, description: json["description"], abilitiesByLevel: abilitiesByLevel);
        for (final abilityList in abilitiesByLevel.values) {
          for (final ability in abilityList) {
            ability.domain = domain;
          }
        }
        map[domainEntry.key] = domain;
      }
      _domainsCache = map;
    }
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
  static const String _ANCESTRIES = "$_FOLDER/ancestries.json";
  static const String _COMMUNITIES = "$_FOLDER/communities.json";
}
