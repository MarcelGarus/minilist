import 'package:chest_flutter/chest_flutter.dart';
import 'package:meta/meta.dart';

part 'data.g.dart';

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
