import 'package:flutter/material.dart' hide ThemeMode;
import 'package:google_fonts/google_fonts.dart';

import 'core/core.dart';

class AppTheme extends StatelessWidget {
  AppTheme({required this.data, required this.child});

  final AppThemeData data;
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

extension GetAppTheme on BuildContext {
  AppThemeData get appTheme => findAncestorWidgetOfExactType<AppTheme>()!.data;
  Brightness get brightness => appTheme.brightness;
  PaddingThemeData get padding => appTheme.padding;
  TextStyleThemeData get _style => appTheme.style;
  ColorThemeData get color => appTheme.color;

  // Computed properties.
  TextStyle get standardStyle =>
      _style.standard.copyWith(color: color.onBackground);
  TextStyle get accentStyle =>
      _style.accent.copyWith(color: color.onBackground);
  TextStyle get itemStyle => _style.item.copyWith(color: color.onBackground);
  TextStyle get appBarStyle =>
      _style.accent.copyWith(color: color.onBackground, fontSize: 20);
  TextStyle get secondaryStyle =>
      _style.standard.copyWith(color: color.secondary);
  TextStyle get suggestionStyle => secondaryStyle;
}

class AppThemeData {
  AppThemeData({
    required this.brightness,
    required this.padding,
    required this.style,
    required this.color,
  });
  factory AppThemeData.fromThemeMode(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.light:
        return AppThemeData.light();
      case ThemeMode.dark:
        return AppThemeData.dark();
      case ThemeMode.black:
        return AppThemeData.black();
      case ThemeMode.systemLightDark:
        return AppThemeData.dark();
      case ThemeMode.systemLightBlack:
        return AppThemeData.black();
    }
  }
  AppThemeData.light()
      : this(
          brightness: Brightness.light,
          padding: PaddingThemeData.standard(),
          style: TextStyleThemeData.standard(),
          color: ColorThemeData(
            background: Colors.white,
            onBackground: Colors.black,
            primary: Colors.teal,
            onPrimary: Colors.white,
            secondary: Colors.black54,
            canvas: Colors.white,
            contrast: Colors.grey.shade900,
            onContrast: Colors.white,
            inTheCart: Colors.teal,
            onInTheCart: Colors.white,
            inTheCartTint: Colors.teal.withOpacity(0.2),
            notAvailable: Colors.grey,
            onNotAvailable: Colors.white,
            notAvailableTint: Colors.grey.withOpacity(0.2),
          ),
        );
  AppThemeData.dark()
      : this(
          brightness: Brightness.dark,
          padding: PaddingThemeData.standard(),
          style: TextStyleThemeData.standard(),
          color: ColorThemeData(
            background: Color(0xff121212),
            onBackground: Colors.white,
            primary: Colors.teal,
            onPrimary: Colors.black,
            secondary: Colors.white54,
            canvas: Colors.grey.shade900,
            contrast: Colors.white,
            onContrast: Colors.black,
            inTheCart: Colors.teal,
            onInTheCart: Colors.white,
            inTheCartTint: Colors.teal.withOpacity(0.2),
            notAvailable: Colors.grey.shade900,
            onNotAvailable: Colors.white,
            notAvailableTint: Colors.grey.shade900,
          ),
        );
  AppThemeData.black()
      : this(
          brightness: Brightness.dark,
          padding: PaddingThemeData.standard(),
          style: TextStyleThemeData.standard(),
          color: ColorThemeData(
            background: Colors.black,
            onBackground: Colors.white,
            primary: Colors.teal,
            onPrimary: Colors.black,
            secondary: Colors.white54,
            canvas: Colors.grey.shade900,
            contrast: Colors.white,
            onContrast: Colors.black,
            inTheCart: Colors.teal,
            onInTheCart: Colors.white,
            inTheCartTint: Colors.teal.withOpacity(0.2),
            notAvailable: Colors.grey.shade900,
            onNotAvailable: Colors.white,
            notAvailableTint: Colors.grey.shade900,
          ),
        );

  final Brightness brightness;
  final PaddingThemeData padding;
  final TextStyleThemeData style;
  final ColorThemeData color;
}

class PaddingThemeData {
  PaddingThemeData({required this.outer, required this.inner});
  PaddingThemeData.standard() : this(outer: 24, inner: 16);

  final double outer; // Padding on the sides of the screen.
  final double inner; // Padding between elements.
}

class TextStyleThemeData {
  TextStyleThemeData({
    required this.standard,
    required this.accent,
    required this.item,
  });
  factory TextStyleThemeData.standard() {
    return TextStyleThemeData(
      standard: GoogleFonts.roboto(fontSize: 16),
      accent: GoogleFonts.didactGothic(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      item: GoogleFonts.roboto(fontSize: 20),
    );
  }

  final TextStyle standard; // Used by default.
  final TextStyle accent; // Used in titles, buttons, etc.
  final TextStyle item; // Used for the items.
}

class ColorThemeData {
  ColorThemeData({
    required this.background,
    required this.onBackground,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.canvas,
    required this.contrast,
    required this.onContrast,
    required this.inTheCart,
    required this.onInTheCart,
    required this.inTheCartTint,
    required this.notAvailable,
    required this.onNotAvailable,
    required this.notAvailableTint,
  });

  final Color background;
  final Color onBackground;
  final Color primary; // Used by FABs, buttons, and action texts.
  final Color secondary; // Used by secondary elements like suggestions.
  final Color onPrimary; // Color readable on the primary color (used on FABs).
  final Color canvas; // Used by sheets, dialogs, popups.
  final Color contrast; // Used by toasts, snack bars, etc.
  final Color onContrast; // Used by text on contrast elements.
  final Color inTheCart;
  final Color onInTheCart;
  final Color inTheCartTint;
  final Color notAvailable;
  final Color onNotAvailable;
  final Color notAvailableTint;
}
