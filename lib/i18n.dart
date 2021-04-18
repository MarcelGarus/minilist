import 'package:flutter/material.dart';

extension TranslationFromContext on BuildContext {
  Translation get t => Translation.forLocale(Localizations.localeOf(this));
}

abstract class Translation {
  const Translation();
  factory Translation.forLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'de':
        return _GermanTranslation();
      case 'en':
        return _EnglishTranslation();
      default:
        return default_;
    }
  }

  static const default_ = _EnglishTranslation();

  // The first word of the translation strings indicates which page they're on.

  String get generalTitle => 'MiniList';
  String get generalUndo;
  List<String> get defaultItems;
  String get mainEmptyStateTitle;
  String mainNItems(int n);
  String mainNItemsLeft(int n);
  String get mainInTheCart;
  String get mainNotAvailable;
  String get mainAddItem;
  String get mainSwipeHint;
  String get mainSwipeGotIt;
  String get mainSwipeNotAvailable;
  String get mainHowAboutSomeOfThese;
  String get mainMenuSettings => settingsTitle;
  String mainSnackbarPutItemInCart(String item);
  String mainSnackbarMarkedItemAsNotAvailable(String item);
  String mainSuggestionsTitle(int n);
  String get mainSuggestionRemovalTitle;
  String mainSuggestionRemovalDetails(String suggestion);
  String get mainSuggestionRemovalYes;
  String get mainSuggestionRemovalNo;
  String get inputHint;
  String get inputDelete;
  String get inputSave;
  String get inputEditExisting;
  String get inputAdd;
  String get inputSmartComposeSwipe;
  String get completedSwipeDelete;
  String get completedSwipePutBackOnList;
  String completedDeleteConfirmation(String item);
  String completedPutBackOnListConfirmation(String item);
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
  String get settingsDebugInfo => debugInfoTitle;
  String get settingsDebugInfoDetails;
  String get settingsFeedback;
  String get settingsFeedbackDetails;
  String get settingsFeedbackUrl => 'mailto:marcel.garus@gmail.com';
  String get settingsRateTheApp;
  String get settingsRateTheAppDetails;
  String get settingsRateTheAppUrl =>
      'https://play.google.com/store/apps/details?id=dev.marcelgarus.minilist';
  String get settingsPrivacyPolicy;
  String get settingsPrivacyPolicyDetails;
  String get settingsPrivacyPolicyUrl =>
      'https://docs.google.com/document/d/1oIG3r8gZex-23seHeXSGrk0cC4eptV8vf96-_UqSM4Y';
  String get settingsOpenSourceLicenses;
  String get suggestionsTitle;
  String get suggestionsExplanation;
  String get debugInfoTitle;
  String get debugInfoCopyConfirmation;
}

String _singularOrPlural(int n, String singular, String plural) {
  return n == 1 ? '$n $singular' : '$n $plural';
}

class _EnglishTranslation extends Translation {
  const _EnglishTranslation();

