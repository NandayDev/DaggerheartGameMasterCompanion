import 'package:daggerheart_game_master_companion/l10n/app_localizations.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/campaign_selection_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DrawerItem _selectedDrawerItem = DrawerItem.CAMPAIGN_SELECTION;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Text(_selectedDrawerItem.getTitle(context)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: theme.primaryColor),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ...DrawerItem.values.map(
              (item) => ListTile(
                leading: Icon(item.icon),
                title: Text(item.getTitle(context)),
                onTap: () {
                  setState(() {
                    _selectedDrawerItem = item;
                    Navigator.of(context).pop();
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: switch (_selectedDrawerItem) {
        DrawerItem.CAMPAIGN_SELECTION => const CampaignSelectionPage(),
        DrawerItem.COMBAT => throw UnimplementedError(),
      },
    );
  }
}

enum DrawerItem {
  CAMPAIGN_SELECTION(icon: Icons.home),
  COMBAT(icon: Icons.security);

  final IconData icon;

  const DrawerItem({required this.icon});
}

extension DrawerItemExtensions on DrawerItem {
  String getTitle(BuildContext context) {
    switch (this) {
      case DrawerItem.CAMPAIGN_SELECTION:
        return AppLocalizations.of(context)!.campaignSelection;
      case DrawerItem.COMBAT:
        return AppLocalizations.of(context)!.combat;
    }
  }
}
