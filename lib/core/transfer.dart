import 'dart:convert';
import 'dart:io';

import 'list.dart';
import 'suggestion_engine.dart';

class ExportSettings {
  ExportSettings({
    required this.mainList,
    required this.inTheCartList,
    required this.notAvailableList,
    required this.suggestions,
    required this.type,
  });

  final bool mainList;
  final bool inTheCartList;
  final bool notAvailableList;
  final bool suggestions;
  final DataType type;

  bool get anySelected =>
      mainList || inTheCartList || notAvailableList || suggestions;
  int get selectedLists =>
      (mainList ? 1 : 0) + (inTheCartList ? 1 : 0) + (notAvailableList ? 1 : 0);

  ExportSettings withType(DataType type) {
    return ExportSettings(
      mainList: mainList,
      inTheCartList: inTheCartList,
      notAvailableList: notAvailableList,
      suggestions: suggestions,
      type: type,
    );
  }
}

enum DataType { qr, txt, json }

String exportData(ExportSettings settings) {
  if (settings.type == DataType.txt) {
    if (settings.mainList) return list.items.value.join('\n');
    if (settings.inTheCartList) return list.inTheCart.value.join('\n');
    if (settings.notAvailableList) return list.notAvailable.value.join('\n');
    throw 'Cannot export suggestions using txt.';
  }

  final jsonData = {
    if (settings.mainList) 'mainList': list.items.export(),
    if (settings.inTheCartList) 'inTheCartList': list.inTheCart.export(),
    if (settings.notAvailableList)
      'notAvailableList': list.notAvailable.export(),
    if (settings.suggestions) 'suggestions': suggestionEngine.export(),
  };
  final string = json.encode(jsonData);

  if (settings.type == DataType.json) {
    return string;
  }

  assert(settings.type == DataType.qr);
  return base64.encode(zlib.encode(utf8.encode(string)));
}

ImportBundle prepareImport(DataType type, String source) {
  if (type == DataType.txt) {
    return ImportBundle(mainList: source.split('\n'));
  }

  if (type == DataType.qr) {
    source = utf8.decode(zlib.decode(base64.decode(source)));
  }

  assert(type == DataType.json);

  final data = json.decode(source) as Map<String, dynamic>;
  return ImportBundle(
    mainList: StringList.fromJson(data['mainList']),
    inTheCartList: StringList.fromJson(data['inTheCartList']),
    notAvailableList: StringList.fromJson(data['notAvailableList']),
    suggestions: RememberState.fromJson(data['suggestions']),
  );
}

class ImportBundle {
  ImportBundle({
    this.mainList,
    this.inTheCartList,
    this.notAvailableList,
    this.suggestions,
  });

  final List<String>? mainList;
  final List<String>? inTheCartList;
  final List<String>? notAvailableList;
  final RememberState? suggestions;
}

extension StringList on List<String> {
  dynamic toJson() => this;
  static List<String> fromJson(dynamic source) =>
      (source as List<dynamic>).cast<String>();
}

class ImportSettings {
  ImportSettings({
    required this.mainList,
    required this.inTheCartList,
    required this.notAvailableList,
    required this.suggestions,
  });

  final bool mainList;
  final bool inTheCartList;
  final bool notAvailableList;
  final bool suggestions;
}

extension ActuallyImport on ImportBundle {
  void import(ImportSettings settings) {
    if (mainList != null) list.items.import(mainList!);
    if (inTheCartList != null) list.inTheCart.import(inTheCartList!);
    if (notAvailableList != null) list.notAvailable.import(notAvailableList!);
    if (suggestions != null) suggestionEngine.import(suggestions!);
  }
}
