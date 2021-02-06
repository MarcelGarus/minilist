import 'package:chest_flutter/chest_flutter.dart';

part 'settings.g.dart';

final settings = Chest<Settings>('settings', ifNew: () => Settings());

@tape({
  v0: {#theme},
})
class Settings {
  Settings({this.theme = ThemeMode.systemLightBlack});

  final ThemeMode theme;
}

@tape({
  v0: {#light, #dark, #black, #systemLightDark, #systemLightBlack},
})
enum ThemeMode {
  light,
  dark,
  black,
  systemLightDark,
  systemLightBlack,
}

extension BeautifulThemeMode on ThemeMode {
  String toBeautifulString() {
    switch (this) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.black:
        return 'Black';
      case ThemeMode.systemLightDark:
        return 'System (light/dark)';
      case ThemeMode.systemLightBlack:
        return 'System (light/black)';
    }
  }
}
