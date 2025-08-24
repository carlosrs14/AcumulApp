import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButton {
  final IconData icon;
  final String url;

  SocialButton({required this.icon, required this.url});
}

class SocialButtonsColumn extends StatelessWidget {
  final List<SocialButton> buttons;

  const SocialButtonsColumn({Key? key, required this.buttons})
    : super(key: key);

  Future<void> _abrirEnlace(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: buttons
          .map(
            (b) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: InkWell(
                onTap: () => _abrirEnlace(b.url),
                borderRadius: BorderRadius.circular(30),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    b.icon,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 22,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
