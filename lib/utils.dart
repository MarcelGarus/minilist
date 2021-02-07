import 'package:flutter/material.dart';

import 'theme.dart';

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
          Text('$text ', style: TextStyle(fontSize: 12, color: color)),
          Icon(Icons.arrow_right_alt, size: 12, color: color),
        ],
      ),
    );
  }
}
