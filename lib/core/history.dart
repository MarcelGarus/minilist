import 'dart:math';

import 'package:basics/basics.dart';
import 'package:chest_flutter/chest_flutter.dart';

import 'list.dart';

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
}

extension HistoryFunctionality on Reference<List<HistoryItem>> {
  List<String> get _otherItems => list.items.value;

  void checkedItem(String item) {
    history.add(HistoryItem(item, _otherItems));
  }

  int whereToInsert(String item) {
    final other = _otherItems;
    return 0.to(other.length + 1).minBy((index) {
      final itemsAfter = other.sublist(index).toSet();
      print(
          'Index $index has score ${_errorScoreIfInsertedBefore(item, itemsAfter)}.');
      return _errorScoreIfInsertedBefore(item, itemsAfter);
    }).or(0);
  }

  double _errorScoreIfInsertedBefore(String item, Set<String> other) {
    var score = 0.0;
    for (var i = 0; i < history.length; i++) {
      final historyItem = history[i].value;
      if (other.contains(historyItem.item) &&
          historyItem.otherItems.contains(item)) {
        // The history item was preferred the other way around.
        score += pow(0.95, i);
      }
    }
    return score;
  }
}
