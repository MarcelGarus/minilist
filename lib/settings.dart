import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart';

import 'core/core.dart';
import 'theme.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.background,
      appBar: AppBar(
        backgroundColor: context.color.canvas,
        title: Text(
          'Settings',
          style: context.accentStyle.copyWith(fontSize: 20),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Theme', style: context.accentStyle),
            subtitle: Text('Black', style: context.secondaryStyle),
          ),
          ReferenceBuilder(
            reference: suggestionEngine.state,
            builder: (context) {
              return ListTile(
                title: Text('Suggestions', style: context.accentStyle),
                subtitle: Text(
                  '${suggestionEngine.items.length} suggestions exist.',
                  style: context.secondaryStyle,
                ),
                onTap: () => context.navigator.push(MaterialPageRoute(
                  builder: (_) => SuggestionsPage(),
                )),
              );
            },
          ),
          ListTile(
            title: Text('Reset', style: context.accentStyle),
            subtitle: Text('Reset the list.', style: context.secondaryStyle),
          ),
          ListTile(
            title: Text('Analytics', style: context.accentStyle),
            subtitle: Text(
              'Your data is protected via differential privacy.',
              style: context.secondaryStyle,
            ),
          ),
          ListTile(
            title: Text('Privacy Policy', style: context.accentStyle),
          ),
          ListTile(
            title: Text('Open Source Licenses', style: context.accentStyle),
          ),
          ListTile(
            title: Text('Help & Feedback', style: context.accentStyle),
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
      appBar: AppBar(title: Text('Suggestions')),
      body: ReferenceBuilder(
        reference: suggestionEngine.state,
        builder: (context) {
          final suggestions = suggestionEngine.items.toList();
          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return ListTile(
                title: Text(suggestion, style: context.accentStyle),
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
