import 'package:flutter/material.dart';

import 'i18n.dart';
import 'theme.dart';
import 'utils.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    required this.item,
    this.onTap,
    this.showSwipeIndicator = false,
  });

  final String item;
  final VoidCallback? onTap;
  final bool showSwipeIndicator;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.padding.outer,
            vertical: context.padding.inner,
          ),
          child: Container(
            width: double.infinity,
            child: Text.rich(
              TextSpan(
                text: item,
                style: context.itemStyle,
                children: [
                  if (showSwipeIndicator)
                    WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.only(left: context.padding.inner),
                        child: SwipeRightIndicator(
                          text: context.t.mainSwipeHint,
                          color: context.color.inTheCart,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
