import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart';

import 'core/core.dart';
import 'theme.dart';

class CompletedSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReferencesBuilder(
      references: [list.inTheCart, list.notAvailable],
      builder: (context) {
        return Row(
          children: [
            Expanded(
              child: CompletedBucket(
                primaryText: list.inTheCart.length.toString(),
                secondaryText: 'in the cart',
                color: context.color.inTheCartTint,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: CompletedBucket(
                primaryText: list.notAvailable.length.toString(),
                secondaryText: 'not available',
                color: context.color.notAvailableTint,
              ),
            ),
          ],
        );
      },
    );
  }
}

class CompletedBucket extends StatelessWidget {
  const CompletedBucket({
    required this.primaryText,
    required this.secondaryText,
    required this.color,
  });

  final String primaryText;
  final String secondaryText;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              primaryText,
              style: context.accentStyle.copyWith(fontSize: 20),
            ),
            SizedBox(height: 4),
            Text(secondaryText, style: context.standardStyle),
          ],
        ),
      ),
    );
  }
}
