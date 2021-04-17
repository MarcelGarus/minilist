import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

import 'i18n.dart';
import 'theme.dart';

extension UndoAction on BuildContext {
  void offerUndo(String text, VoidCallback undo) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(label: t.generalUndo, onPressed: undo),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class MyTextButton extends StatelessWidget {
  const MyTextButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.color.primary;
    return TextButton(
      child: Text(
        text,
        style: context.accentStyle
            .copyWith(color: color.withOpacity(onPressed == null ? 0.4 : 1)),
      ),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(color.withOpacity(0.1)),
      ),
      onPressed: onPressed,
    );
  }
}

class SwipeRightIndicator extends StatelessWidget {
  const SwipeRightIndicator({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 19,
      padding: EdgeInsets.only(left: 4, top: 2, right: 2, bottom: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Note: There's a thin space after the text.
          Text(text, style: TextStyle(fontSize: 12, color: color)),
          Icon(Icons.arrow_right_alt, size: 12, color: color),
        ],
      ),
    );
  }
}

class DismissBackground extends StatelessWidget {
  const DismissBackground({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    required this.text,
    required this.isPrimary,
  });

  DismissBackground.primary({
    required Color backgroundColor,
    required Color foregroundColor,
    required IconData icon,
    required String text,
  }) : this(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          icon: icon,
          text: text,
          isPrimary: true,
        );

  DismissBackground.secondary({
    required Color backgroundColor,
    required Color foregroundColor,
    required IconData icon,
    required String text,
  }) : this(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          icon: icon,
          text: text,
          isPrimary: false,
        );

  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final String text;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    var children = [
      Icon(icon, color: foregroundColor),
      SizedBox(width: context.padding.inner),
      Text(
        text,
        style: context.standardStyle.copyWith(color: foregroundColor),
      ),
      Spacer(),
    ];
    if (!isPrimary) {
      children = children.reversed.toList();
    }

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: context.padding.outer),
      child: Row(children: children),
    );
  }
}
