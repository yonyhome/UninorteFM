import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class _SocialLink {
  final String label;
  final String subtitle;
  final String url;
  final IconData icon;
  final Color color;

  const _SocialLink({
    required this.label,
    required this.subtitle,
    required this.url,
    required this.icon,
    required this.color,
  });
}

const _links = [
  _SocialLink(
    label: 'Facebook',
    subtitle: 'Síguenos en Facebook',
    url: 'https://www.facebook.com/uninortefm',
    icon: Icons.facebook_rounded,
    color: Color(0xFF1877F2),
  ),
  _SocialLink(
    label: 'WhatsApp',
    subtitle: 'Escríbenos al +57 300 000 0000',
    url: 'https://wa.me/573000000000',
    icon: Icons.chat_bubble_rounded,
    color: Color(0xFF25D366),
  ),
  _SocialLink(
    label: 'Sitio Web',
    subtitle: 'www.uninorte.edu.co',
    url: 'https://www.uninorte.edu.co/web/uninorte-fm-estereo',
    icon: Icons.language_rounded,
    color: AppColors.primary,
  ),
];

class ExplorarScreen extends StatelessWidget {
  const ExplorarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
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
                'Explorar',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),

        // Hero banner
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFC01818), AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Uninorte\n103.1 FM Estéreo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mueve la Cultura',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Social links
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'ENCUÉNTRANOS EN',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.white.withOpacity(0.35),
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),

        ..._links.map((link) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _SocialCard(link: link),
            )),
      ],
    );
  }
}

class _SocialCard extends StatelessWidget {
  final _SocialLink link;

  const _SocialCard({required this.link});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(link.url),
          mode: LaunchMode.externalApplication),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E1E1E)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: link.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(link.icon, color: link.color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    link.label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    link.subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.25), size: 20),
          ],
        ),
      ),
    );
  }
}
