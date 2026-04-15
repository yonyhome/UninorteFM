import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/main_scaffold.dart';
import 'screens/force_update_screen.dart';
import 'services/analytics_service.dart';

class UninorteFMApp extends StatelessWidget {
  final bool forceUpdate;

  const UninorteFMApp({super.key, this.forceUpdate = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uninorte 103.1 FM Estéreo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      navigatorObservers: [AnalyticsService.observer],
      home: forceUpdate ? const ForceUpdateScreen() : const MainScaffold(),
    );
  }
}
