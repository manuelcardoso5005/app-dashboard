import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool? isDarkMode; // opcional, força dark/light

  const LogoWidget({
    super.key,
    this.width = 40,
    this.height = 40,
    this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        isDarkMode ?? Theme.of(context).brightness == Brightness.dark;

    return Image.asset(
      isDark ? 'assets/images/logo_dark.png' : 'assets/images/logo_light.png',
      width: width,
      height: height,
    );
  }
}
