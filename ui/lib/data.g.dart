// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// TapeGenerator
// **************************************************************************

extension TaperForShoppingListExtension on TaperNamespace {
  _VersionedTapersForShoppingList forShoppingList() =>
      _VersionedTapersForShoppingList();
}

class _VersionedTapersForShoppingList {
  Taper<ShoppingList> get v0 => _TaperForV0ShoppingList();
}

class _TaperForV0ShoppingList extends MapTaper<ShoppingList> {
  @override
  Map<Object?, Object?> toMap(ShoppingList shoppinglist) {
    return {
      'items': shoppinglist.items,
      'inTheCart': shoppinglist.inTheCart,
      'notAvailable': shoppinglist.notAvailable,
    };
  }

  @override
  ShoppingList fromMap(Map<Object?, Object?> map) {
    return ShoppingList(
      items: map['items'] as List<String>,
      inTheCart: map['inTheCart'] as List<String>,
      notAvailable: map['notAvailable'] as List<String>,
    );
  }
}

extension ReferenceToShoppingList on Reference<ShoppingList> {
  Reference<List<String>> get items => child('items');
  Reference<List<String>> get inTheCart => child('inTheCart');
  Reference<List<String>> get notAvailable => child('notAvailable');
}
