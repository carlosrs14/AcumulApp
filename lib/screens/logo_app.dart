import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Center(
      child: SvgPicture.asset(
        'assets/images/FullAcumulappLogo.svg',
        width: 300,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
      ),
    );
  }
}
