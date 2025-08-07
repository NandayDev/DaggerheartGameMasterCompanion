import 'package:daggerheart_game_master_companion/l10n/app_localizations.dart';
import 'package:daggerheart_game_master_companion/ui/base/daggerheart_state.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/campaign_selection_ui_model.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/campaign_selection_ui_state.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/campaign_selection_view_model.dart';
import 'package:flutter/material.dart';

class CampaignSelectionPage extends StatefulWidget {
  const CampaignSelectionPage({super.key});

  @override
  State<CampaignSelectionPage> createState() => _CampaignSelectionPageState();
}

class _CampaignSelectionPageState extends DaggerheartState<CampaignSelectionPage, CampaignSelectionViewModel> {
  _CampaignSelectionPageState() : super();

  String? selectedKey;

  @override
  void initState() {
    selectedKey = viewModel.selectedCampaign?.key;
    viewModel.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (state is EmptyCampaignSelectionUiState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localizations.campaignSelectionAddCampaignHint, style: theme.textTheme.bodyLarge,),
            SizedBox(height: 15.0),
            MaterialButton(
              color: theme.primaryColorLight,
              // textColor: Theme.of(context).primaryColorLight,
              onPressed: () {
                // TODO
              },
              child: Text(localizations.campaignSelectionAddCampaign),
            ),
          ],
        ),
      );
    }
    final uiState = state as LoadedCampaignSelectionUiState;
    return ListView.builder(
      itemCount: uiState.uiModels.length,
      itemBuilder: (context, index) {
        final campaign = uiState.uiModels[index];

        if (campaign.isError) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Text(localizations.campaignSelectionError, style: TextStyle(color: Colors.red)),
          );
        }

        final isSelected = campaign.key == selectedKey;

        return GestureDetector(
          onTap: () => _onCampaignTap(campaign),
          child: Card(
            color: isSelected ? Colors.blue.shade100 : null,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(campaign.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Inizio: ${campaign.startDate}"),
                  Text("Personaggi: ${campaign.characters}"),
                  if (isSelected)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        "✓ Selezionata",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onCampaignTap(CampaignSelectionUiModel campaign) {
    if (!campaign.isError) {
      viewModel.selectedCampaign = campaign.campaign;
      setState(() {
        selectedKey = campaign.key;
      });
    }
  }
}
