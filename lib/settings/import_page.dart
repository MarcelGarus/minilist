import 'dart:convert';

import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minilist/core/transfer.dart';

import '../core/core.dart';
import '../i18n.dart';
import '../theme.dart';
import 'utils.dart';

class ImportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.background,
      appBar: SettingsAppBar(title: 'Daten importieren'),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Wie sollen die Daten importiert werden?',
              style: context.accentStyle,
            ),
          ),
          SettingsListTile(
            title: 'Über die Zwischenablage',
            leading: Icon(Icons.paste_outlined),
            onTap: () async {
              final data = await Clipboard.getData('text/plain');
              if (data == null) return;
              final text = data.text;
              if (text == null) return;
              _proceed(context, prepareImport(DataType.txt, text));
            },
          ),
          SettingsListTile(
            title: 'Von einer JSON-Datei',
            leading: Icon(Icons.code_outlined),
            onTap: () async {
              final result = await FilePicker.platform.pickFiles();
              if (result == null) return;
              final files = result.files;
              if (files.length != 1) return;
              final bytes = files.single.bytes;
              if (bytes == null) return;
              final string = utf8.decode(bytes);
              _proceed(context, prepareImport(DataType.json, string));
            },
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

void _proceed(BuildContext context, ImportBundle importBundle) {
  context.navigator.push(MaterialPageRoute(
    builder: (_) => _ImportChooser(importBundle),
  ));
}

class _ImportChooser extends StatefulWidget {
  _ImportChooser(this._bundle, {Key? key}) : super(key: key);

  final ImportBundle _bundle;

  @override
  __ImportChooserState createState() => __ImportChooserState();
}

class __ImportChooserState extends State<_ImportChooser> {
  ImportBundle get _bundle => widget._bundle;
  late ImportBundle _selectedBundle;

  @override
  void initState() {
    super.initState();
    _selectedBundle = _bundle.clone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.background,
      appBar: SettingsAppBar(title: 'Daten importieren'),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Import'),
        onPressed: () {
          _selectedBundle.import();
          // TODO: Make this more elegant.
          context.navigator..pop()..pop()..pop()..pop();
          context.scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Imported items'),
            behavior: SnackBarBehavior.floating,
          ));
        },
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Was soll importiert werden?',
              style: context.accentStyle,
            ),
          ),
          for (final item in _bundle.items)
            () {
              if (list.items.value.contains(item)) {
                return CheckboxListTile(
                  value: false,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(item),
                  subtitle: Text('Ist bereits auf deiner Liste'),
                  onChanged: null,
                );
              } else {
                return CheckboxListTile(
                  value: _selectedBundle.items.contains(item),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(item),
                  onChanged: (newValue) => setState(() {
                    if (newValue!) {
                      _selectedBundle.items.add(item);
                    } else {
                      _selectedBundle.items.remove(item);
                    }
                  }),
                );
              }
            }(),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
