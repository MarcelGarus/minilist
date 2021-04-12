import 'package:chest_flutter/chest_flutter.dart';

import '../i18n.dart';

part 'settings.g.dart';

final settings = Chest<Settings>('settings', ifNew: () => Settings());

@tape({
  v0: {#theme},
  v1: {
    #theme,
    #showSuggestions,
    #showSmartCompose,
    #useSmartInsertion,
    #defaultInsertion
  },
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

  String toDebugString() {
    final buffer = StringBuffer('Settings(\n')
      ..write('  theme: ${theme.toDebugString()},\n')
      ..write('  showSuggestions: $showSuggestions,\n')
      ..write('  showSmartCompose: $showSmartCompose,\n')
      ..write('  useSmartInsertion: $useSmartInsertion,\n')
      ..write('  defaultInsertion: ${defaultInsertion.toDebugString()},\n')
      ..write(')');
    return buffer.toString();
  }
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
  String toBeautifulString(Translation t) {
    switch (this) {
      case ThemeMode.light:
        return t.settingsThemeLight;
      case ThemeMode.dark:
        return t.settingsThemeDark;
      case ThemeMode.black:
        return t.settingsThemeBlack;
      case ThemeMode.systemLightDark:
        return t.settingsThemeSystemLightDark;
      case ThemeMode.systemLightBlack:
        return t.settingsThemeSystemLightBlack;
    }
  }

  String toDebugString() => toBeautifulString(Translation.default_);
}

@tape({
  v0: {#atTheBeginning, #atTheEnd},
})
enum Insertion { atTheBeginning, atTheEnd }

extension BeautifulInsertion on Insertion {
  String toBeautifulString(Translation t) {
    switch (this) {
      case Insertion.atTheBeginning:
        return t.settingsDefaultInsertionTop;
      case Insertion.atTheEnd:
        return t.settingsDefaultInsertionBottom;
    }
  }

  String toDebugString() => toBeautifulString(Translation.default_);

  Insertion get opposite => this == Insertion.atTheBeginning
      ? Insertion.atTheEnd
      : Insertion.atTheBeginning;
}
