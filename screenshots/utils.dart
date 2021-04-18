import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minilist/theme.dart';

// A typical smartphone size with an aspect ratio of 9:16.
const smartphoneSize = Size(400 * 0.9, 400 * 1.6);

class Studio extends StatelessWidget {
  Studio({
    required this.color,
    required this.foregroundColor,
    required this.appTheme,
    required this.children,
  });

  final Color color;
  final Color foregroundColor;
  final AppThemeData appTheme;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: GoogleFonts.didactGothic(
        color: foregroundColor,
        fontSize: 48,
        fontWeight: FontWeight.w700,
      ),
      child: AppTheme(
        data: appTheme,
        child: Container(
          color: color,
          padding: EdgeInsets.all(32),
          child: Stack(children: children),
        ),
      ),
    );
  }
}
