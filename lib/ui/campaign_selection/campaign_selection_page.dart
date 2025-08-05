import 'package:daggerheart_game_master_companion/ui/base/daggerheart_state.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/campaign_selection_view_model.dart';
import 'package:flutter/material.dart';

class CampaignSelectionPage extends StatefulWidget {
  const CampaignSelectionPage({super.key});

  @override
  State<CampaignSelectionPage> createState() => _CampaignSelectionPageState();
}

class _CampaignSelectionPageState extends DaggerheartState<CampaignSelectionPage, CampaignSelectionViewModel> {
  _CampaignSelectionPageState() : super();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
