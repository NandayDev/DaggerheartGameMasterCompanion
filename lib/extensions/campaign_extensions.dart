import 'dart:convert';

import 'package:daggerheart_game_master_companion/models/campaign.dart';

extension CampaignJsonExtensions on Campaign {
  String toJsonString(JsonEncoder jsonEncoder) {
    final json = {_GUID: key, _NAME: name, _CREATED: created.millisecondsSinceEpoch};
    return jsonEncoder.convert(json);
  }

  static Campaign campaignFromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return Campaign(key: json[_GUID], name: json[_NAME], created: DateTime.fromMillisecondsSinceEpoch(json[_CREATED]));
  }

  static const _GUID = "guid";
  static const _NAME = "name";
  static const _CREATED = "created";
}
