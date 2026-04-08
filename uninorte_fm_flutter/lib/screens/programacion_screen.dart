import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/app_theme.dart';

const _programacionUrl =
    'https://www.uninorte.edu.co/web/uninorte-fm-estereo/programacion';

class ProgramacionScreen extends StatefulWidget {
  const ProgramacionScreen({super.key});

  @override
  State<ProgramacionScreen> createState() => _ProgramacionScreenState();
}

class _ProgramacionScreenState extends State<ProgramacionScreen> {
  late final WebViewController _ctrl;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.background)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() {
          _loading = true;
          _error = false;
        }),
        onPageFinished: (_) => setState(() => _loading = false),
        onWebResourceError: (_) => setState(() {
          _loading = false;
          _error = true;
        }),
      ))
      ..loadRequest(Uri.parse(_programacionUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Programación',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.open_in_browser_rounded,
                    color: Colors.white54, size: 20),
                onPressed: () => launchUrl(
                  Uri.parse(_programacionUrl),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
          ),
        ),
        // WebView or error
        Expanded(
          child: Stack(
            children: [
              if (!_error)
                WebViewWidget(controller: _ctrl)
              else
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off_rounded,
                          color: Colors.white24, size: 48),
                      const SizedBox(height: 16),
                      const Text(
                        'No se pudo cargar la página',
                        style: TextStyle(color: Colors.white54, fontSize: 15),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        onPressed: () => launchUrl(
                          Uri.parse(_programacionUrl),
                          mode: LaunchMode.externalApplication,
                        ),
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: const Text('Abrir en navegador'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white70,
                          side: const BorderSide(color: Colors.white24),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_loading)
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
