import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter/scheduler.dart';
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
  TextStyle get itemStyle =>
      _style.item.copyWith(color: color.onBackground, fontSize: 20);
  TextStyle get appBarStyle =>
      _style.accent.copyWith(color: color.onBackground, fontSize: 20);
  TextStyle get secondaryStyle =>
      _style.standard.copyWith(color: color.secondary);
  TextStyle get suggestionStyle => secondaryStyle;
}

Brightness get _platformBrightness =>
    SchedulerBinding.instance!.window.platformBrightness;

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
        return _platformBrightness == Brightness.light
            ? AppThemeData.light()
            : AppThemeData.dark();
      case ThemeMode.systemLightBlack:
        return _platformBrightness == Brightness.light
            ? AppThemeData.light()
            : AppThemeData.black();
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
            delete: Colors.red,
            onDelete: Colors.white,
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
            delete: Colors.red,
            onDelete: Colors.white,
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
            canvas: Color(0xff121212),
            contrast: Colors.white,
            onContrast: Colors.black,
            inTheCart: Colors.teal,
            onInTheCart: Colors.white,
            inTheCartTint: Colors.teal.withOpacity(0.2),
            notAvailable: Colors.grey.shade900,
            onNotAvailable: Colors.white,
            notAvailableTint: Colors.grey.shade900,
            delete: Colors.red,
            onDelete: Colors.white,
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
      // standard: TextStyle(),
      // accent: TextStyle(),
      // item: TextStyle(),
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
    required this.delete,
    required this.onDelete,
  });

  final Color background;
  final Color onBackground;
  final MaterialColor primary; // Used by FABs, buttons, and action texts.
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
  final Color delete;
  final Color onDelete;
}

extension ToMaterialTheme on AppThemeData {
  ThemeData toDefaultMaterialTheme() {
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: color.background,
      primaryColor: color.primary,
      primarySwatch: color.primary,
      accentColor: color.primary,
      canvasColor: color.canvas,
      appBarTheme: AppBarTheme(
        brightness: brightness,
        backgroundColor: color.canvas,
        foregroundColor: color.onBackground,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: color.onPrimary,
      ),
    );
  }
}
