import 'package:basics/basics.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:reorderables/reorderables.dart';

import 'app_bar.dart';
import 'completed_section.dart';
import 'core/core.dart';
import 'item_sheet.dart';
import 'suggestion_chip.dart';
import 'todo_item.dart';

void main() async {
  await initializeChest();
  tape.register({
    ...tapers.forDartCore,
    0: taper.forList<String>(),
    1: taper.forShoppingList().v0,
    2: taper.forRememberState().v0,
    3: taper.forMap<String, double>(),
  });
  await list.delete();
  await list.open();
  await suggestionEngine.initialize();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TodoList(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('Add item'),
        onPressed: context.showCreateItemSheet,
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReferenceBuilder(
      reference: list,
      builder: (_) {
        final hasManyItems = list.items.length >= 5;
        return CustomScrollView(
          slivers: [
            ListAppBar(
              title: 'Shopping List',
              subtitle: () {
                if (!hasManyItems) return Container();
                return Text(
                  list.inTheCart.isEmpty && list.notAvailable.isEmpty
                      ? '${list.items.length} items'
                      : '${list.items.length} items left',
                  style: TextStyle(fontSize: 20),
                );
              }(),
              actions: [
                if (hasManyItems && false)
                  IconButton(icon: Icon(Icons.search), onPressed: () {}),
                // IconButton(icon: Icon(Icons.view_agenda_outlined)),
                // IconButton(icon: Icon(Icons.list)),
                IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),
            SliverToBoxAdapter(
              child: AnimatedCrossFade(
                duration: 200.milliseconds,
                crossFadeState:
                    list.inTheCart.isNotEmpty || list.notAvailable.isNotEmpty
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                firstChild: SizedBox(height: 16),
                secondChild: Padding(
                  padding: EdgeInsets.all(16),
                  child: CompletedSection(),
                ),
              ),
            ),
            if (list.items.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    'Your list is empty.',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            else
              ReorderableSliverList(
                onReorder: (oldIndex, newIndex) {
                  final items = list.items.value;
                  final item = items.removeAt(oldIndex);
                  items.insert(newIndex, item);
                  list.items.value = items;
                },
                delegate: ReorderableSliverChildBuilderDelegate(
                  (_, i) {
                    final item = list.items[i].value;
                    return TodoItem(
                      item: item,
                      onTap: () => context.showEditItemSheet(item),
                      onPrimarySwipe: () {
                        list.items.value = list.items.value..remove(item);
                        list.inTheCart.add(item);
                      },
                      onSecondarySwipe: () {
                        list.items.value = list.items.value..remove(item);
                        list.notAvailable.add(item);
                      },
                    );
                  },
                  childCount: list.items.length,
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'How about adding some of these?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        for (final item in suggestionEngine.items.take(5))
                          SuggestionChip(
                            item: item,
                            onTap: () {
                              list.items.add(item);
                              suggestionEngine.add(item);
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: Container(height: 100)),
          ],
        );
      },
    );
  }
}
