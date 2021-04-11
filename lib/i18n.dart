import 'package:flutter/material.dart';

abstract class Translation {
  // The first word of the translation strings indicates which page they're on.

  String get title => 'MiniList';
  String get mainEmptyStateTitle;
  String mainNItems(int n);
  String mainNItemsLeft(int n);
  String get mainInTheCart;
  String get mainNotAvailable;
  String get mainAddItem;
  String get mainSwipeGotIt;
  String get mainSwipeNotAvailable;
  String get mainHowAboutSomeOfThese;
  String get mainMenuSettings => settingsTitle;
  String mainSnackbarPutItemInCart(String item);
  String mainSnackbarMarkedItemAsNotAvailable(String item);
  String get inputHint;
  String get inputDelete;
  String get inputSave;
  String get inputEditExisting;
  String get inputAdd;
  String get inputSmartComposeSwipe;
  String get inTheCartTitle;
  String get inTheCartClearAll;
  String get notAvailableTitle;
  String get notAvailableClearAll;
  String get settingsTitle;
  String get settingsTheme;
  String get settingsThemeDialogTitle;
  String get settingsThemeLight;
  String get settingsThemeDark;
  String get settingsThemeBlack;
  String get settingsThemeSystemLightDark;
  String get settingsThemeSystemLightBlack;
  String get settingsShowSuggestions;
  String get settingsShowSuggestionsDetails;
  String get settingsSmartCompose;
  String get settingsSmartComposeDetails;
  String get settingsSmartInsertion;
  String get settingsSmartInsertionDetails;
  String get settingsDefaultInsertion;
  String get settingsDefaultInsertionTop;
  String get settingsDefaultInsertionBottom;
  String get settingsSuggestions => suggestionsTitle;
  String settingsSuggestionsNItems(int n);
  // TODO: Translate rest of the settings.
  String get settingsPrivacyPolicy;
  String get settingsPrivacyPolicyDetails;
  String get settingsPrivacyPolicyUrl =>
      'https://docs.google.com/document/d/1oIG3r8gZex-23seHeXSGrk0cC4eptV8vf96-_UqSM4Y';
  String get settingsOpenSourceLicenses;
  String get suggestionsTitle;
  String get suggestionsExplanation;
}

String _singularOrPlural(int n, String singular, String plural) {
  return n == 1 ? '$n $singular' : '$n $plural';
}

class _EnglishTranslation extends Translation {
  String _nItems(int n) => _singularOrPlural(n, 'item', 'items');
  String mainNItems(int n) => '${_nItems(n)}';
  String mainNItemsLeft(int n) => '${_nItems(n)} left';
  String get mainEmptyStateTitle => 'A fresh start';
  String get mainInTheCart => 'in the cart';
  String get mainNotAvailable => 'not available';
  String get mainAddItem => 'Add item';
  String get mainSwipeGotIt => 'Got it';
  String get mainSwipeNotAvailable => 'Not available';
  String get mainHowAboutSomeOfThese => 'How about some of these?';
  String mainSnackbarPutItemInCart(String item) =>
      'Marked $item as not available.';
  String mainSnackbarMarkedItemAsNotAvailable(String item) =>
      'Marked $item as not available.';
  String get inputHint => 'New item';
  String get inputDelete => 'Delete';
  String get inputSave => 'Save';
  String get inputEditExisting => 'Edit existing';
  String get inputAdd => 'Add';
  String get inputSmartComposeSwipe => 'swipe';
  String get inTheCartTitle => 'In the cart';
  String get inTheCartClearAll => 'Clear all';
  String get notAvailableTitle => 'Not available';
  String get notAvailableClearAll => 'Clear all';
  String get settingsTitle => 'Settings';
  String get settingsTheme => 'Theme';
  String get settingsThemeDialogTitle => 'Choose theme';
  String get settingsThemeLight => 'Light';
  String get settingsThemeDark => 'Dark';
  String get settingsThemeBlack => 'Black';
  String get settingsThemeSystemLightDark => 'System (light/dark)';
  String get settingsThemeSystemLightBlack => 'System (light/black)';
  String get settingsShowSuggestions => 'Show suggestions';
  String get settingsShowSuggestionsDetails => 'At the bottom of the list';
  String get settingsSmartCompose => 'Smart Compose';
  String get settingsSmartComposeDetails => 'Autocomplete while typing';
  String get settingsSmartInsertion => 'Smart Insertion';
  String get settingsSmartInsertionDetails =>
      'Insert items based on how they were completed in the past';
  String get settingsDefaultInsertion => 'Default insertion';
  String get settingsDefaultInsertionTop => 'Top';
  String get settingsDefaultInsertionBottom => 'Bottom';
  String settingsSuggestionsNItems(int n) => '${_nItems(n)}';
  String get settingsPrivacyPolicy => 'Privacy Policy';
  String get settingsPrivacyPolicyDetails => 'An easy-to-read Google Doc';
  String get settingsOpenSourceLicenses => 'Open Source Licenses';
  String get suggestionsTitle => 'Suggestions';
  String get suggestionsExplanation =>
      'Items you add to the list are recorded here. Each item has a score. Items with higher scores are more likely to be suggested. If you use an item, its score increases by 1. Over time, the scores automatically decrease exponentially.';
}

