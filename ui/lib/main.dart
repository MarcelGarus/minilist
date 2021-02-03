import 'package:basics/basics.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'app_bar.dart';
import 'create_item_sheet.dart';
import 'data.dart';

void main() async {
  await initializeChest();
  tape.register({
    ...tapers.forDartCore,
    0: taper.forList<String>(),
    1: taper.forShoppingList().v0,
  });
  await list.delete();
  await list.open();
  runApp(ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  void _addItem(BuildContext context) async {
    final item = await context.showCreateItemSheet();
    if (item != null) list.items.add(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TodoList(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('Add item'),
        onPressed: () => _addItem(context),
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReferenceBuilder(
      reference: list.items,
      builder: (_) {
        final hasManyItems = list.items.length >= 5;
        return CustomScrollView(
          slivers: [
            ListAppBar(
              title: 'Shopping List',
              subtitle: hasManyItems ? '${list.items.length} items' : '',
              actions: [
                if (hasManyItems)
                  IconButton(icon: Icon(Icons.search), onPressed: () {}),
                // IconButton(icon: Icon(Icons.view_agenda_outlined)),
                // IconButton(icon: Icon(Icons.list)),
                IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),
            SliverToBoxAdapter(
              child: ReferencesBuilder(
                references: [list.inTheCart, list.notAvailable],
                builder: (context) {
                  final show =
                      list.inTheCart.isNotEmpty || list.notAvailable.isNotEmpty;
                  return AnimatedCrossFade(
                    duration: 200.milliseconds,
                    crossFadeState: show
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: SizedBox(height: 16),
                    secondChild: Padding(
                      padding: EdgeInsets.all(16),
                      child: CompletedSection(),
                    ),
                  );
                },
              ),
            ),
            if (list.items.isEmpty)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Text(
                      'You have no items on your list.\nHow about some of these?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        ActionChip(
                          label: Text('Milch', style: TextStyle(fontSize: 20)),
                          backgroundColor:
                              context.theme.scaffoldBackgroundColor,
                          shape: StadiumBorder(
                            side: BorderSide(color: Colors.black12),
                          ),
                          onPressed: () => list.items.add('Milch'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => TodoItem(item: list.items[i].value),
                  childCount: list.items.length,
                ),
              ),
            SliverToBoxAdapter(
              child: Container(height: 900),
            ),
          ],
        );
      },
    );
  }
}

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
                color: context.theme.primaryColor.withOpacity(0.2),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: CompletedBucket(
                primaryText: list.notAvailable.length.toString(),
                secondaryText: 'not available',
                color: Colors.grey.withOpacity(0.2),
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
            Text(primaryText, style: TextStyle(fontSize: 24)),
            Text(secondaryText),
          ],
        ),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({required this.item});

  final String item;

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
        list.items.value = list.items.value..remove(item);
        if (direction == DismissDirection.startToEnd) {
          list.inTheCart.add(item);
        } else {
          list.notAvailable.add(item);
        }
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(item, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
