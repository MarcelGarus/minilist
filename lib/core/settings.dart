import 'package:chest_flutter/chest_flutter.dart';

part 'settings.g.dart';

final settings = Chest<Settings>('settings', ifNew: () => Settings());

@tape({
  v0: {#theme},
})
class Settings {
  Settings({
    this.theme = ThemeMode.systemLightBlack,
    this.showSuggestions = true,
    this.showSmartCompose = true,
    this.useSmartInsertion = false,
    this.defaultInsertion = Insertion.atTheEnd,
  });

  final ThemeMode theme;
  final bool showSuggestions;
  final bool showSmartCompose;
  final bool useSmartInsertion;
  final Insertion defaultInsertion;
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

@tape({
  v0: {#atTheBeginning, #atTheEnd},
})
enum Insertion { atTheBeginning, atTheEnd }

extension BeautifulInsertion on Insertion {
  String toBeautifulString() {
    switch (this) {
      case Insertion.atTheBeginning:
        return 'Top';
      case Insertion.atTheEnd:
        return 'Bottom';
    }
  }

  Insertion get opposite => this == Insertion.atTheBeginning
      ? Insertion.atTheEnd
      : Insertion.atTheBeginning;
}