  String get generalUndo => 'Undo';
  List<String> get defaultItems => [
        // Some food.
        'Water', 'Potatoes', 'Bananas', 'Milk', 'Bread', 'Tomatoes', 'Cheese',
        'Apple', 'Onions', 'Toast', 'Melon', 'Orange', 'Cucumber', 'Grapes',
        'Peaches', 'Grapefruit', 'Lemon', 'Strawberries', 'Carrots', 'Pizza',
        'Pineapple', 'Pepper', 'Lettuce', 'Honey', 'Cabbage', 'Blueberries',
        'Kiwis', 'Raspberries', 'Butter', 'Mushrooms', 'Cherries', 'Broccoli',
        'Cranberries', 'Garlic', 'Tangerines', 'Spinach', 'Flour', 'Beans',
        'Celery', 'Limes', 'Olives', 'Pumpkin', 'Sweet potatoes', 'Mangos',
        'Avocados', 'Sweet corn', 'Plums', 'Eggplant', 'Salad', 'Wheat',
        'Artichokes', 'Rice', 'Radishes', 'Chicken', 'Papayas', 'Peanuts',
        'Hazelnuts', 'Peas', 'Pears', 'Squash', 'Ice cream', 'Salt',
        'Apricots', 'Corn', 'Walnuts', 'Beef', 'Macadamias', 'Pork', 'Fish',
        'Margarine', 'Turkey', 'Syrup', 'Almonds', 'Pistachios', 'Lamb',
        'Corn Syrup', 'Pecans', 'Maple syrup', 'Fries',
      ];
  String _nItems(int n) => _singularOrPlural(n, 'item', 'items');
  String mainNItems(int n) => '${_nItems(n)}';
  String mainNItemsLeft(int n) => '${_nItems(n)} left';
  String get mainEmptyStateTitle => 'A fresh start';
  String get mainInTheCart => 'in the cart';
  String get mainNotAvailable => 'not available';
  String get mainAddItem => 'Add item';
  String get mainSwipeHint => 'swipe';
  String get mainSwipeGotIt => 'Got it';
  String get mainSwipeNotAvailable => 'Not available';
  String get mainHowAboutSomeOfThese => 'How about some of these?';
  String mainSnackbarPutItemInCart(String item) =>
      'Marked $item as not available.';
  String mainSnackbarMarkedItemAsNotAvailable(String item) =>
      'Marked $item as not available.';
  String mainSuggestionsTitle(int n) =>
      n == 1 ? 'How about this one?' : 'How about some of these?';
  String get mainSuggestionRemovalTitle => 'Remove suggestion?';
  String mainSuggestionRemovalDetails(String suggestion) =>
      'This will cause "$suggestion" to no longer appear in suggestion chips or Smart Compose.';
  String get mainSuggestionRemovalYes => 'Remove';
  String get mainSuggestionRemovalNo => 'Cancel';
  String get inputHint => 'New item';
  String get inputDelete => 'Delete';
  String get inputSave => 'Save';
  String get inputEditExisting => 'Edit existing';
  String get inputAdd => 'Add';
  String get inputSmartComposeSwipe => 'swipe';
  String get completedSwipeDelete => 'Delete';
  String get completedSwipePutBackOnList => 'Put back on the list';
  String completedDeleteConfirmation(String item) => 'Deleted $item.';
  String completedPutBackOnListConfirmation(String item) =>
      'Put $item back on the list.';
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
  String get settingsDebugInfoDetails => 'Useful while developing the app';
  String get settingsFeedback => 'Feedback';
  String get settingsFeedbackDetails => 'Report bugs or ideas';
  String get settingsRateTheApp => 'Rate the app';
  String get settingsRateTheAppDetails => 'On the Google Play Store';
  String get settingsPrivacyPolicy => 'Privacy Policy';
  String get settingsPrivacyPolicyDetails => 'An easy-to-read Google Doc';
  String get settingsOpenSourceLicenses => 'Open Source Licenses';
  String get suggestionsTitle => 'Suggestions';
  String get suggestionsExplanation =>
      'Items you add to the list are recorded here. Each item has a score. Items with higher scores are more likely to be suggested. If you use an item, its score increases by 1. Over time, the scores automatically decrease exponentially.';
  String get debugInfoTitle => 'Debug information';
  String get debugInfoCopyConfirmation => 'Copied to clipboard.';
}

class _GermanTranslation extends Translation {
  const _GermanTranslation();

