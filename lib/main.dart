import 'dart:async';

import 'package:basics/basics.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:chest_flutter/chest_flutter.dart' hide TaperForThemeMode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:reorderables/reorderables.dart';

import 'app_bar.dart';
import 'completed_section.dart';
import 'core/core.dart' hide ThemeMode;
import 'i18n.dart';
import 'item_sheet.dart';
import 'suggestions.dart';
import 'theme.dart';
import 'todo_item.dart';
import 'utils.dart';

void main() async {
  runApp(Container(color: Colors.teal));
  await initializeChest();
  registerTapers();
  await Future.wait([
    history.open(),
    list.open(),
    onboarding.open(),
    settings.open(),
    suggestionEngine.initialize(),
  ]);
  runApp(ShoppingListApp());
}

@visibleForTesting
void registerTapers() {
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
}

class ShoppingListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReferenceBuilder(
      reference: settings.theme,
      builder: (_) => AppTheme(
        data: AppThemeData.fromThemeMode(settings.theme.value),
        child: Builder(
          builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MiniList',
            theme: context.appTheme.toDefaultMaterialTheme(),
            home: SplashScreen(),
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() {
      context.navigator.pushReplacement(MaterialPageRoute(
        builder: (_) => MainPage(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: 'fab',
        child: Material(color: Colors.teal),
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
        label: Text(
          context.t.mainAddItem,
          style: context.accentStyle.copyWith(color: context.color.onPrimary),
        ),
        onPressed: context.showCreateItemSheet,
        heroTag: 'fab',
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
        context.t.mainEmptyStateTitle,
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
    context.offerUndo(context.t.mainSnackbarPutItemInCart(item), () {
      list.inTheCart.mutate((it) => it.removeLast());
      list.items.mutate((it) => it.insert(index, item));
    });
  }

  void _markAsNotAvailable(BuildContext context, String item) {
    final index = list.items.value.indexOf(item);
    list.items.mutate((it) => it.removeAt(index));
    list.notAvailable.add(item);
    context.offerUndo(
      context.t.mainSnackbarMarkedItemAsNotAvailable(item),
      () {
        list.notAvailable.mutate((it) => it.removeLast());
        list.items.mutate((it) => it.insert(index, item));
      },
    );
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
            child: SizedBox.fromSize(size: constraints.biggest, child: child),
          );
        },
        delegate: ReorderableSliverChildBuilderDelegate(
          (_, index) {
            final item = list.items[index].value;
            return Dismissible(
              key: Key(item),
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  _putInCart(context, item);
                } else {
                  _markAsNotAvailable(context, item);
                }
              },
              background: Container(
                color: context.color.inTheCart,
                padding:
                    EdgeInsets.symmetric(horizontal: context.padding.outer),
                child: Row(
                  children: [
                    Icon(Icons.check, color: context.color.onInTheCart),
                    SizedBox(width: context.padding.inner),
                    Text(
                      'Got it',
                      style: context.standardStyle.copyWith(
                        color: context.color.onInTheCart,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              secondaryBackground: Container(
                color: context.color.notAvailable,
                padding:
                    EdgeInsets.symmetric(horizontal: context.padding.outer),
                child: Row(
                  children: [
                    Spacer(),
                    Text(
                      'Not available',
                      style: context.standardStyle.copyWith(
                        color: context.color.onNotAvailable,
                      ),
                    ),
                    SizedBox(width: context.padding.inner),
                    Icon(Icons.not_interested,
                        color: context.color.onNotAvailable),
                  ],
                ),
              ),
              child: TodoItem(
                item: item,
                onTap: () => context.showEditItemSheet(item),
                showSwipeIndicator:
                    onboarding.swipeToPutInCart.showExplanation && index == 0,
              ),
            );
          },
          childCount: list.items.length,
        ),
      ),
    );
  }
}
