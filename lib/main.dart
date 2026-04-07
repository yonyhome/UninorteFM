import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:audio_service/audio_service.dart';
import 'services/radio_audio_handler.dart';
import 'providers/radio_provider.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar: transparent with light icons
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Init audio_service — runs RadioAudioHandler in background isolate
  final audioHandler = await AudioService.init(
    builder: () => RadioAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.uninorte.fm.audio',
      androidNotificationChannelName: 'Uninorte FM',
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidShowNotificationBadge: true,
      androidStopForegroundOnPause: false,
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => RadioProvider(audioHandler),
      child: const UninorteFMApp(),
    ),
  );
}
