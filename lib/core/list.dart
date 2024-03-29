import 'package:chest_flutter/chest_flutter.dart';
import 'package:meta/meta.dart';

import 'history.dart';
import 'settings.dart';
import 'transfer.dart';
import 'utils.dart';

part 'list.g.dart';

/// The actual list displayed in the app.
final list = Chest<ShoppingList>('list', ifNew: () => ShoppingList.empty());

@sealed
@tape({
  v0: {#items, #inTheCart, #notAvailable},
})
class ShoppingList {
  ShoppingList({
    required this.items,
    required this.inTheCart,
    required this.notAvailable,
  });
  ShoppingList.empty() : this(items: [], inTheCart: [], notAvailable: []);

  final List<String> items;
  final List<String> inTheCart;
  final List<String> notAvailable;

  String toDebugString() {
    return [
      'ShoppingList(',
      'items: ${items.toDebugString()},'.indent(),
      'inTheCart: ${inTheCart.toDebugString()},'.indent(),
      'notAvailable: ${notAvailable.toDebugString()},'.indent(),
      ')',
    ].joinLines();
  }
}

extension ListHelpers on Reference<ShoppingList> {
  bool get areAllItemsInMainList => inTheCart.isEmpty && notAvailable.isEmpty;
  void add(String item) {
    items.mutate((items) {
      final whereToInsert = settings.useSmartInsertion.value
          ? history.whereToInsert(item)
          : settings.defaultInsertion.value == Insertion.atTheBeginning
              ? 0
              : list.items.length;
      items.insert(whereToInsert, item);
    });
  }
}

extension TransferableList on Reference<List<String>> {
  dynamic export() => value.toJson();
  void import(List<String> data) => value = data;
}
