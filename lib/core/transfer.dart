import 'dart:convert';

import 'list.dart';

class ExportSettings {
  ExportSettings({
    required this.type,
    required this.items,
  });

  final DataType type;
  final Set<String> items;

  ExportSettings withType(DataType type) {
    return ExportSettings(items: items, type: type);
  }
}

enum DataType { txt, json }

String exportData(ExportSettings settings) {
  final items = settings.items.toList()..sort();

  if (settings.type == DataType.txt) {
    return items.join('\n');
  }

  final jsonData = json.encode({
    'mainList': items,
  });

  if (settings.type == DataType.json) {
    return jsonData;
  }

  throw 'Unhandled type ${settings.type}.';
}

ImportBundle prepareImport(DataType type, String source) {
  if (type == DataType.txt) {
    return ImportBundle(
      items: source
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toSet(),
    );
  }

  assert(type == DataType.json);

  final data = json.decode(source) as Map<String, dynamic>;
  return ImportBundle(
    items: StringList.fromJson(data['mainList'] ?? []).toSet(),
  );
}

class ImportBundle {
  ImportBundle({required this.items});

  final Set<String> items;

  ImportBundle clone() {
    return ImportBundle(
      items: Set.from(items),
    );
  }
}

extension StringList on List<String> {
  dynamic toJson() => this;
  static List<String> fromJson(dynamic source) =>
      (source as List<dynamic>).cast<String>();
}

extension ActuallyImport on ImportBundle {
  void import() {
    list.items.mutate((mainList) => mainList.addAll(items));
  }
}
