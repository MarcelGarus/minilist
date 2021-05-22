import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

import 'core/core.dart';
import 'i18n.dart';
import 'theme.dart';
import 'utils.dart';

extension ShowItemSheet on BuildContext {
  Future<void> showCreateItemSheet() => _showRoundedSheet(_ItemSheet());
  Future<void> showEditItemSheet(String editedItem) =>
      _showRoundedSheet(_ItemSheet(editedItem: editedItem));

  Future<void> _showRoundedSheet(Widget sheet) {
    return this.showModalBottomSheet(
      backgroundColor: color.canvas,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => sheet,
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
                hintText: _isEditingExisting
                    ? widget.editedItem
                    : context.t.inputHint,
                smartComposer: (prefix) {
                  return settings.showSmartCompose.value
                      ? suggestionEngine.suggestionFor(prefix)
                      : null;
                },
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
          MyTextButton(
            text: context.t.inputDelete,
            onPressed: () {
              list.items.mutate((items) => items.remove(_editedItem));
              context.navigator.pop();
            },
          ),
          MyTextButton(
            text: context.t.inputSave,
            onPressed: _alreadyExists
                ? null
                : () {
                    list.items.mutate((items) {
                      final index = items.indexOf(_editedItem!);
                      items[index] = _item;
                    });
                    context.navigator.pop();
                  },
          ),
        ],
      );
    }

    if (_alreadyExists) {
      return MyTextButton(
        text: context.t.inputEditExisting,
        onPressed: () => setState(() => _editedItem = _item),
      );
    }

    return MyTextButton(
      text: context.t.inputAdd,
      onPressed: () {
        list.add(_item);
        suggestionEngine.add(_item);
        context.navigator.pop();
      },
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
              onboarding.swipeToSmartCompose.used();
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
                          if (onboarding.swipeToSmartCompose.showExplanation)
                            WidgetSpan(
                              alignment: PlaceholderAlignment.bottom,
                              baseline: TextBaseline.alphabetic,
                              child: SwipeRightIndicator(
                                text: context.t.inputSmartComposeSwipe,
                                color: context.color.secondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: TextField(
                  autofocus: true,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  controller: controller,
                  style: context.itemStyle,
                  cursorColor: context.color.primary,
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
