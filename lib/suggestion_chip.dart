import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

class SuggestionChip extends StatelessWidget {
  const SuggestionChip({required this.item, required this.onTap});

  final String item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(item, style: TextStyle(fontSize: 20)),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      shape: StadiumBorder(side: BorderSide(color: Colors.black12)),
      pressElevation: 4,
      onPressed: onTap,
    );
  }
}
