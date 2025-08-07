import 'package:daggerheart_game_master_companion/services/srd_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test("Class parsing returns all classes", () async {
    final srdParser = SrdParserImpl();
    final classes = ["bard", "druid", "guardian", "ranger", "rogue", "seraph", "sorcerer", "warrior", "wizard"];
    for (final className in classes) {
      final daggerheartClass = await srdParser.getClass(className);
      expect(daggerheartClass, isNotNull);
    }
  });
}
