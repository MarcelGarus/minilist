import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/core.dart';
import 'i18n.dart';
import 'theme.dart';

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
                builder: (_) => _ThemeModeChooserDialog(),
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
              subtitle:
                  settings.value.defaultInsertion.toBeautifulString(context.t),
              onTap: () => settings.defaultInsertion.value =
                  settings.value.defaultInsertion.opposite,
            ),
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
                builder: (_) => _SuggestionsPage(),
              )),
            ),
          ),
          SettingsListTile(title: 'History', subtitle: 'Some data'),
          SettingsListTile(
            title: context.t.settingsDebugInfo,
            subtitle: context.t.settingsDebugInfoDetails,
            onTap: () => context.navigator.push(MaterialPageRoute(
              builder: (_) => _DebugInfoPage(),
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
              applicationName: context.t.title,
              applicationVersion: '0.0.1',
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeModeChooserDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all(context.color.secondary),
        ),
      ),
      child: SimpleDialog(
        backgroundColor: context.color.canvas,
        title: Text(
          context.t.settingsThemeDialogTitle,
          style: context.accentStyle,
        ),
        children: [
          for (final mode in ThemeMode.values)
            RadioListTile(
              activeColor: context.color.primary,
              title: Text(
                mode.toBeautifulString(context.t),
                style: context.standardStyle,
              ),
              value: mode,
              groupValue: settings.theme.value,
              selected: settings.theme.value == mode,
              dense: true,
              onChanged: (value) {
                settings.theme.value = mode;
                context.navigator.pop();
              },
            ),
        ],
      ),
    );
  }
}

class _SuggestionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.background,
      appBar: SettingsAppBar(title: context.t.suggestionsTitle),
      body: ReferenceBuilder(
        reference: suggestionEngine.state,
        builder: (context) {
          final suggestions = suggestionEngine.allSuggestions.toList();
          return ListView.builder(
            itemCount: suggestions.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildInfoBox(context);
              }
              final suggestion = suggestions[index - 1];
              return ListTile(
                title: Text(suggestion, style: context.itemStyle),
                trailing: Text(
                  suggestionEngine.scoreOf(suggestion).toStringAsFixed(2),
                  style: context.standardStyle
                      .copyWith(color: context.color.secondary),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.padding.outer,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: context.padding.outer,
        vertical: context.padding.inner,
      ),
      color: context.color.canvas,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          context.t.suggestionsExplanation,
          style: context.standardStyle,
        ),
      ),
    );
  }
}

class _DebugInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final text = [
      'list = ' + list.value.toDebugString(),
      'history = ' + history.value.toDebugString(),
      'suggestions = ' + suggestionEngine.state.value.toDebugString(),
      'settings = ' + settings.value.toDebugString(),
      'onboarding = ' + onboarding.value.toDebugString(),
    ].joinLines();
    return Scaffold(
      backgroundColor: context.color.background,
      appBar: SettingsAppBar(
        title: context.t.debugInfoTitle,
        actions: [
          IconButton(
            icon: Icon(Icons.copy_outlined),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(context.t.debugInfoCopyConfirmation),
              ));
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ReferenceBuilder(
            reference: list,
            builder: (_) {
              return SelectableText(text, style: GoogleFonts.robotoMono());
            },
          ),
        ],
      ),
    );
  }
}

// Helper widgets.

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({required this.title, this.actions = const []});

  final String title;
  final List<Widget> actions;

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backwardsCompatibility: false,
      title: Text(title, style: context.accentStyle.copyWith(fontSize: 20)),
      actions: actions,
    );
  }
}

class SettingsToggleListTile extends StatelessWidget {
  const SettingsToggleListTile({
    required this.reference,
    required this.title,
    this.subtitle,
  });

  final Reference<bool> reference;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: context.accentStyle),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: context.secondaryStyle),
      onTap: reference.toggle,
      trailing: ReferenceSwitch(reference),
    );
  }
}

class ReferenceSwitch extends StatelessWidget {
  const ReferenceSwitch(this.reference);

  final Reference<bool> reference;

  @override
  Widget build(BuildContext context) {
    return ReferenceBuilder(
      reference: reference,
      builder: (_) => Switch(
        value: reference.value,
        onChanged: (_) => reference.toggle(),
      ),
    );
  }
}

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: context.accentStyle),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: context.secondaryStyle),
      onTap: onTap,
      trailing: trailing,
    );
  }
}
