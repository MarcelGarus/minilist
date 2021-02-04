import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

import 'core/core.dart';

extension ShowCreateItemSheet on BuildContext {
  Future<String?> showCreateItemSheet() {
    return this.showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Padding(
        padding: context.mediaQuery.viewInsets,
        child: CreateItemSheet(),
      ),
    );
  }
}

class CreateItemSheet extends StatefulWidget {
  @override
  _CreateItemSheetState createState() => _CreateItemSheetState();
}

class _CreateItemSheetState extends State<CreateItemSheet> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'New item',
                border: InputBorder.none,
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, _, __) {
              final text = _controller.text;
              return FlatButton(
                child: Text('Add'),
                onPressed: list.items.value.contains(text)
                    ? null
                    : () => context.navigator.pop(_controller.text),
              );
            },
          ),
        ],
      ),
    );
  }
}
