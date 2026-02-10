import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialConnectionRow extends StatelessWidget {
  const SocialConnectionRow({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: 'WhatsApp',
          icon: const Icon(Icons.chat),
          color: Colors.green,
          iconSize: 28,
          onPressed: () {
            _openUrl('https://wa.me/201093230899'); // phone number
          },
        ),
        const SizedBox(width: 12),
        IconButton(
          tooltip: 'Facebook',
          icon: const Icon(Icons.facebook),
          color: colorScheme.primary,
          iconSize: 28,
          onPressed: () {
            _openUrl('https://www.facebook.com/your.profile'); // لينكك
          },
        ),
      ],
    );
  }
}
