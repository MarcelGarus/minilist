import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

import 'theme.dart';

class SuggestionChip extends StatelessWidget {
  const SuggestionChip({
    required this.item,
    required this.onPressed,
    required this.onLongPressed,
  });

  final String item;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;

  @override
  Widget build(BuildContext context) {
    // return ActionChip(
    //   label: Text(item),
    //   onPressed: onTap,
    //   pressElevation: 4,
    //   backgroundColor: context.appTheme.backgroundColor,
    // );

    return CustomPaint(
      foregroundPainter: StadiumPainter(
        padding: EdgeInsets.all(8),
        backgroundColor: context.appTheme.backgroundColor,
        borderColor: context.appTheme.hintStyle.color!,
      ),
      child: Material(
        color: context.appTheme.backgroundColor,
        shape: StadiumBorder(),
        child: InkWell(
          onTap: onPressed,
          onLongPress: onLongPressed,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                item,
                style: context.appTheme.hintStyle.copyWith(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StadiumPainter extends CustomPainter {
  StadiumPainter({
    required this.padding,
    required this.backgroundColor,
    required this.borderColor,
  });

  final EdgeInsets padding;
  final Color backgroundColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final chip = RRect.fromLTRBR(
      padding.left,
      padding.top,
      size.width - padding.right,
      size.height - padding.bottom,
      Radius.circular(size.height - padding.top - padding.bottom),
    );
    canvas.drawPath(
      Path()
        ..addRRect(chip)
        ..addRect(Offset.zero & size)
        ..fillType = PathFillType.evenOdd,
      Paint()..color = backgroundColor,
    );
    canvas.drawPath(
      Path()..addRRect(chip),
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(StadiumPainter oldDelegate) {
    return true;
  }
}