  String get generalUndo => 'Rückgängig machen';
  List<String> get defaultItems => [
        // Popular food in the US.
        'Wasser', 'Kartoffeln', 'Bananen', 'Milch', 'Brot', 'Tomaten', 'Käse',
        'Apfel', 'Zwiebeln', 'Toast', 'Melone', 'Orange', 'Gurke',
        'Weintrauben', 'Pflaumen', 'Grapefruit', 'Zitrone', 'Erdbeeren',
        'Möhren', 'Pizza', 'Ananas', 'Pfeffer', 'Salat', 'Honig', 'Kohl',
        'Blaubeeren', 'Kiwis', 'Himbeeren', 'Butter', 'Pilze', 'Kirschen',
        'Brokkoli', 'Cranberries', 'Knoblauch', 'Mandarinen', 'Spinat', 'Mehl',
        'Bohnen', 'Sellerie', 'Limetten', 'Oliven', 'Kürbis', 'Süßkartoffeln',
        'Mango', 'Avocado', 'Aubergine', 'Müsli', 'Artischocken', 'Reis',
        'Radieschen', 'Huhn', 'Papayas', 'Erdnüsse', 'Haselnüsse', 'Erbsen',
        'Birnen', 'Eis', 'Aprikosen', 'Mais', 'Walnuss', 'Steak',
        'Macadamianüsse', 'Fisch', 'Margarine', 'Zuckerrübensirup', 'Mandeln',
        'Pistazien', 'Lamm', 'Pekanüsse', 'Pommes', 'Salz',
      ];
  String _nItems(int n) => _singularOrPlural(n, 'Eintrag', 'Einträge');
  String mainNItems(int n) => '${_nItems(n)}';
  String mainNItemsLeft(int n) => '${_nItems(n)} übrig';
  String get mainEmptyStateTitle => 'Ein neuer Start';
  String get mainInTheCart => 'im Wagen';
  String get mainNotAvailable => 'nicht da';
  String get mainAddItem => 'Eintrag hinzufügen';
  String get mainSwipeHint => 'wischen';
  String get mainSwipeGotIt => 'Ist im Wagen';
  String get mainSwipeNotAvailable => 'Ist nicht da';
  String get mainHowAboutSomeOfThese => "Wie wär's mit diesen?";
  String mainSnackbarPutItemInCart(String item) => '$item ist im Wagen.';
  String mainSnackbarMarkedItemAsNotAvailable(String item) =>
      '$item ist nicht da.';
  String mainSuggestionsTitle(int n) => "Wie wär's hiermit?";
  String get mainSuggestionRemovalTitle => 'Vorschlag entfernen?';
  String mainSuggestionRemovalDetails(String suggestion) =>
      '$suggestion wird dann nicht mit als Vorschlag oder bei Smart Compose '
      'angezeigt.';
  String get mainSuggestionRemovalYes => 'Entfernen';
  String get mainSuggestionRemovalNo => 'Abbrechen';
  String get inputHint => 'Neuer Eintrag';
  String get inputDelete => 'Löschen';
  String get inputSave => 'Speichern';
  String get inputEditExisting => 'Bearbeiten';
  String get inputAdd => 'Hinzufügen';
  String get inputSmartComposeSwipe => 'wischen';
  String get completedSwipeDelete => 'Löschen';
  String get completedSwipePutBackOnList => 'Wieder auf die Liste setzen';
  String completedDeleteConfirmation(String item) => '$item gelöscht.';
  String completedPutBackOnListConfirmation(String item) =>
      '$item wieder auf die Liste gesetzt.';
  String get inTheCartTitle => 'Im Wagen';
  String get inTheCartClearAll => 'Alle löschen';
  String get notAvailableTitle => 'Nicht da';
  String get notAvailableClearAll => 'Alle löschen';
  String get settingsTitle => 'Einstellungen';
  String get settingsTheme => 'Farbschema';
  String get settingsThemeDialogTitle => 'Wähle ein Farbschema';
  String get settingsThemeLight => 'Hell';
  String get settingsThemeDark => 'Dunkel';
  String get settingsThemeBlack => 'Schwarz';
  String get settingsThemeSystemLightDark => 'System (hell/dunkel)';
  String get settingsThemeSystemLightBlack => 'System (hell/schwarz)';
  String get settingsShowSuggestions => 'Vorschläge anzeigen';
  String get settingsShowSuggestionsDetails => 'Am Ende der Liste';
  String get settingsSmartCompose => 'Smart Compose';
  String get settingsSmartComposeDetails => 'Autovervollständigungen bein '
      'Hinzufügen von neuen Einträgen anzeigen';
  String get settingsSmartInsertion => 'Smart Insertion';
  String get settingsSmartInsertionDetails =>
      'Einträge an der richtigen Stelle hinfügen abhängig davon, in welcher '
      'Reihenfolge sie vorher abgehakt wurden';
  String get settingsDefaultInsertion => 'Standard-Einfügeort';
  String get settingsDefaultInsertionTop => 'Oben';
  String get settingsDefaultInsertionBottom => 'Unten';
  String settingsSuggestionsNItems(int n) => '${_nItems(n)}';
  String get settingsDebugInfoDetails => 'Nützlich während der App-Entwicklung';
  String get settingsFeedback => 'Feedback';
  String get settingsFeedbackDetails =>
      'Melde Bugs oder schlage Verbesserungen vor';
  String get settingsRateTheApp => 'App bewerten';
  String get settingsRateTheAppDetails => 'Auf dem Google Play Store';
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
  String get debugInfoTitle => 'Debug-Informationen';
  String get debugInfoCopyConfirmation => 'Infos wurden kopiert.';
}
