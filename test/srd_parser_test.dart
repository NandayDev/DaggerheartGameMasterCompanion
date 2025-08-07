import 'package:daggerheart_game_master_companion/models/srd/daggerheart_class.dart';
import 'package:daggerheart_game_master_companion/services/srd_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final srdParser = SrdParserImpl();
  test("Class parsing returns all classes", () async {
    final classes = ["bard", "druid", "guardian", "ranger", "rogue", "seraph", "sorcerer", "warrior", "wizard"];
    for (final className in classes) {
      final daggerheartClass = await srdParser.getClass(className);
      expect(daggerheartClass, isNotNull);
    }
  });
  test("getClass('bard') should correctly parse Bard class data", () async {
    final DaggerheartClass? bardClass = await srdParser.getClass("bard");

    expect(bardClass, isNotNull);
    expect(bardClass, isA<DaggerheartClass>());

    expect(bardClass!.name, "Bard");
    expect(
      bardClass.description,
      "Bards are the most charismatic people in all the realms. Members of this class are masters of captivation and specialize in a variety of performance types, including singing, playing musical instruments, weaving tales, or telling jokes. Whether performing for an audience or speaking to an individual, bards thrive in social situations. Members of this profession bond and train at schools or guilds, but a current of egotism runs through those of the bardic persuasion. While they may be the most likely class to bring people together, a bard of ill temper can just as easily tear a party apart.",
    );
    expect(bardClass.domains.length, 2);
    expect(bardClass.domains[0].name, "Grace");
    expect(bardClass.domains[1].name, "Codex");
    expect(bardClass.startingEvasion, 10);
    expect(bardClass.startingHitPoints, 5);
    expect(bardClass.classItems, "A romance novel or a letter never opened");

    expect(bardClass.hopeFeature.name, "Make a Scene");
    expect(
      bardClass.hopeFeature.description,
      "Spend 3 Hope to temporarily Distract a target within Close range, giving them a -2 penalty to their Difficulty.",
    );
    expect(bardClass.hopeFeature.hopeCost, 3);

    expect(bardClass.classFeatures, hasLength(1));
    expect(bardClass.classFeatures[0].name, "Rally");
    expect(
      bardClass.classFeatures[0].description,
      "Once per session, describe how you rally the party and give yourself and each of your allies a Rally Die. At level 1, your Rally Die is a d6. A PC can spend their Rally Die to roll it, adding the result to their action roll, reaction roll, damage roll, or to clear a number of Stress equal to the result. At the end of each session, clear all unspent Rally Dice. At level 5, your Rally Die increases to a d8.",
    );

    expect(bardClass.subclasses.length, 2);
    expect(bardClass.subclasses[0].name, "Troubadour");
    expect(bardClass.subclasses[1].name, "Wordsmith");
    expect(
      bardClass.backgroundQuestions,
      equals([
        "Who from your community taught you to have such confidence in yourself?",
        "You were in love once. Who did you adore, and how did they hurt you?",
        "You've always looked up to another bard. Who are they, and why do you idolize them?",
      ]),
    );
    expect(
      bardClass.connections,
      equals(["What made you realize we were going to be such good friends?", "What do I do that annoys you?", "Why do you grab my hand at night?"]),
    );
  });

  test("getClass('druid') should correctly parse Druid class data with resolved objects", () async {
    final DaggerheartClass? druidClass = await srdParser.getClass("druid");

    expect(druidClass, isNotNull);
    expect(druidClass, isA<DaggerheartClass>());

    expect(druidClass!.key, "druid");
    expect(druidClass.name, "Druid");
    expect(druidClass.description,
        "Becoming a druid is more than an occupation; it's a calling for those who wish to learn from and protect the magic of the wilderness. While one might underestimate a gentle druid who practices the often-quiet work of cultivating flora, druids who channel the untamed forces of nature are terrifying to behold. Druids cultivate their abilities in small groups, often connected by a specific ethos or locale, but some choose to work alone. Through years of study and dedication, druids can learn to transform into beasts and shape nature itself.");
    expect(druidClass.startingEvasion, 10);
    expect(druidClass.startingHitPoints, 6);
    expect(druidClass.classItems, "A small bag of rocks and bones or a strange pendant found in the dirt");

    expect(druidClass.hopeFeature.name, "Evolution");
    expect(druidClass.hopeFeature.description,
        "Spend 3 Hope to transform into a Beastform without marking a Stress. When you do, choose one trait to raise by +1 until you drop out of that Beastform.");
    expect(druidClass.hopeFeature.hopeCost, 3); // Assumendo che Feature.fromJson gestisca hopeCost

    expect(druidClass.classFeatures, hasLength(2));
    expect(druidClass.classFeatures[0].name, "Beastform");
    expect(druidClass.classFeatures[1].name, "Wildtouch");

    expect(druidClass.domains, hasLength(2));
    expect(druidClass.domains.any((d) => d.key == "sage" && d.name == "Sage"), isTrue);
    expect(druidClass.domains.any((d) => d.key == "arcana" && d.name == "Arcana"), isTrue);

    expect(druidClass.subclasses, hasLength(2));
    expect(druidClass.subclasses.any((s) => s.key == "warden of the elements" && s.name == "Warden of the Elements"), isTrue);
    expect(druidClass.subclasses.any((s) => s.key == "warden of renewal" && s.name == "Warden of Renewal"), isTrue);

    expect(druidClass.backgroundQuestions, equals([
      "Why was the community you grew up in so reliant on nature and its creatures?",
      "Who was the first wild animal you bonded with? Why did your bond end?",
      "Who has been trying to hunt you down? What do they want from you?"
    ]));
    expect(druidClass.connections, equals([
      "What did you confide in me that makes me leap into danger for you every time?",
      "What animal do I say you remind me of?",
      "What affectionate nickname have you given me?"
    ]));
  });

  test("getClass('guardian') should correctly parse Guardian class data with resolved objects", () async {
    final DaggerheartClass? guardianClass = await srdParser.getClass("guardian");

    expect(guardianClass, isNotNull);
    expect(guardianClass, isA<DaggerheartClass>());

    expect(guardianClass!.key, "guardian");
    expect(guardianClass.name, "Guardian");
    expect(
        guardianClass.description,
        "The title of guardian represents an array of martial professions, speaking more to their moral compass and unshakeable fortitude than the means by which they fight. While many guardians join groups of militants for either a country or cause, they're more likely to follow those few they truly care for, majority be damned. Guardians are known for fighting with remarkable ferocity even against overwhelming odds, defending their cohort above all else. Woe betide those who harm the ally of a guardian, as the guardian will answer this injury in kind.");
    expect(guardianClass.startingEvasion, 9);
    expect(guardianClass.startingHitPoints, 7);
    expect(guardianClass.classItems, "A totem from your mentor or a secret key");

    expect(guardianClass.hopeFeature.name, "Frontline Tank");
    expect(guardianClass.hopeFeature.description, "Spend 3 Hope to clear 2 Armor Slots.");
    expect(guardianClass.hopeFeature.hopeCost, 3);

    expect(guardianClass.classFeatures, hasLength(2));
    expect(guardianClass.classFeatures[0].name, "Unstoppable");
    expect(
        guardianClass.classFeatures[0].description,
        "Once per long rest, you can become Unstoppable. You gain an Unstoppable Die. At level 1, your Unstoppable Die is a d4. Place it on your character sheet in the space provided, starting with the 1 value facing up. After you make a damage roll that deals 1 or more Hit Points to a target, increase the Unstoppable Die value by one. When the die's value would exceed its maximum value or when the scene ends, remove the die and drop out of Unstoppable. At level 5, your Unstoppable Die increases to a d6.\n\nWhile Unstoppable, you gain the following benefits:\n\n- You reduce the severity of physical damage by one threshold (Severe to Major, Major to Minor, Minor to None).\n- You add the current value of the Unstoppable Die to your damage roll.\n- You can't be Restrained or Vulnerable.");
    expect(guardianClass.classFeatures[1].name, "Tip");
    expect(
        guardianClass.classFeatures[1].description,
        "*If your Unstoppable Die is a d4 and the 4 is currently facing up, you remove the die the next time you would increase it. However, if your Unstoppable Die has increased to a d6 and the 4 is currently facing up, you'll turn it to 5 the next time you would increase it. In this case, you'll remove the die after you would need to increase it higher than 6.*");

    expect(guardianClass.domains, hasLength(2));
    expect(guardianClass.domains.any((d) => d.key == "valor" && d.name == "Valor"), isTrue);
    expect(guardianClass.domains.any((d) => d.key == "blade" && d.name == "Blade"), isTrue);

    expect(guardianClass.subclasses, hasLength(2));
    expect(guardianClass.subclasses.any((s) => s.key == "stalwart" && s.name == "Stalwart"), isTrue);
    expect(guardianClass.subclasses.any((s) => s.key == "vengeance" && s.name == "Vengeance"), isTrue);

    expect(
        guardianClass.backgroundQuestions,
        equals([
          "Who from your community did you fail to protect, and why do you still think of them?",
          "You've been tasked with protecting something important and delivering it somewhere dangerous. What is it, and where does it need to go?",
          "You consider an aspect of yourself to be a weakness. What is it, and how has it affected you?"
        ]));
    expect(
        guardianClass.connections,
        equals([
          "How did I save your life the first time we met?",
          "What small gift did you give me that you notice I always carry with me?",
          "What lie have you told me about yourself that I absolutely believe?"
        ]));
  });

  test("getClass('ranger') should correctly parse Ranger class data", () async {
    final DaggerheartClass? rangerClass = await srdParser.getClass("ranger");

    expect(rangerClass, isNotNull);
    expect(rangerClass, isA<DaggerheartClass>());

    expect(rangerClass!.key, "ranger");
    expect(rangerClass.name, "Ranger");
    expect(
        rangerClass.description,
        "Rangers are highly skilled hunters who, despite their martial abilities, rarely lend their skills to an army. Through mastery of the body and a deep understanding of the wilderness, rangers become sly tacticians, pursuing their quarry with cunning and patience. Many rangers track and fight alongside an animal companion with whom they've forged a powerful spiritual bond. By honing their skills in the wild, rangers become expert trackers, as likely to ensnare their foes in a trap as they are to assail them head-on.");
    expect(rangerClass.startingEvasion, 12);
    expect(rangerClass.startingHitPoints, 6);
    expect(rangerClass.classItems, "A trophy from your first kill or a seemingly broken compass");

    // Verifica Hope Feature
    // Assicurati che la tua classe Feature possa gestire hopeCost e stressCost
    expect(rangerClass.hopeFeature.name, "Hold Them Off");
    expect(
        rangerClass.hopeFeature.description,
        "Spend 3 Hope when you succeed on an attack with a weapon to use that same roll against two additional adversaries within range of the attack.");
    expect(rangerClass.hopeFeature.hopeCost, 3);
    // expect(rangerClass.hopeFeature.stressCost, 0); // Se presente e rilevante

    // Verifica Class Features
    expect(rangerClass.classFeatures, hasLength(1));
    expect(rangerClass.classFeatures[0].name, "Ranger's Focus");
    expect(
        rangerClass.classFeatures[0].description,
        "Spend a Hope and make an attack against a target. On a success, deal your attack's normal damage and temporarily make the attack's target your Focus. Until this feature ends or you make a different creature your Focus, you gain the following benefits against your Focus:\n\n- You know precisely what direction they are in.\n- When you deal damage to them, they must mark a Stress.\n- When you fail an attack against them, you can end your Ranger's Focus feature to reroll your Duality Dice.");
    // expect(rangerClass.classFeatures[0].hopeCost, 0); // Se presente
    // expect(rangerClass.classFeatures[0].stressCost, 0); // Se presente

    // Verifica Domains (richiede che _DOMAINS mockato contenga "bone" e "sage")
    expect(rangerClass.domains, hasLength(2));
    expect(rangerClass.domains.any((d) => d.key == "bone" && d.name == "Bone"), isTrue, reason: "Bone domain not found or incorrect");
    expect(rangerClass.domains.any((d) => d.key == "sage" && d.name == "Sage"), isTrue, reason: "Sage domain not found or incorrect");

    // Verifica Subclasses (richiede che _SUBCLASSES mockato contenga "beastbound" e "wayfinder")
    expect(rangerClass.subclasses, hasLength(2));
    expect(rangerClass.subclasses.any((s) => s.key == "beastbound" && s.name == "Beastbound"), isTrue,
        reason: "Beastbound subclass not found or incorrect");
    expect(rangerClass.subclasses.any((s) => s.key == "wayfinder" && s.name == "Wayfinder"), isTrue,
        reason: "Wayfinder subclass not found or incorrect");

    // Verifica Background Questions e Connections
    expect(
        rangerClass.backgroundQuestions,
        equals([
          "A terrible creature hurt your community, and you've vowed to hunt them down. What are they, and what unique trail or sign do they leave behind?",
          "Your first kill almost killed you, too. What was it, and what part of you was never the same after that event?",
          "You've traveled many dangerous lands, but what is the one place you refuse to go?"
        ]));
    expect(
        rangerClass.connections,
        equals([
          "What friendly competition do we have?",
          "Why do you act differently when we're alone than when others are around?",
          "What threat have you asked me to watch for, and why are you worried about it?"
        ]));
  });

  test("getClass('rogue') should correctly parse Rogue class data", () async {
    final DaggerheartClass? rogueClass = await srdParser.getClass("rogue");

    expect(rogueClass, isNotNull);
    expect(rogueClass, isA<DaggerheartClass>());

    expect(rogueClass!.key, "rogue");
    expect(rogueClass.name, "Rogue");
    expect(
        rogueClass.description,
        "Rogues are scoundrels, often in both attitude and practice. Broadly known as liars and thieves, the best among this class move through the world anonymously. Utilizing their sharp wits and blades, rogues trick their foes through social manipulation as easily as breaking locks, climbing through windows, or dealing underhanded blows. These masters of magical craft manipulate shadow and movement, adding an array of useful and deadly tools to their repertoire. Rogues frequently establish guilds to meet future accomplices, hire out jobs, and hone secret skills, proving that there's honor among thieves for those who know where to look.");
    expect(rogueClass.startingEvasion, 12);
    expect(rogueClass.startingHitPoints, 6);
    expect(rogueClass.classItems, "A set of forgery tools or a grappling hook");

    expect(rogueClass.hopeFeature.name, "Rogue's Dodge");
    expect(
        rogueClass.hopeFeature.description,
        "Spend 3 Hope to gain a +2 bonus to your Evasion until the next time an attack succeeds against you. Otherwise, this bonus lasts until your next rest.");
    expect(rogueClass.hopeFeature.hopeCost, 3);
    // expect(rogueClass.hopeFeature.stressCost, 0 or null);

    expect(rogueClass.classFeatures, hasLength(2));
    expect(rogueClass.classFeatures[0].name, "Cloaked");
    expect(
        rogueClass.classFeatures[0].description,
        "Any time you would be Hidden, you are instead Cloaked. In addition to the benefits of the Hidden condition, while Cloaked you remain unseen if you are stationary when an adversary moves to where they would normally see you. After you make an attack or end a move within line of sight of an adversary, you are no longer Cloaked.");
    expect(rogueClass.classFeatures[1].name, "Sneak Attack");
    expect(
        rogueClass.classFeatures[1].description,
        "When you succeed on an attack while Cloaked or while an ally is within Melee range of your target, add a number of d6s equal to your tier to your damage roll.\n\n- Level 1 → Tier 1\n- Levels 2–4 → Tier 2\n- Levels 5–7 → Tier 3\n- Levels 8–10 → Tier 4");

    expect(rogueClass.domains, hasLength(2));
    expect(rogueClass.domains.any((d) => d.key == "midnight" && d.name == "Midnight"), isTrue); // Aggiorna "Midnight Domain" con il nome mock
    expect(rogueClass.domains.any((d) => d.key == "grace" && d.name == "Grace"), isTrue); // Aggiorna "Grace Domain"

    expect(rogueClass.subclasses, hasLength(2));
    expect(rogueClass.subclasses.any((s) => s.key == "nightwalker" && s.name == "Nightwalker"), isTrue); // Aggiorna "Nightwalker"
    expect(rogueClass.subclasses.any((s) => s.key == "syndicate" && s.name == "Syndicate"), isTrue); // Aggiorna "Syndicate"

    expect(
        rogueClass.backgroundQuestions,
        equals([
          "What did you get caught doing that got you exiled from your home community?",
          "You used to have a different life, but you've tried to leave it behind. Who from your past is still chasing you?",
          "Who from your past were you most sad to say goodbye to?"
        ]));
    expect(
        rogueClass.connections,
        equals([
          "What did I recently convince you to do that got us both in trouble?",
          "What have I discovered about your past that I hold secret from the others?",
          "Who do you know from my past, and how have they influenced your feelings about me?"
        ]));
  });

  test("getClass('seraph') should correctly parse Seraph class data", () async {
    final DaggerheartClass? seraphClass = await srdParser.getClass("seraph");

    expect(seraphClass, isNotNull);
    expect(seraphClass, isA<DaggerheartClass>());

    expect(seraphClass!.key, "seraph");
    expect(seraphClass.name, "Seraph");
    expect(
        seraphClass.description,
        "Seraphs are divine fighters and healers imbued with sacred purpose. A wide array of deities exist within the realms, and thus numerous kinds of seraphs are appointed by these gods. Their ethos traditionally aligns with the domain or goals of their god, such as defending the weak, exacting vengeance, protecting a land or artifact, or upholding a particular faith. Some seraphs ally themselves with an army or locale, much to the satisfaction of their rulers, but other crusaders fight in opposition to the follies of the Mortal Realm. It is better to be a seraph's ally than their enemy, as they are terrifying foes to those who defy their purpose.");
    expect(seraphClass.startingEvasion, 9);
    expect(seraphClass.startingHitPoints, 7);
    expect(seraphClass.classItems, "A bundle of offerings or a sigil of your god");

    expect(seraphClass.hopeFeature.name, "Life Support");
    expect(
        seraphClass.hopeFeature.description,
        "Spend 3 Hope to clear a Hit Point on an ally within Close range.");
    expect(seraphClass.hopeFeature.hopeCost, 3);

    expect(seraphClass.classFeatures, hasLength(1));
    expect(seraphClass.classFeatures[0].name, "Prayer Dice");
    expect(
        seraphClass.classFeatures[0].description,
        "At the beginning of each session, roll a number of d4s equal to your subclass's Spellcast trait and place them on your character sheet in the space provided. These are your Prayer Dice. You can spend any number of Prayer Dice to aid yourself or an ally within Far range. You can use a spent die's value to reduce incoming damage, add to a roll's result after the roll is made, or gain Hope equal to the result. At the end of each session, clear all unspent Prayer Dice.");

    expect(seraphClass.domains, hasLength(2));
    expect(seraphClass.domains.any((d) => d.key == "splendor" && d.name == "Splendor"), isTrue); // Aggiorna nome mock
    expect(seraphClass.domains.any((d) => d.key == "valor" && d.name == "Valor"), isTrue); // Aggiorna nome mock

    expect(seraphClass.subclasses, hasLength(2));
    expect(seraphClass.subclasses.any((s) => s.key == "divine wielder" && s.name == "Divine Wielder"), isTrue); // Aggiorna nome mock
    expect(seraphClass.subclasses.any((s) => s.key == "winged sentinel" && s.name == "Winged Sentinel"), isTrue); // Aggiorna nome mock

    expect(
        seraphClass.backgroundQuestions,
        equals([
          "Which god did you devote yourself to? What incredible feat did they perform for you in a moment of desperation?",
          "How did your appearance change after taking your oath?",
          "In what strange or unique way do you communicate with your god?"
        ]));
    expect(
        seraphClass.connections,
        equals([
          "What promise did you make me agree to, should you die on the battlefield?",
          "Why do you ask me so many questions about my god?",
          "You've told me to protect one member of our party above all others, even yourself. Who are they and why?"
        ]));
  });

  test("getClass('sorcerer') should correctly parse Sorcerer class data", () async {
    final DaggerheartClass? sorcererClass = await srdParser.getClass("sorcerer");

    expect(sorcererClass, isNotNull);
    expect(sorcererClass, isA<DaggerheartClass>());

    expect(sorcererClass!.key, "sorcerer");
    expect(sorcererClass.name, "Sorcerer");
    expect(
        sorcererClass.description,
        "Not all innate magic users choose to hone their craft, but those who do can become powerful sorcerers. The gifts of these wielders are passed down through families, even if the family is unaware of or reluctant to practice them. A sorcerer's abilities can range from the elemental to the illusionary and beyond, and many practitioners band together into collectives based on their talents. The act of becoming a formidable sorcerer is not the practice of acquiring power, but learning to cultivate and control the power one already possesses. The magic of a misguided or undisciplined sorcerer is a dangerous force indeed.");
    expect(sorcererClass.startingEvasion, 10);
    expect(sorcererClass.startingHitPoints, 6);
    expect(sorcererClass.classItems, "A whispering orb or a family heirloom");

    expect(sorcererClass.hopeFeature.name, "Volatile Magic");
    expect(
        sorcererClass.hopeFeature.description,
        "Spend 3 Hope to reroll any number of your damage dice on an attack that deals magic damage.");
    expect(sorcererClass.hopeFeature.hopeCost, 3);

    expect(sorcererClass.classFeatures, hasLength(3));
    expect(sorcererClass.classFeatures[0].name, "Arcane Sense");
    expect(
        sorcererClass.classFeatures[0].description,
        "You can sense the presence of magical people and objects within Close range.");
    expect(sorcererClass.classFeatures[1].name, "Minor Illusion");
    expect(
        sorcererClass.classFeatures[1].description,
        "Make a Spellcast Roll (10). On a success, you create a minor visual illusion no larger than yourself within Close range. This illusion is convincing to anyone at Close range or farther.");
    expect(sorcererClass.classFeatures[2].name, "Channel Raw Power");
    expect(
        sorcererClass.classFeatures[2].description,
        "Once per long rest, you can place a domain card from your loadout into your vault and choose to either:\n\n- Gain Hope equal to the level of the card.\n- Enhance a spell that deals damage, gaining a bonus to your damage roll equal to twice the level of the card.");

    expect(sorcererClass.domains, hasLength(2));
    expect(sorcererClass.domains.any((d) => d.key == "arcana" && d.name == "Arcana"), isTrue); // Aggiorna nome mock
    expect(sorcererClass.domains.any((d) => d.key == "midnight" && d.name == "Midnight"), isTrue); // Aggiorna nome mock

    expect(sorcererClass.subclasses, hasLength(2));
    expect(sorcererClass.subclasses.any((s) => s.key == "elemental origin" && s.name == "Elemental Origin"), isTrue); // Aggiorna nome mock
    expect(sorcererClass.subclasses.any((s) => s.key == "primal origin" && s.name == "Primal Origin"), isTrue); // Aggiorna nome mock

    expect(
        sorcererClass.backgroundQuestions,
        equals([
          "What did you do that made the people in your community wary of you?",
          "What mentor taught you to control your untamed magic, and why are they no longer able to guide you?",
          "You have a deep fear you hide from everyone. What is it, and why does it scare you?"
        ]));
    expect(
        sorcererClass.connections,
        equals([
          "Why do you trust me so deeply?",
          "What did I do that makes you cautious around me?",
          "Why do we keep our shared past a secret?"
        ]));
  });

  test("getClass('warrior') should correctly parse Warrior class data", () async {
    final DaggerheartClass? warriorClass = await srdParser.getClass("warrior");

    expect(warriorClass, isNotNull);
    expect(warriorClass, isA<DaggerheartClass>());

    expect(warriorClass!.key, "warrior");
    expect(warriorClass.name, "Warrior");
    expect(
        warriorClass.description,
        "Becoming a warrior requires years, often a lifetime, of training and dedication to the mastery of weapons and violence. While many who seek to fight hone only their strength, warriors understand the importance of an agile body and mind, making them some of the most sought-after fighters across the realms. Frequently, warriors find employment within an army, a band of mercenaries, or even a royal guard, but their potential is wasted in any position where they cannot continue to improve and expand their skills. Warriors are known to have a favored weapon; to come between them and their blade would be a grievous mistake.");
    expect(warriorClass.startingEvasion, 11);
    expect(warriorClass.startingHitPoints, 6);
    expect(warriorClass.classItems, "The drawing of a lover or a sharpening stone");

    expect(warriorClass.hopeFeature.name, "No Mercy");
    expect(
        warriorClass.hopeFeature.description,
        "Spend 3 Hope to gain a +1 bonus to your attack rolls until your next rest.");
    expect(warriorClass.hopeFeature.hopeCost, 3);

    expect(warriorClass.classFeatures, hasLength(2));
    expect(warriorClass.classFeatures[0].name, "Attack of Opportunity");
    expect(
        warriorClass.classFeatures[0].description,
        "If an adversary within Melee range attempts to leave that range, make a reaction roll using a trait of your choice against their Difficulty. Choose one effect on a success, or two if you critically succeed:\n\n- They can't move from where they are.\n- You deal damage to them equal to your primary weapon's damage.\n- You move with them.");
    expect(warriorClass.classFeatures[1].name, "Combat Training");
    expect(
        warriorClass.classFeatures[1].description,
        "You ignore burden when equipping weapons. When you deal physical damage, you gain a bonus to your damage roll equal to your level.");

    expect(warriorClass.domains, hasLength(2));
    expect(warriorClass.domains.any((d) => d.key == "blade" && d.name == "Blade"), isTrue); // Aggiorna nome mock
    expect(warriorClass.domains.any((d) => d.key == "bone" && d.name == "Bone"), isTrue); // Aggiorna nome mock

    expect(warriorClass.subclasses, hasLength(2));
    expect(warriorClass.subclasses.any((s) => s.key == "call of the brave" && s.name == "Call of the Brave"), isTrue); // Aggiorna nome mock
    expect(warriorClass.subclasses.any((s) => s.key == "call of the slayer" && s.name == "Call of the Slayer"), isTrue); // Aggiorna nome mock

    expect(
        warriorClass.backgroundQuestions,
        equals([
          "Who taught you to fight, and why did they stay behind when you left home?",
          "Somebody defeated you in battle years ago and left you to die. Who was it, and how did they betray you?",
          "What legendary place have you always wanted to visit, and why is it so special?"
        ]));
    expect(
        warriorClass.connections,
        equals([
          "We knew each other long before this party came together. How?",
          "What mundane task do you usually help me with off the battlefield?",
          "What fear am I helping you overcome?"
        ]));
  });

  test("getClass('wizard') should correctly parse Wizard class data", () async {
    final DaggerheartClass? wizardClass = await srdParser.getClass("wizard");

    expect(wizardClass, isNotNull);
    expect(wizardClass, isA<DaggerheartClass>());

    expect(wizardClass!.key, "wizard");
    expect(wizardClass.name, "Wizard");
    expect(
        wizardClass.description,
        "Whether through an institution or individual study, those known as wizards acquire and hone immense magical power over years of learning using a variety of tools, including books, stones, potions, and herbs. Some wizards dedicate their lives to mastering a particular school of magic, while others learn from a wide variety of disciplines. Many wizards become wise and powerful figures in their communities, advising rulers, providing medicines and healing, and even leading war councils. While these mages all work toward the common goal of collecting magical knowledge, wizards often have the most conflict within their own ranks, as the acquisition, keeping, and sharing of powerful secrets is a topic of intense debate that has resulted in innumerable deaths.");
    expect(wizardClass.startingEvasion, 11);
    expect(wizardClass.startingHitPoints, 5);
    expect(wizardClass.classItems, "A book you're trying to translate or a tiny, harmless elemental pet");

    expect(wizardClass.hopeFeature.name, "Not This Time");
    expect(
        wizardClass.hopeFeature.description,
        "Spend 3 Hope to force an adversary within Far range to reroll an attack or damage roll.");
    expect(wizardClass.hopeFeature.hopeCost, 3);

    expect(wizardClass.classFeatures, hasLength(2)); // Corretto da 3 a 2 per il JSON fornito
    expect(wizardClass.classFeatures[0].name, "Prestidigitation");
    expect(
        wizardClass.classFeatures[0].description,
        "You can perform harmless, subtle magical effects at will. For example, you can change an object's color, create a smell, light a candle, cause a tiny object to float, illuminate a room, or repair a small object.");
    expect(wizardClass.classFeatures[1].name, "Strange Patterns");
    expect(
        wizardClass.classFeatures[1].description,
        "Choose a number between 1 and 12. When you roll that number on a Duality Die, gain a Hope or clear a Stress.\n\nYou can change this number when you take a long rest.");

    expect(wizardClass.domains, hasLength(2));
    expect(wizardClass.domains.any((d) => d.key == "codex" && d.name == "Codex"), isTrue); // Aggiorna nome mock
    expect(wizardClass.domains.any((d) => d.key == "splendor" && d.name == "Splendor"), isTrue); // Aggiorna nome mock

    expect(wizardClass.subclasses, hasLength(2));
    expect(wizardClass.subclasses.any((s) => s.key == "school of knowledge" && s.name == "School of Knowledge"), isTrue); // Aggiorna nome mock
    expect(wizardClass.subclasses.any((s) => s.key == "school of war" && s.name == "School of War"), isTrue); // Aggiorna nome mock

    expect(
        wizardClass.backgroundQuestions,
        equals([
          "What responsibilities did your community once count on you for? How did you let them down?",
          "You've spent your life searching for a book or object of great significance. What is it, and why is it so important to you?",
          "You have a powerful rival. Who are they, and why are you so determined to defeat them?"
        ]));
    expect(
        wizardClass.connections,
        equals([
          "What favor have I asked of you that you're not sure you can fulfill?",
          "What weird hobby or strange fascination do we both share?",
          "What secret about yourself have you entrusted only to me?"
        ]));
  });
}
