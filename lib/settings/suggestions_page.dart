import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart';

import '../core/core.dart';
import '../i18n.dart';
import '../theme.dart';
import 'utils.dart';

class SuggestionsPage extends StatelessWidget {
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
