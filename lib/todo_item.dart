import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

import 'theme.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    required this.item,
    this.onTap,
    this.onPrimarySwipe,
    this.onSecondarySwipe,
  });

  final String item;
  final VoidCallback? onTap;
  final VoidCallback? onPrimarySwipe;
  final VoidCallback? onSecondarySwipe;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Dismissible(
      key: Key(item),
      background: Container(
        color: theme.inTheCartColor,
        padding: EdgeInsets.symmetric(horizontal: theme.outerPadding),
        child: Row(
          children: [
            Icon(Icons.check, color: theme.onInTheCartColor),
            SizedBox(width: theme.innerPadding),
            Text('Got it', style: TextStyle(color: theme.onInTheCartColor)),
            Spacer(),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: theme.notAvailableColor,
        padding: EdgeInsets.symmetric(horizontal: theme.outerPadding),
        child: Row(
          children: [
            Spacer(),
            Text(
              'Not available',
              style: TextStyle(color: theme.onNotAvailableColor),
            ),
            SizedBox(width: theme.innerPadding),
            Icon(Icons.not_interested, color: theme.onNotAvailableColor),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onPrimarySwipe?.call();
        } else {
          onSecondarySwipe?.call();
        }
      },
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.outerPadding,
              vertical: theme.innerPadding,
            ),
            child: Container(width: double.infinity, child: Text(item)),
          ),
        ),
      ),
    );
  }
}
