import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/main_scaffold.dart';
import 'services/analytics_service.dart';

class UninorteFMApp extends StatelessWidget {
  const UninorteFMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uninorte 103.1 FM Estéreo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      navigatorObservers: [AnalyticsService.observer],
      home: const MainScaffold(),
    );
  }
}
