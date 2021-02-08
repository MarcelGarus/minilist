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
import 'suggestions.dart';
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
    10: taper.forSettings().v1,
    5: taper.forThemeMode().v0,
    6: taper.forOnboardingState().v0,
    7: taper.forOnboardingCountdown().v0,
    8: taper.forHistoryItem().v0,
    9: taper.forList<HistoryItem>(),
    11: taper.forInsertion().v0,
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
      reference: settings.theme,
      builder: (_) => AppTheme(
        data: AppThemeData.fromThemeMode(settings.theme.value),
        child: Builder(
          builder: (context) {
            // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            //   statusBarColor: Colors.grey,
            //   // statusBarIconBrightness: Brightness.light,
            //   // statusBarBrightness: Brightness.light,
            // ));
            print('Set system UI overlay style.');
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
    return CustomScrollView(
      slivers: [
        ListAppBar(),
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
          SliverToBoxAdapter(child: _EmptyState())
        else
          _SliverMainList(),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.padding.outer) +
                EdgeInsets.only(top: context.padding.inner),
            child: Suggestions(),
          ),
        ),
        // This makes sure that nothing is hidden behin the FAB.
        SliverToBoxAdapter(child: Container(height: 100)),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'A fresh start',
        textAlign: TextAlign.center,
        style: context.accentStyle,
      ),
    );
  }
}

class _SliverMainList extends StatelessWidget {
  void _onReorder(int oldIndex, int newIndex) {
    list.items.mutate((items) {
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  }

  void _putInCart(BuildContext context, String item) {
    final index = list.items.value.indexOf(item);
    list.items.mutate((it) => it.removeAt(index));
    list.inTheCart.add(item);
    onboarding.swipeToPutInCart.used();
    history.checkedItem(item);
    context.showSnackBarWithUndo('Put $item in the cart.', () {
      list.inTheCart.mutate((it) => it.removeLast());
      list.items.mutate((it) => it.insert(index, item));
    });
  }

  void _markAsNotAvailable(BuildContext context, String item) {
    final index = list.items.value.indexOf(item);
    list.items.mutate((it) => it.removeAt(index));
    list.notAvailable.add(item);
    context.showSnackBarWithUndo('Marked $item as not available.', () {
      list.notAvailable.mutate((it) => it.removeLast());
      list.items.mutate((it) => it.insert(index, item));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReferenceBuilder(
      reference: list.items,
      builder: (context) => ReorderableSliverList(
        onReorder: _onReorder,
        buildDraggableFeedback: (context, constraints, child) {
          return Material(
            elevation: 2,
            color: context.color.canvas,
            child: SizedBox.fromSize(size: constraints.biggest, child: child),
          );
        },
        delegate: ReorderableSliverChildBuilderDelegate(
          (_, index) {
            final item = list.items[index].value;
            return TodoItem(
              item: item,
              onTap: () => context.showEditItemSheet(item),
              onPrimarySwipe: () => _putInCart(context, item),
              onSecondarySwipe: () => _markAsNotAvailable(context, item),
              showSwipeIndicator:
                  onboarding.swipeToPutInCart.showExplanation && index == 0,
            );
          },
          childCount: list.items.length,
        ),
      ),
    );
  }
}
