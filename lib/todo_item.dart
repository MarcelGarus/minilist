import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    required this.item,
    this.onPrimarySwipe,
    this.onSecondarySwipe,
  });

  final String item;
  final VoidCallback? onPrimarySwipe;
  final VoidCallback? onSecondarySwipe;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item),
      background: Container(
        color: context.theme.primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.check, color: Colors.white),
            SizedBox(width: 16),
            Text('Got it', style: TextStyle(color: Colors.white, fontSize: 20)),
            Spacer(),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Spacer(),
            Text('Not available',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(width: 16),
            Icon(Icons.not_interested, color: Colors.white),
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
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        title: Text(item, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
