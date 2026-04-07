import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/main_scaffold.dart';

class UninorteFMApp extends StatelessWidget {
  const UninorteFMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uninorte 103.1 FM Estéreo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const MainScaffold(),
    );
  }
}
