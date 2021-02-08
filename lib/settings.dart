import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:url_launcher/url_launcher.dart';

import 'core/core.dart';
import 'theme.dart';

const privacyPolicy =
    'https://docs.google.com/document/d/1oIG3r8gZex-23seHeXSGrk0cC4eptV8vf96-_UqSM4Y';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.background,
      appBar: SettingsAppBar(title: 'Settings'),
      body: ListView(
        children: [
          ReferenceBuilder(
            reference: settings.theme,
            builder: (context) => SettingsListTile(
              title: 'Theme',
              subtitle: settings.theme.value.toBeautifulString(),
              onTap: () => showDialog(
                context: context,
                builder: (_) => ThemeModeChooserDialog(),
              ),
            ),
          ),
          SettingsToggleListTile(
            reference: settings.showSuggestions,
            title: 'Show suggestions',
            subtitle: 'At the bottom of the list',
          ),
          SettingsToggleListTile(
            reference: settings.showSmartCompose,
            title: 'Smart Compose',
            subtitle: 'Autocomplete while typing',
          ),
          SettingsToggleListTile(
            reference: settings.useSmartInsertion,
            title: 'Smart Insertion',
            subtitle:
                'Insert items based on how they were completed in the past',
          ),
          ReferenceBuilder(
            reference: settings.defaultInsertion,
            builder: (context) => SettingsListTile(
              title: 'Default insertion',
              subtitle: settings.value.defaultInsertion.toBeautifulString(),
              onTap: () => settings.defaultInsertion.value =
                  settings.value.defaultInsertion.opposite,
            ),
          ),
          Divider(color: context.color.secondary),
          ReferenceBuilder(
            reference: suggestionEngine.state,
            builder: (context) => SettingsListTile(
              title: 'Suggestions',
              subtitle: '${suggestionEngine.allSuggestions.length} items',
              onTap: () => context.navigator.push(MaterialPageRoute(
                builder: (_) => SuggestionsPage(),
              )),
            ),
          ),
          SettingsListTile(title: 'History', subtitle: 'Some data'),
          SettingsListTile(title: 'Reset', subtitle: 'Removes all items'),
          Divider(color: context.color.secondary),
          SettingsListTile(title: 'Analytics', subtitle: 'Disabled'),
          SettingsListTile(
            title: 'Privacy Policy',
            subtitle: "An easy-to-read Google Doc",
            trailing: Icon(Icons.open_in_new, color: context.color.secondary),
            onTap: () => launch(privacyPolicy),
          ),
          SettingsListTile(
            title: 'Open Source Licenses',
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'MiniList',
              applicationVersion: '0.0.1',
            ),
          ),
        ],
      ),
    );
  }
}

class ThemeModeChooserDialog extends StatelessWidget {
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
        title: Text('Choose theme', style: context.accentStyle),
        children: [
          for (final mode in ThemeMode.values)
            RadioListTile(
              activeColor: context.color.primary,
              title:
                  Text(mode.toBeautifulString(), style: context.standardStyle),
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

class SuggestionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.background,
      appBar: SettingsAppBar(title: 'Suggestions'),
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
          'Items you add to the list are recorded here. '
          'Each item has a score. '
          'Items with higher scores are suggested more frequently. '
          'If you use an item, its score increases by 1. '
          'Over time, the scores automatically decrease exponentially.',
          style: context.standardStyle,
        ),
      ),
    );
  }
}

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({required this.title});

  final String title;

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: context.color.onBackground),
      backgroundColor: context.color.canvas,
      title: Text(title, style: context.accentStyle.copyWith(fontSize: 20)),
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
