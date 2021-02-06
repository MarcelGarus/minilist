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
      backgroundColor: color.canvas,
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
      padding: EdgeInsets.all(context.padding.outer),
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
          FancyFlatButton(
            text: 'Delete',
            onPressed: () {
              list.items.value = list.items.value..remove(_editedItem);
              context.navigator.pop();
            },
          ),
          FancyFlatButton(
            text: 'Save',
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
      return FancyFlatButton(
        text: 'Edit existing',
        onPressed: () => setState(() => _editedItem = _item),
      );
    }

    return FancyFlatButton(
      text: 'Add',
      onPressed: () {
        list.items.add(_item);
        suggestionEngine.add(_item);
        context.navigator.pop();
      },
    );
  }
}

class FancyFlatButton extends StatelessWidget {
  const FancyFlatButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        text,
        style: context.accentStyle.copyWith(color: context.color.primary),
      ),
      onPressed: onPressed,
    );
  }
}

class SmartComposingTextField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, _, __) {
        final suggestion = smartComposer(controller.text);
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (startInfo) {},
          onHorizontalDragEnd: (endInfo) {
            if (suggestion != null) {
              controller
                ..text = suggestion
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: suggestion.length),
                );
            }
          },
          child: Stack(
            children: [
              if (suggestion != null)
                Transform.translate(
                  offset: Offset(0, -2), // This has been carefully aligned.
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text.rich(
                      TextSpan(
                        style: context.itemStyle
                            .copyWith(color: context.color.secondary),
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
                ),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: TextField(
                  autofocus: true,
                  maxLines: null,
                  controller: controller,
                  style: context.itemStyle,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: context.itemStyle
                        .copyWith(color: context.color.secondary),
                    border: InputBorder.none,
                  ),
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
    final color = context.color.secondary;
    return Container(
      height: 19,
      padding: EdgeInsets.only(left: 4, top: 2, right: 2, bottom: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('swipe ', style: TextStyle(fontSize: 12, color: color)),
          Icon(Icons.arrow_right_alt, size: 12, color: color),
        ],
      ),
    );
  }
}
