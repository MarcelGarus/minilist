import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart';

import 'core/core.dart';

extension ShowItemSheet on BuildContext {
  Future<void> showCreateItemSheet() => _showRoundedSheet(_ItemSheet());
  Future<void> showEditItemSheet(String editedItem) =>
      _showRoundedSheet(_ItemSheet(editedItem: editedItem));

  Future<void> _showRoundedSheet(Widget sheet) {
    return this.showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Padding(
        padding: context.mediaQuery.viewInsets,
        child: sheet,
      ),
    );
  }
}

class _ItemSheet extends StatefulWidget {
  _ItemSheet({this.editedItem});

  final String? editedItem;

  @override
  _ItemSheetState createState() => _ItemSheetState();
}

class _ItemSheetState extends State<_ItemSheet> {
  final _controller = TextEditingController();
  String get _item => _controller.text;
  bool get _alreadyExists => list.items.value.contains(_item);

  String? _editedItem;
  bool get _isEditingExisting => _editedItem != null;

  @override
  void initState() {
    super.initState();
    _editedItem = widget.editedItem;
    if (_isEditingExisting) _controller.text = widget.editedItem!;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              controller: _controller,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: _isEditingExisting ? widget.editedItem : 'New item',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _controller,
          builder: (_, __, ___) => _buildButton(),
        ),
      ],
    );
  }

  Widget _buildButton() {
    if (_isEditingExisting) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlatButton(
            child: Text('Delete', style: TextStyle(fontSize: 20)),
            onPressed: () {
              list.items.value = list.items.value..remove(_editedItem);
              context.navigator.pop();
            },
          ),
          FlatButton(
            child: Text('Save', style: TextStyle(fontSize: 20)),
            onPressed: _alreadyExists
                ? null
                : () {
                    final index = list.items.value.indexOf(_editedItem!);
                    list.items[index].value = _item;
                    context.navigator.pop();
                  },
          ),
        ],
      );
    }

    if (_alreadyExists) {
      return FlatButton(
        child: Text('Edit existing', style: TextStyle(fontSize: 20)),
        onPressed: () => setState(() => _editedItem = _item),
      );
    }

    return FlatButton(
      child: Text('Add', style: TextStyle(fontSize: 20)),
      onPressed: () {
        list.items.add(_item);
        suggestionEngine.add(_item);
        context.navigator.pop();
      },
    );
  }
}
