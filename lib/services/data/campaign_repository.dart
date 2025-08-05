import 'package:daggerheart_game_master_companion/extensions/campaign_extensions.dart';
import 'package:daggerheart_game_master_companion/models/campaign.dart';
import 'package:daggerheart_game_master_companion/services/data/data_source.dart';

abstract class CampaignRepository {
  Future<Iterable<Campaign>> getAllCampaigns();

  Future<void> saveCampaign(Campaign campaign);
}

class CampaignRepositoryImpl implements CampaignRepository {
  final LocalDataSource _dataSource;

  CampaignRepositoryImpl(this._dataSource);

  @override
  Future<Iterable<Campaign>> getAllCampaigns() async {
    final campaignsJson = await _dataSource.getAllCampaigns();
    return campaignsJson.map((campaignString) {
      return CampaignJsonExtensions.campaignFromJsonString(campaignString);
    });
  }

  @override
  Future<void> saveCampaign(Campaign campaign) {
    final json = campaign.toJsonString();
    return _dataSource.saveCampaign(campaign.key, json);
  }
}