class _GermanTranslation extends Translation {
  String _nItems(int n) => _singularOrPlural(n, 'Eintrag', 'Einträge');
  String mainNItems(int n) => '${_nItems(n)}';
  String mainNItemsLeft(int n) => '${_nItems(n)} übrig';
  String get mainEmptyStateTitle => 'Ein neuer Start';
  String get mainInTheCart => 'im Wagen';
  String get mainNotAvailable => 'nicht da';
  String get mainAddItem => 'Eintrag hinzufügen';
  String get mainSwipeGotIt => 'Ist im Wagen';
  String get mainSwipeNotAvailable => 'Ist nicht da';
  String get mainHowAboutSomeOfThese => "Wie wär's mit diesen?";
  String mainSnackbarPutItemInCart(String item) => '$item ist nicht da.';
  String mainSnackbarMarkedItemAsNotAvailable(String item) =>
      '$item ist im Wagen.';
  String get inputHint => 'Neuer Eintrag';
  String get inputDelete => 'Löschen';
  String get inputSave => 'Speichern';
  String get inputEditExisting => 'Bearbeiten';
  String get inputAdd => 'Hinzufügen';
  String get inputSmartComposeSwipe => 'wischen';
  String get inTheCartTitle => 'Im Wagen';
  String get inTheCartClearAll => 'Alle löschen';
  String get notAvailableTitle => 'Nicht da';
  String get notAvailableClearAll => 'Alle löschen';
  String get settingsTitle => 'Einstellungen';
  String get settingsTheme => 'Theme';
  String get settingsThemeDialogTitle => 'Wähle ein Theme';
  String get settingsThemeLight => 'Hell';
  String get settingsThemeDark => 'Dunkel';
  String get settingsThemeBlack => 'Schwarz';
  String get settingsThemeSystemLightDark => 'System (hell/dunkel)';
  String get settingsThemeSystemLightBlack => 'System (hell/schwarz)';
  String get settingsShowSuggestions => 'Vorschläge anzeigen';
  String get settingsShowSuggestionsDetails => 'Am Ende der Liste';
  String get settingsSmartCompose => 'Smart Compose';
  String get settingsSmartComposeDetails => 'Autovervollständigungen anzeigen';
  String get settingsSmartInsertion => 'Smart Insertion';
  String get settingsSmartInsertionDetails =>
      'Einträge an der richtigen Stelle hinfügen abhängig davon, in welcher '
      'Reihenfolge sie vorher abgehakt wurden';
  String get settingsDefaultInsertion => 'Standard-Einfügeort';
  String get settingsDefaultInsertionTop => 'Oben';
  String get settingsDefaultInsertionBottom => 'Unten';
  String settingsSuggestionsNItems(int n) => '${_nItems(n)}';
  String get settingsPrivacyPolicy => 'Datenschutzerklärung';
  String get settingsPrivacyPolicyDetails =>
      'Ein leicht verständliches englisches Google Doc';
  String get settingsOpenSourceLicenses => 'Open-Source-Lizenzen';
  String get suggestionsTitle => 'Vorschläge';
  String get suggestionsExplanation =>
      'Wenn du Einträge hinzufügst, werden sie hier notiert. Jeder Eintrag hat '
      'einen Score, der angibt, wie wahrscheinlich es ist, dass er '
      'vorgeschlagen wird. Wenn du einen Eintrag hinzufügst, steigt der Score '
      'um 1. Mit der Zeit reduzieren sich die Scores exponentiell – heißt, '
      'weiter zurückliegende Aktionen haben weniger Einfluss auf die '
      'Reihenfolge der Vorschläge';
}

extension TranslationFromContext on BuildContext {
  Translation get t {
    switch (Localizations.localeOf(this).languageCode) {
      case 'de':
        return _GermanTranslation();
      case 'en':
        return _EnglishTranslation();
      default:
        return _EnglishTranslation();
    }
  }
}
