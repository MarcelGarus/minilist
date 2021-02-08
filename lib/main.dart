import 'package:basics/basics.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:chest_flutter/chest_flutter.dart' hide TaperForThemeMode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:reorderables/reorderables.dart';

import 'app_bar.dart';
import 'completed_section.dart';
import 'core/core.dart';
import 'item_sheet.dart';
import 'settings.dart';
import 'suggestion_chip.dart';
import 'theme.dart';
import 'todo_item.dart';
import 'utils.dart';

void main() async {
  await initializeChest();
  tape.register({
    ...tapers.forDartCore,
    0: taper.forList<String>(),
    1: taper.forShoppingList().v0,
    2: taper.forRememberState().v0,
    3: taper.forMap<String, double>(),
    4: taper.forSettings().v0,
    5: taper.forThemeMode().v0,
    6: taper.forOnboardingState().v0,
    7: taper.forOnboardingCountdown().v0,
    8: taper.forHistoryItem().v0,
    9: taper.forList<HistoryItem>(),
  });
  await Future.wait([
    history.open(),
    list.open(),
    onboarding.open(),
    settings.open(),
    suggestionEngine.initialize(),
  ]);
  runApp(ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReferenceBuilder(
      reference: settings,
      builder: (_) => AppTheme(
        data: AppThemeData.fromThemeMode(settings.theme.value),
        child: Builder(
          builder: (context) {
            return MaterialApp(
              title: 'Shopping List',
              theme: ThemeData(accentColor: context.color.primary),
              home: MainPage(),
            );
          },
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.background,
      body: TodoList(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: context.color.primary,
        icon: Icon(Icons.add, color: context.color.onPrimary),
        label: Text(
          'Add item',
          style: context.accentStyle.copyWith(color: context.color.onPrimary),
        ),
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
              style: context.standardStyle,
            );
          }(),
          actions: [
            if (hasManyItems && false)
              IconButton(icon: Icon(Icons.search), onPressed: () {}),
            // IconButton(icon: Icon(Icons.view_agenda_outlined)),
            OverflowBar(),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: context.color.onBackground),
              color: context.color.canvas,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'settings',
                  child: Text('Settings', style: context.standardStyle),
                ),
              ],
              onSelected: (String value) {
                if (value == 'settings')
                  context.navigator.push(MaterialPageRoute(
                    builder: (_) => SettingsPage(),
                  ));
              },
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: AnimatedCrossFade(
            duration: 200.milliseconds,
            crossFadeState: list.areAllItemsInMainList
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: SizedBox(height: context.padding.inner),
            secondChild: Padding(
              padding: EdgeInsets.only(
                left: context.padding.outer,
                right: context.padding.outer,
                top: context.padding.inner,
                bottom: 2 * context.padding.inner,
              ),
              child: CompletedSection(),
            ),
          ),
        ),
        if (list.items.isEmpty)
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                'A fresh start',
                textAlign: TextAlign.center,
                style: context.accentStyle,
              ),
            ),
          )
        else
          ReorderableSliverList(
            onReorder: (oldIndex, newIndex) => list.items.mutate((items) {
              final item = items.removeAt(oldIndex);
              items.insert(newIndex, item);
            }),
            buildDraggableFeedback: (context, constraints, child) {
              return Material(
                elevation: 2,
                color: context.color.canvas,
                child: SizedBox.fromSize(
                  size: constraints.biggest,
                  child: child,
                ),
              );
            },
            delegate: ReorderableSliverChildBuilderDelegate(
              (_, index) {
                final item = list.items[index].value;
                return TodoItem(
                  item: item,
                  onTap: () => context.showEditItemSheet(item),
                  onPrimarySwipe: () {
                    list.items.mutate((it) => it.removeAt(index));
                    list.inTheCart.add(item);
                    onboarding.swipeToPutInCart.used();
                    history.checkedItem(item);
                    context.scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('$item is in the cart.'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            list.inTheCart.mutate((it) => it.removeLast());
                            list.items.mutate((it) => it.insert(index, item));
                          },
                        ),
                      ),
                    );
                  },
                  onSecondarySwipe: () {
                    list.items.mutate((it) => it.removeAt(index));
                    list.notAvailable.add(item);
                    context.scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('$item is not available.'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            list.notAvailable.mutate((it) => it.removeLast());
                            list.items.mutate((it) => it.insert(index, item));
                          },
                        ),
                      ),
                    );
                  },
                  showSwipeIndicator:
                      onboarding.swipeToPutInCart.showExplanation && index == 0,
                );
              },
              childCount: list.items.length,
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.padding.outer),
            child: Column(
              children: [
                SizedBox(height: context.padding.inner),
                Text(
                  'How about some of these?',
                  textAlign: TextAlign.center,
                  style: context.suggestionStyle,
                ),
                SizedBox(height: context.padding.inner),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    for (final item
                        in suggestionEngine.suggestionsNotInList.take(6))
                      SuggestionChip(
                        item: item,
                        onPressed: () {
                          list.items.add(item);
                          suggestionEngine.add(item);
                        },
                        onLongPressed: () {
                          // TODO: Show context dialog.
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: context.color.canvas,
                              title: Text(
                                'Remove suggestion?',
                                style: context.accentStyle,
                              ),
                              content: Text(
                                'This will cause "$item" to no longer appear in suggestion chips or Smart Compose.',
                                style: context.standardStyle,
                              ),
                              actions: <Widget>[
                                MyTextButton(
                                  text: 'No',
                                  onPressed: () => context.navigator.pop(),
                                ),
                                MyTextButton(
                                  text: 'Yes',
                                  onPressed: () {
                                    suggestionEngine.remove(item);
                                    context.navigator.pop();
                                  },
                                ),
                              ],
                            ),
                          );
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
