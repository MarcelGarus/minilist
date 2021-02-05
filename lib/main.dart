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
import 'theme.dart';
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
    return AppTheme(
      data: AppThemeData.black(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Shopping List',
            theme: context.appTheme.toMaterialThemeData(),
            themeMode: ThemeMode.light,
            home: MainPage(),
          );
        },
      ),
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
        label: Text('Add item', style: TextStyle(fontSize: 16)),
        onPressed: context.showCreateItemSheet,
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReferenceBuilder(reference: list, builder: _buildList);
  }

  Widget _buildList(BuildContext context) {
    final theme = context.appTheme;
    final hasManyItems = list.items.length >= 5;
    return CustomScrollView(
      slivers: [
        ListAppBar(
          title: 'Shopping List',
          subtitle: () {
            if (!hasManyItems) return Container();
            return Text(
              list.areAllItemsInMainList
                  ? '${list.items.length} items'
                  : '${list.items.length} items left',
            );
          }(),
          actions: [
            if (hasManyItems && false)
              IconButton(icon: Icon(Icons.search), onPressed: () {}),
            // IconButton(icon: Icon(Icons.view_agenda_outlined)),
            IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
        SliverToBoxAdapter(
          child: AnimatedCrossFade(
            duration: 200.milliseconds,
            crossFadeState: list.areAllItemsInMainList
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: SizedBox(height: theme.innerPadding),
            secondChild: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.outerPadding,
                vertical: theme.innerPadding,
              ),
              child: CompletedSection(),
            ),
          ),
        ),
        if (list.items.isEmpty)
          SliverToBoxAdapter(child: Center(child: Text('Your list is empty.')))
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
                    final items = list.items.value;
                    final index = items.indexOf(item);
                    list.items.value = items..removeAt(index);
                    list.inTheCart.add(item);
                    context.scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('$item is in the cart.'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            list.inTheCart.value = list.inTheCart.value
                              ..removeLast();
                            list.items.value = list.items.value
                              ..insert(index, item);
                          },
                        ),
                      ),
                    );
                  },
                  onSecondarySwipe: () {
                    final items = list.items.value;
                    final index = items.indexOf(item);
                    list.items.value = items..removeAt(index);
                    list.notAvailable.add(item);
                    context.scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('$item is not available.'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            list.notAvailable.value = list.notAvailable.value
                              ..removeLast();
                            list.items.value = list.items.value
                              ..insert(index, item);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: list.items.length,
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.outerPadding),
            child: Column(
              children: [
                SizedBox(height: theme.innerPadding),
                Text(
                  'How about adding some of these?',
                  textAlign: TextAlign.center,
                  style: theme.suggestionTextStyle,
                ),
                SizedBox(height: theme.innerPadding),
                Wrap(
                  spacing: theme.innerPadding,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final item in suggestionEngine.items.take(6))
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
        // This makes sure that nothing is hidden behin the FAB.
        SliverToBoxAdapter(child: Container(height: 100)),
      ],
    );
  }
}
