import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/core.dart';
import '../i18n.dart';
import '../theme.dart';
import 'utils.dart';

class DebugInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final text = [
      'mediaQuery = ' + context.mediaQuery.toDebugString(),
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
                behavior: SnackBarBehavior.floating,
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

extension on MediaQueryData {
  String toDebugString() {
    return [
      'MediaQuery(',
      'size: $size,'.indent(),
      'devicePixelRatio: $devicePixelRatio,'.indent(),
      'textScaleFactor: $textScaleFactor,'.indent(),
      'platformBrightness: $platformBrightness,'.indent(),
      'padding: $padding,'.indent(),
      'viewPadding: $viewPadding,'.indent(),
      'viewInsets: $viewInsets,'.indent(),
      'alwaysUse24HourFormat: $alwaysUse24HourFormat,'.indent(),
      'accessibleNavigation: $accessibleNavigation,'.indent(),
      'highContrast: $highContrast,'.indent(),
      'disableAnimations: $disableAnimations,'.indent(),
      'invertColors: $invertColors,'.indent(),
      'boldText: $boldText,'.indent(),
      'navigationMode: $navigationMode,'.indent(),
      ')',
    ].joinLines();
  }
}
