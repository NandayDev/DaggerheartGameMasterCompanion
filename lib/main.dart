import 'dart:convert';

import 'package:daggerheart_game_master_companion/di/dependency_injector.dart';
import 'package:daggerheart_game_master_companion/ui/campaign_selection/campaign_selection_view_model.dart';
import 'package:daggerheart_game_master_companion/ui/home_page.dart';
import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

void main() {
  _registerDependencyInjections();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent), useMaterial3: true),
      home: HomePage(),
    );
  }
}

void _registerDependencyInjections() {
  DependencyInjector.instance
      .registerSingleton<JsonEncoder>(() => const JsonEncoder.withIndent('  '))
      .registerFactory<CampaignSelectionViewModel>(() => CampaignSelectionViewModel(DependencyInjector.resolve()));
}
