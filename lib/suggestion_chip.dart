import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

import 'core/core.dart';
import 'theme.dart';
import 'utils.dart';

class Suggestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'How about some of these?',
          textAlign: TextAlign.center,
          style: context.suggestionStyle,
        ),
        SizedBox(height: context.padding.inner),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            for (final item in suggestionEngine.suggestionsNotInList.take(6))
              SuggestionChip(
                item: item,
                onPressed: () {
                  list.add(item);
                  suggestionEngine.add(item);
                },
                onLongPressed: () => _offerRemovingSuggestion(context, item),
              ),
          ],
        ),
      ],
    );
  }

  void _offerRemovingSuggestion(BuildContext context, String item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.color.canvas,
        title: Text(
          'Remove suggestion?',
          style: context.accentStyle,
        ),
        content: Text(
          'This will cause "$item" to no longer appear in suggestion chips or Smart Compose.',
          style: context.standardStyle,
        ),
        actions: <Widget>[
          MyTextButton(
            text: 'No',
            onPressed: () => context.navigator.pop(),
          ),
          MyTextButton(
            text: 'Yes',
            onPressed: () {
              suggestionEngine.remove(item);
              context.navigator.pop();
            },
          ),
        ],
      ),
    );
  }
}

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
    return CustomPaint(
      foregroundPainter: StadiumPainter(
        padding: EdgeInsets.all(8),
        backgroundColor: context.color.background,
        borderColor: context.color.secondary,
      ),
      child: Material(
        color: context.color.background,
        shape: StadiumBorder(),
        child: InkWell(
          onTap: onPressed,
          onLongPress: onLongPressed,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: EdgeInsets.all(8) +
                EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              item,
              textAlign: TextAlign.center,
              style: context.suggestionStyle,
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
