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
    return Dismissible(
      key: Key(item),
      background: Container(
        color: context.color.inTheCart,
        padding: EdgeInsets.symmetric(horizontal: context.padding.outer),
        child: Row(
          children: [
            Icon(Icons.check, color: context.color.onInTheCart),
            SizedBox(width: context.padding.inner),
            Text(
              'Got it',
              style: context.standardStyle.copyWith(
                color: context.color.onInTheCart,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: context.color.notAvailable,
        padding: EdgeInsets.symmetric(horizontal: context.padding.outer),
        child: Row(
          children: [
            Spacer(),
            Text(
              'Not available',
              style: context.standardStyle.copyWith(
                color: context.color.onNotAvailable,
              ),
            ),
            SizedBox(width: context.padding.inner),
            Icon(Icons.not_interested, color: context.color.onNotAvailable),
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
        color: context.color.background,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.padding.outer,
              vertical: context.padding.inner,
            ),
            child: Container(
              width: double.infinity,
              child: Text(item, style: context.itemStyle),
            ),
          ),
        ),
      ),
    );
  }
}
