import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:url_launcher/url_launcher.dart';

import '../core/core.dart';
import '../i18n.dart';
import '../theme.dart';
import 'debug_info_page.dart';
import 'suggestions_page.dart';
import 'theme_mode_chooser.dart';
import 'transfer_page.dart';
import 'utils.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SettingsAppBar(title: context.t.settingsTitle),
      body: ListView(
        children: [
          // Usage settings.
          ReferenceBuilder(
            reference: settings.theme,
            builder: (context) => SettingsListTile(
              title: context.t.settingsTheme,
              subtitle: settings.theme.value.toBeautifulString(context.t),
              onTap: () => showDialog(
                context: context,
                builder: (_) => ThemeModeChooserDialog(),
              ),
            ),
          ),
          SettingsToggleListTile(
            reference: settings.showSuggestions,
            title: context.t.settingsShowSuggestions,
            subtitle: context.t.settingsShowSuggestionsDetails,
          ),
          SettingsToggleListTile(
            reference: settings.showSmartCompose,
            title: context.t.settingsSmartCompose,
            subtitle: context.t.settingsSmartComposeDetails,
          ),
          SettingsToggleListTile(
            reference: settings.useSmartInsertion,
            title: context.t.settingsSmartInsertion,
            subtitle: context.t.settingsSmartInsertionDetails,
          ),
          ReferenceBuilder(
            reference: settings.defaultInsertion,
            builder: (context) => SettingsListTile(
              title: context.t.settingsDefaultInsertion,
              trailing: Text(
                settings.value.defaultInsertion.toBeautifulString(context.t),
              ),
              onTap: () => settings.defaultInsertion.value =
                  settings.value.defaultInsertion.opposite,
            ),
          ),
          SettingsToggleListTile(
            reference: settings.optimizeForLeftHandedUse,
            title: context.t.settingsOptimizeForLeftHandedUse,
            subtitle: context.t.settingsOptimizeForLeftHandedUseDetails,
          ),
          Divider(color: context.color.secondary),
          // See data.
          ReferenceBuilder(
            reference: suggestionEngine.state,
            builder: (context) => SettingsListTile(
              title: context.t.settingsSuggestions,
              subtitle: context.t.settingsSuggestionsNItems(
                  suggestionEngine.allSuggestions.length),
              onTap: () => context.navigator.push(MaterialPageRoute(
                builder: (_) => SuggestionsPage(),
              )),
            ),
          ),
          // SettingsListTile(title: 'History', subtitle: 'Some data'),
          SettingsListTile(
            title: context.t.settingsTransfer,
            subtitle: context.t.settingsTransferDetails,
            onTap: () => context.navigator.push(MaterialPageRoute(
              builder: (_) => TransferPage(),
            )),
          ),
          SettingsListTile(
            title: context.t.settingsDebugInfo,
            subtitle: context.t.settingsDebugInfoDetails,
            onTap: () => context.navigator.push(MaterialPageRoute(
              builder: (_) => DebugInfoPage(),
            )),
          ),
          Divider(color: context.color.secondary),
          // Less important stuff.
          SettingsListTile(
            title: context.t.settingsFeedback,
            subtitle: context.t.settingsFeedbackDetails,
            trailing: Icon(Icons.open_in_new, color: context.color.secondary),
            onTap: () => launch(context.t.settingsFeedbackUrl),
          ),
          SettingsListTile(
            title: context.t.settingsRateTheApp,
            subtitle: context.t.settingsRateTheAppDetails,
            trailing: Icon(Icons.open_in_new, color: context.color.secondary),
            onTap: () => launch(context.t.settingsRateTheAppUrl),
          ),
          SettingsListTile(
            title: context.t.settingsPrivacyPolicy,
            subtitle: context.t.settingsPrivacyPolicyDetails,
            trailing: Icon(Icons.open_in_new, color: context.color.secondary),
            onTap: () => launch(context.t.settingsPrivacyPolicyUrl),
          ),
          SettingsListTile(
            title: context.t.settingsOpenSourceLicenses,
            onTap: () => showLicensePage(
              context: context,
              applicationName: context.t.generalTitle,
              applicationVersion: '0.0.1',
            ),
          ),
        ],
      ),
    );
  }
}
