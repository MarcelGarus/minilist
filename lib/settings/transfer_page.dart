import 'dart:async';
import 'dart:io';

import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minilist/core/transfer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import '../core/core.dart';
import '../i18n.dart';
import '../theme.dart';
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
              // TODO: Switch to more beautiful file_download_outlined
              // (and do the same for the upload).
              icon: Icon(Icons.download_outlined, size: 16),
              label: Padding(
                padding: EdgeInsets.all(8),
                child: Text('Exportieren'),
              ),
              onPressed: () => context.navigator.push(MaterialPageRoute(
                builder: (_) => _ExportPage(),
              )),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.upload_outlined, size: 16),
              label: Padding(
                padding: EdgeInsets.all(8),
                child: Text('Importieren'),
              ),
              onPressed: () => context.navigator.push(MaterialPageRoute(
                builder: (_) => _ImportPage(),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExportPage extends StatefulWidget {
  @override
  __ExportPageState createState() => __ExportPageState();
}

class __ExportPageState extends State<_ExportPage> {
  bool _mainList = true;
  bool _inTheCartList = false;
  bool _notAvailableList = false;
  bool _suggestions = false;

  @override
  Widget build(BuildContext context) {
    final settings = ExportSettings(
      mainList: _mainList,
      inTheCartList: _inTheCartList,
      notAvailableList: _notAvailableList,
      suggestions: _suggestions,
      type: DataType.qr,
    );
    final qrContent = exportData(settings);
    final txtContent =
        tryOrNull(() => exportData(settings.withType(DataType.txt)));
    final jsonContent = exportData(settings.withType(DataType.json));
    return Scaffold(
      backgroundColor: context.color.background,
      appBar: SettingsAppBar(title: 'Daten exportieren'),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Was soll exportiert werden?',
              style: context.accentStyle,
            ),
          ),
          CheckboxListTile(
            value: _mainList,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('Haupt-Liste'),
            onChanged: (newValue) => setState(() => _mainList = newValue!),
          ),
          CheckboxListTile(
            value: _inTheCartList,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('"Im Wagen"-Liste'),
            onChanged: (newValue) => setState(() => _inTheCartList = newValue!),
          ),
          CheckboxListTile(
            value: _notAvailableList,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('"Nicht da"-Liste'),
            onChanged: (newValue) =>
                setState(() => _notAvailableList = newValue!),
          ),
          CheckboxListTile(
            value: _suggestions,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('Vorschläge'),
            onChanged: (newValue) => setState(() => _suggestions = newValue!),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Wie sollen die Daten exportiert werden?',
              style: context.accentStyle,
            ),
          ),
          SettingsListTile(
            title: 'Per QR-Code',
            subtitle:
                'Eignet sich, um die Daten direkt auf ein anderes Gerät zu übertragen',
            leading: Icon(Icons.qr_code),
            isEnabled: settings.anySelected && qrContent.length <= 4296,
            onTap: () => context.navigator.push(MaterialPageRoute(
              builder: (_) => _QrPage(qrContent),
            )),
          ),
          SettingsListTile(
            title: 'Über die Zwischenablage',
            subtitle: settings.selectedLists > 1
                ? 'Funktioniert nur für eine Liste'
                : settings.anySelected && settings.selectedLists == 0
                    ? 'Funktioniert nur für Listen'
                    : 'Kopiert einen Eintrag pro Zeile',
            leading: Icon(Icons.copy_outlined),
            isEnabled: settings.anySelected && settings.selectedLists == 1,
            onTap: () =>
                txtContent == null ? null : _shareFile(txtContent, 'txt'),
          ),
          SettingsListTile(
            title: 'Als TXT-Datei',
            subtitle: settings.selectedLists > 1
                ? 'Funktioniert nur für eine Liste'
                : settings.anySelected && settings.selectedLists == 0
                    ? 'Funktioniert nur für Listen'
                    : 'Einfaches Format mit einem Eintrag pro Zeile – ${txtContent?.split('\n').length} Zeilen – ${txtContent?.length} B',
            leading: Icon(Icons.description_outlined),
            isEnabled: settings.anySelected && settings.selectedLists == 1,
            onTap: () =>
                txtContent == null ? null : _shareFile(txtContent, 'txt'),
          ),
          SettingsListTile(
            title: 'Als JSON-Datei',
            subtitle:
                'Komplexeres maschinenlesbares Format – ${jsonContent.length} B',
            leading: Icon(Icons.code_outlined),
            isEnabled: settings.anySelected,
            onTap: () => _shareFile(jsonContent, 'json'),
          ),
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

class _QrPage extends StatelessWidget {
  const _QrPage(this.content);

  final String content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.background,
      appBar: SettingsAppBar(title: '', elevation: 0),
      body: Container(
        padding: EdgeInsets.all(0),
        alignment: Alignment.center,
        child: QrImage(
          data: content,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}

class _ImportPage extends StatefulWidget {
  @override
  __ImportPageState createState() => __ImportPageState();
}

class __ImportPageState extends State<_ImportPage> with WidgetsBindingObserver {
  var _cameras = <CameraDescription>[];
  CameraController? _camera;
  var _isDetecting = false;

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() async {
      _cameras = await availableCameras();
      _selectCamera(_cameras
          .firstWhere((it) => it.lensDirection == CameraLensDirection.back));
    });
    WidgetsBinding.instance!.addObserver(this);
  }

  void _selectCamera(CameraDescription camera) async {
    _camera = CameraController(camera, ResolutionPreset.medium);
    await _camera!.initialize();
    if (!mounted) return;
    setState(() => _camera!.startImageStream(_processImage));
  }

  void _processImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    final allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final firebaseImage = FirebaseVisionImage.fromBytes(
      allBytes.done().buffer.asUint8List(),
      FirebaseVisionImageMetadata(
        rawFormat: image.format.raw,
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: ImageRotation.rotation0,
        planeData: image.planes.map((Plane plane) {
          return FirebaseVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        }).toList(),
      ),
    );
    final codes = await FirebaseVision.instance
        .barcodeDetector()
        .detectInImage(firebaseImage);
    codes.forEach(_onCodeDetected);
    _isDetecting = false;
  }

  void _onCodeDetected(Barcode code) {
    print('Detected code $code');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_camera == null || !_camera!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _camera?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_camera != null) {
        _selectCamera(_camera!.description);
      }
    }
  }

  @override
  void dispose() {
    _camera?.dispose();
    FirebaseVision.instance.barcodeDetector().close();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final camera = _camera;
    if (camera == null) return Container();
    if (!camera.value.isInitialized) return Container();
    return AspectRatio(
      aspectRatio: camera.value.aspectRatio,
      child: CameraPreview(camera),
    );
  }
}

class QrCodeBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: EdgeInsets.all(32),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.8), width: 5),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
