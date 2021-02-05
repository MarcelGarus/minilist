import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart';

import 'core/core.dart';
import 'theme.dart';

extension ShowItemSheet on BuildContext {
  Future<void> showCreateItemSheet() => _showRoundedSheet(_ItemSheet());
  Future<void> showEditItemSheet(String editedItem) =>
      _showRoundedSheet(_ItemSheet(editedItem: editedItem));

  Future<void> _showRoundedSheet(Widget sheet) {
    return this.showModalBottomSheet(
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
    return Padding(
      padding: EdgeInsets.all(context.appTheme.outerPadding),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              maxLines: null,
              controller: _controller,
              decoration: InputDecoration(
                hintText: _isEditingExisting ? widget.editedItem : 'New item',
                hintStyle: context.appTheme.hintStyle,
                border: InputBorder.none,
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (_, __, ___) => _buildButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    if (_isEditingExisting) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlatButton(
            child: Text('Delete'),
            onPressed: () {
              list.items.value = list.items.value..remove(_editedItem);
              context.navigator.pop();
            },
          ),
          FlatButton(
            child: Text('Save'),
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
        child: Text('Edit existing'),
        onPressed: () => setState(() => _editedItem = _item),
      );
    }

    return FlatButton(
      child: Text('Add'),
      onPressed: () {
        list.items.add(_item);
        suggestionEngine.add(_item);
        context.navigator.pop();
      },
    );
  }
}
