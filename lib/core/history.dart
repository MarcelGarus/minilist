import 'dart:math';

import 'package:basics/basics.dart';
import 'package:chest_flutter/chest_flutter.dart';

import 'list.dart';
import 'settings.dart';
import 'utils.dart';

part 'history.g.dart';

final history = Chest<List<HistoryItem>>('history', ifNew: () => []);

/// Each time an item is checked, it's considered to be checked before all other
/// items in the list.
@tape({
  v0: {#item, #otherItems},
})
class HistoryItem {
  HistoryItem(this.item, this.otherItems);

  final String item;
  final List<String> otherItems;

  String toDebugString() {
    return [
      'HistoryItem(',
      '  item: ${item.toDebugString()},',
      '  otherItems: ${otherItems.toDebugString().indent()},',
      ')',
    ].joinLines();
  }
}

extension HistoryItemListX on List<HistoryItem> {
  String toDebugString() => map((it) => it.toDebugString()).toDebugString();
}

extension HistoryFunctionality on Reference<List<HistoryItem>> {
  List<String> get _otherItems => list.items.value;

  void checkedItem(String item) {
    history.add(HistoryItem(item, _otherItems));
  }

  int whereToInsert(String item) {
    final other = _otherItems;
    var index = 0.to(other.length + 1).minBy((index) {
      final itemsBefore = other.sublist(0, index).toSet();
      final itemsAfter = other.sublist(index).toSet();
      return _errorScoreIfInsertedBetween(item, itemsBefore, itemsAfter);
    });
    index ??= settings.defaultInsertion.value == Insertion.atTheBeginning
        ? 0
        : list.items.length;
    return index;
  }

  double _errorScoreIfInsertedBetween(
    String item,
    Set<String> before,
    Set<String> after,
  ) {
    var score = 0.0;
    for (var i = 0; i < history.length; i++) {
      // Events that date back longer are not as important.
      final importance = pow(0.95, i);
      final historyItem = history[i].value;
      if (after.contains(historyItem.item) &&
              historyItem.otherItems.contains(item) ||
          historyItem.item == item &&
              before.union(historyItem.otherItems.toSet()).isNotEmpty) {
        // The history item was preferred the other way around.
        score += importance;
      }
    }
    return score;
  }
}
