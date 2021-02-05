import 'package:chest_flutter/chest_flutter.dart';
import 'package:meta/meta.dart';

part 'list.g.dart';

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
}

extension ListHelpers on Reference<ShoppingList> {
  bool get areAllItemsInMainList => inTheCart.isEmpty && notAvailable.isEmpty;
}