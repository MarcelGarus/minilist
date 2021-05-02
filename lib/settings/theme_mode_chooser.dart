import 'package:flutter/material.dart' hide ThemeMode;
import 'package:black_hole_flutter/black_hole_flutter.dart';

import '../core/core.dart';
import '../i18n.dart';
import '../theme.dart';

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
