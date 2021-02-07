// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// TapeGenerator
// **************************************************************************

extension TaperForHistoryItem on TaperNamespace {
  _VersionedTapersForHistoryItem forHistoryItem() =>
      _VersionedTapersForHistoryItem();
}

class _VersionedTapersForHistoryItem {
  Taper<HistoryItem> get v0 => _TaperForV0HistoryItem();
}

class _TaperForV0HistoryItem extends MapTaper<HistoryItem> {
  @override
  Map<Object?, Object?> toMap(HistoryItem historyitem) {
    return {
      'item': historyitem.item,
      'otherItems': historyitem.otherItems,
    };
  }

  @override
  HistoryItem fromMap(Map<Object?, Object?> map) {
    return HistoryItem(
      map['item'] as String,
      map['otherItems'] as List<String>,
    );
  }
}

extension ReferenceToHistoryItem on Reference<HistoryItem> {
  Reference<String> get item => child('item');
  Reference<List<String>> get otherItems => child('otherItems');
}
