import 'package:flutter/material.dart';

class AppTheme extends StatelessWidget {
  AppTheme({required this.data, required this.child});

  final AppThemeData data;
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

extension GetAppTheme on BuildContext {
  AppThemeData get appTheme => findAncestorWidgetOfExactType<AppTheme>()!.data;
}

class AppThemeData {
  AppThemeData({
    required this.backgroundColor,
    required this.primaryColor,
    required this.textStyle,
    required this.outerPadding,
    required this.innerPadding,
    required this.fabTextStyle,
    required this.inTheCartColor,
    required this.onInTheCartColor,
    required this.notAvailableColor,
    required this.onNotAvailableColor,
    required this.suggestionTextStyle,
    required this.suggestionBorder,
    required this.snackBarColor,
    required this.snackBarTextColor,
    required this.sheetColor,
    required this.sheetButtonStyle,
    required this.hintStyle,
  });

  AppThemeData.light()
      : this(
          backgroundColor: Colors.white,
          primaryColor: Colors.teal,
          textStyle: TextStyle(color: Colors.black, fontSize: 20),
          outerPadding: 24,
          innerPadding: 16,
          fabTextStyle: TextStyle(color: Colors.white),
          inTheCartColor: Colors.teal,
          onInTheCartColor: Colors.white,
          notAvailableColor: Colors.grey,
          onNotAvailableColor: Colors.white,
          suggestionTextStyle: TextStyle(color: Colors.white),
          suggestionBorder: BorderSide(color: Colors.black12),
          snackBarColor: Colors.grey.shade900,
          snackBarTextColor: Colors.white,
          sheetColor: Colors.white,
          sheetButtonStyle: TextStyle(color: Colors.teal),
          hintStyle: TextStyle(color: Colors.black45),
        );

  AppThemeData.black()
      : this(
          backgroundColor: Colors.black,
          primaryColor: Colors.teal,
          textStyle: TextStyle(color: Colors.white, fontSize: 20),
          outerPadding: 24,
          innerPadding: 16,
          fabTextStyle: TextStyle(color: Colors.white),
          inTheCartColor: Colors.teal,
          onInTheCartColor: Colors.white,
          notAvailableColor: Colors.grey.shade300,
          onNotAvailableColor: Colors.white,
          suggestionTextStyle: TextStyle(color: Colors.white70, fontSize: 16),
          suggestionBorder: BorderSide(color: Colors.white12),
          snackBarColor: Colors.white,
          snackBarTextColor: Colors.black,
          sheetColor: Colors.grey.shade900,
          sheetButtonStyle: TextStyle(color: Colors.teal),
          hintStyle: TextStyle(color: Colors.white54),
        );

  final Color backgroundColor;
  final Color primaryColor;
  final TextStyle textStyle;

  final double outerPadding;
  final double innerPadding;

  final TextStyle fabTextStyle;

  final Color inTheCartColor;
  final Color onInTheCartColor;
  final Color notAvailableColor;
  final Color onNotAvailableColor;

  final TextStyle suggestionTextStyle;
  final BorderSide suggestionBorder;

  final Color snackBarColor;
  final Color snackBarTextColor;

  final Color sheetColor;
  final TextStyle sheetButtonStyle;
  final TextStyle hintStyle;

  ThemeData toMaterialThemeData() {
    final invalidColor = Colors.pink;
    final invalidTextStyle = TextStyle(color: invalidColor);
    final invalidBrightness = Brightness.light;

    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      accentColor: primaryColor,
      cardColor: backgroundColor,
      canvasColor: backgroundColor,
      colorScheme: ColorScheme(
        primary: primaryColor,
        primaryVariant: primaryColor,
        onPrimary: textStyle.color!,
        secondary: primaryColor,
        secondaryVariant: primaryColor,
        onSecondary: textStyle.color!,
        error: invalidColor,
        onError: invalidTextStyle.color!,
        background: backgroundColor,
        onBackground: textStyle.color!,
        surface: backgroundColor,
        onSurface: textStyle.color!,
        brightness: Brightness.light,
      ),
      accentColorBrightness: invalidBrightness,
      textTheme: TextTheme(
        bodyText1: textStyle,
        bodyText2: textStyle,
        button: textStyle,
        caption: invalidTextStyle,
        headline1: invalidTextStyle,
        headline2: invalidTextStyle,
        headline3: invalidTextStyle,
        headline4: invalidTextStyle,
        headline5: invalidTextStyle,
        headline6: invalidTextStyle,
        overline: invalidTextStyle,
        subtitle1: textStyle, // used by ListTiles
        subtitle2: invalidTextStyle,
      ),
      iconTheme: IconThemeData(
        color: textStyle.color!,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        splashColor: Colors.white12,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: snackBarColor,
        contentTextStyle: textStyle.copyWith(color: snackBarTextColor),
        actionTextColor: primaryColor,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: backgroundColor,
        labelStyle: suggestionTextStyle,
        padding: EdgeInsets.all(4),
        side: suggestionBorder,
        brightness: invalidBrightness,
        selectedColor: invalidColor,
        secondaryLabelStyle: invalidTextStyle,
        secondarySelectedColor: invalidColor,
        disabledColor: invalidColor,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: sheetColor,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
        padding: EdgeInsets.all(16),
        minWidth: 0,
      ),
    );
  }
}
