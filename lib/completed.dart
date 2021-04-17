import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart';

import 'core/core.dart';
import 'i18n.dart';
import 'theme.dart';
import 'todo_item.dart';
import 'utils.dart';

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
                secondaryText: context.t.mainInTheCart,
                color: context.color.inTheCartTint,
                onTap: () {
                  context.navigator.push(MaterialPageRoute(
                    builder: (_) => InTheCartPage(),
                  ));
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: CompletedBucket(
                primaryText: list.notAvailable.length.toString(),
                secondaryText: context.t.mainNotAvailable,
                color: context.color.notAvailableTint,
                onTap: () {
                  context.navigator.push(MaterialPageRoute(
                    builder: (_) => NotAvailablePage(),
                  ));
                },
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
    required this.onTap,
  });

  final String primaryText;
  final String secondaryText;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
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
      ),
    );
  }
}

class InTheCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.color.inTheCartTint.alphaBlendOn(context.color.background),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: context.color.onBackground),
        elevation: 0,
        title: Text(context.t.inTheCartTitle, style: context.appBarStyle),
        actions: [
          TextButton(
            child: Text(context.t.inTheCartClearAll),
            onPressed: () => list.inTheCart.value = [],
          ),
        ],
      ),
      body: CompletedList(list.inTheCart),
    );
  }
}

class NotAvailablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.color.notAvailableTint.alphaBlendOn(context.color.background),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: context.color.onBackground),
        elevation: 0,
        title: Text(context.t.notAvailableTitle, style: context.appBarStyle),
        actions: [
          TextButton(
            child: Text(context.t.notAvailableClearAll),
            onPressed: () => list.notAvailable.value = [],
          ),
        ],
      ),
      body: CompletedList(list.notAvailable),
    );
  }
}

class CompletedList extends StatelessWidget {
  const CompletedList(this.completedList);

  final Reference<List<String>> completedList;

  @override
  Widget build(BuildContext context) {
    return ReferenceBuilder(
      reference: completedList,
      builder: (context) {
        return ListView.builder(
          itemCount: completedList.length,
          itemBuilder: (context, index) {
            final item = completedList[index].value;
            return Dismissible(
              key: Key(item),
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  completedList.mutate((it) => it.remove(item));
                  context.offerUndo('Deleted $item', () {
                    completedList.mutate((it) => it.insert(index, item));
                  });
                } else {
                  completedList.mutate((it) => it.remove(item));
                  list.add(item);
                  context.offerUndo('Put $item back on the list.', () {
                    completedList.mutate((it) => it.insert(index, item));
                    list.items.mutate((it) => it.remove(item));
                  });
                }
              },
              background: DismissBackground.primary(
                backgroundColor: context.color.delete,
                foregroundColor: context.color.onDelete,
                icon: Icons.check,
                text: 'Delete',
              ),
              secondaryBackground: DismissBackground.secondary(
                backgroundColor: context.color.primary,
                foregroundColor: context.color.onPrimary,
                icon: Icons.undo_outlined,
                text: 'Put back on the list',
              ),
              child: TodoItem(item: item),
            );
          },
        );
      },
    );
  }
}
