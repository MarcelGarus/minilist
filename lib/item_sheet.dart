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
      child: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (_, __, ___) => Row(
          children: [
            Expanded(
              child: SmartComposingTextField(
                controller: _controller,
                hintText: _isEditingExisting ? widget.editedItem : 'New item',
                smartComposer: suggestionEngine.suggestionFor,
              ),
            ),
            _buildButton(),
          ],
        ),
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

class SmartComposingTextField extends StatefulWidget {
  const SmartComposingTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.smartComposer,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final String? Function(String prefix) smartComposer;

  @override
  _SmartComposingTextFieldState createState() =>
      _SmartComposingTextFieldState();
}

class _SmartComposingTextFieldState extends State<SmartComposingTextField> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, _, __) {
        final suggestion = widget.smartComposer(widget.controller.text);
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (startInfo) {},
          // _dragStart = startInfo.localPosition.dx,
          onHorizontalDragEnd: (endInfo) {
            if (suggestion != null) {
              widget.controller
                ..text = suggestion
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: suggestion.length),
                );
            }
          },
          child: Stack(
            children: [
              if (suggestion != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text.rich(
                    TextSpan(
                      style: context.appTheme.hintStyle,
                      children: <InlineSpan>[
                        TextSpan(text: '$suggestion '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.bottom,
                          baseline: TextBaseline.alphabetic,
                          child: SwipeRightIndicator(),
                        ),
                      ],
                    ),
                  ),
                  //Text('Some text.', style: context.appTheme.hintStyle),
                ),
              TextField(
                autofocus: true,
                maxLines: null,
                controller: widget.controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: widget.hintText,
                  hintStyle: context.appTheme.hintStyle,
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SwipeRightIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = context.appTheme.hintStyle.color!;
    return Container(
      height: 22,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('swipe ', style: TextStyle(fontSize: 12, color: color)),
          Icon(Icons.arrow_right_alt, size: 16, color: color),
        ],
      ),
    );
  }
}
