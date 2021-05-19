import 'dart:io';

import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minilist/core/transfer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

import '../core/core.dart';
import '../i18n.dart';
import '../theme.dart';
import 'utils.dart';

class ExportPage extends StatefulWidget {
  @override
  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  late ExportSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = ExportSettings(
      type: DataType.txt,
      items: list.items.value.toSet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final txtContent =
        tryOrNull(() => exportData(_settings.withType(DataType.txt)));
    final jsonContent = exportData(_settings.withType(DataType.json));

    return Scaffold(
      backgroundColor: context.color.background,
      appBar: SettingsAppBar(title: context.t.transferExportTitle),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              context.t.transferExportHow,
              style: context.accentStyle,
            ),
          ),
          // TODO: Display number of lines and number of characters
          SettingsListTile(
            title: context.t.transferExportClipboard,
            subtitle: context.t.transferExportClipboardDetails,
            leading: Icon(Icons.paste_outlined),
            onTap: () {
              if (txtContent == null) return;
              Clipboard.setData(ClipboardData(text: txtContent));
              context.scaffoldMessenger.showSnackBar(SnackBar(
                content: Text(context.t.transferExportClipboardConfirmation),
                behavior: SnackBarBehavior.floating,
              ));
              context.navigator..pop()..pop()..pop();
            },
          ),
          // TODO: Display file size
          SettingsListTile(
            title: context.t.transferExportJson,
            subtitle: context.t.transferExportJsonDetails,
            leading: Icon(Icons.code_outlined),
            onTap: () {
              _shareFile(jsonContent, 'json');
              context.navigator..pop()..pop()..pop();
            },
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

void _shareFile(String content, String fileExtension) async {
  final directory =
      Platform.isAndroid ? (await getExternalStorageDirectory())!.path : '.';
  final file = File('$directory/minilist.$fileExtension');
  await file.writeAsString(content);
  if (!Platform.isWindows) {
    Share.shareFiles(
      [file.path],
      subject: 'Share List',
      text: 'This is the shopping list.',
      mimeTypes: ['txt/$fileExtension'],
    );
  }
}

// class _QrPage extends StatelessWidget {
//   const _QrPage(this.content);

//   final String content;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: context.color.background,
//       appBar: SettingsAppBar(title: '', elevation: 0),
//       body: Container(
//         padding: EdgeInsets.all(16),
//         alignment: Alignment.center,
//         child: QrImage(
//           data: content,
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//         ),
//       ),
//     );
//   }
// }
