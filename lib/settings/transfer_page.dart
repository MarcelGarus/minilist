import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

import '../i18n.dart';
import '../theme.dart';
import 'export_page.dart';
import 'import_page.dart';
import 'utils.dart';

class TransferPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.background,
      appBar: SettingsAppBar(title: context.t.transferTitle),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              // TODO: Switch to more beautiful "file_download_outlined"
              // (and do the same for the upload).
              icon: Icon(Icons.download_outlined, size: 16),
              label: Padding(
                padding: EdgeInsets.all(8),
                child: Text(context.t.transferExport),
              ),
              onPressed: () => context.navigator.push(MaterialPageRoute(
                builder: (_) => ExportPage(),
              )),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.upload_outlined, size: 16),
              label: Padding(
                padding: EdgeInsets.all(8),
                child: Text(context.t.transferImport),
              ),
              onPressed: () => context.navigator.push(MaterialPageRoute(
                builder: (_) => ImportPage(),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
