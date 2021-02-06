import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart' hide ThemeMode;

import 'core/core.dart';
import 'theme.dart';

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
          ReferenceBuilder(
            reference: suggestionEngine.state,
            builder: (context) => SettingsListTile(
              title: 'Suggestions',
              subtitle: '${suggestionEngine.items.length} suggestions exist.',
              onTap: () => context.navigator.push(MaterialPageRoute(
                builder: (_) => SuggestionsPage(),
              )),
            ),
          ),
          SettingsListTile(title: 'Reset', subtitle: 'Reset the list.'),
          SettingsListTile(title: 'Analytics', subtitle: 'Disabled'),
          SettingsListTile(
            title: 'Privacy Policy',
            subtitle: "Don't worry, it's an easy-to-read Google Doc.",
            trailing: Icon(Icons.open_in_new, color: context.color.secondary),
          ),
          SettingsListTile(
            title: 'Open Source Licenses',
            trailing: Icon(Icons.open_in_new, color: context.color.secondary),
          ),
          SettingsListTile(
            title: 'Help & Feedback',
            trailing: Icon(Icons.open_in_new, color: context.color.secondary),
          ),
        ],
      ),
    );
  }
}

class ThemeModeChooserDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: context.color.canvas,
      title: Text('Choose theme', style: context.accentStyle),
      children: [
        for (final mode in ThemeMode.values)
          RadioListTile(
            activeColor: context.color.primary,
            title: Text(mode.toBeautifulString(), style: context.standardStyle),
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
          final suggestions = suggestionEngine.items.toList();
          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return SettingsListTile(
                title: suggestion,
                trailing: Text(
                  suggestionEngine.scoreOf(suggestion).toStringAsFixed(2),
                  style: context.standardStyle
                      .copyWith(color: context.color.secondary),
                ),
              );
            },
          );
        },
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
