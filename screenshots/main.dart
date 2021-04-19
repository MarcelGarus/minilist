import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:minilist/core/core.dart';
import 'package:minilist/main.dart';
import 'package:screenshot/screenshot.dart';

import 'showcases.dart';
import 'utils.dart';

void main() async {
  await initializeChest();
  registerTapers();
  final s = showcases.first;
  history.mock(s.history);
  list.mock(s.list);
  onboarding.mock(s.onboarding);
  settings.mock(s.settings);
  suggestionEngine.state.mock(s.suggestionEngine);
  await Future.wait([
    history.open(),
    list.open(),
    onboarding.open(),
    settings.open(),
    suggestionEngine.initialize(),
  ]);
  runApp(ScreenshotsApp());
}

class ScreenshotsApp extends StatefulWidget {
  @override
  _ScreenshotsAppState createState() => _ScreenshotsAppState();
}

class _ScreenshotsAppState extends State<ScreenshotsApp> {
  ScreenshotController screenshotController = ScreenshotController();
  Showcase showcase = showcases.first;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: IconButton(
            icon: Icon(Icons.save_alt_outlined),
            onPressed: () async {
              await screenshotController.captureAndSave(
                '.',
                fileName: 'screenshot${showcases.indexOf(showcase)}.jpg',
                delay: Duration(seconds: 2),
              );
              print('Screenshot saved.');
            },
          ),
          actions: [
            for (var i = 0; i < showcases.length; i++)
              IconButton(
                icon: Text('$i'),
                onPressed: () => setState(() {
                  showcase = showcases[i];
                  history.value = showcase.history;
                  list.value = showcase.list;
                  onboarding.value = showcase.onboarding;
                  settings.value = showcase.settings;
                  suggestionEngine.state.value = showcase.suggestionEngine;
                }),
              ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: FittedBox(
                  child: Container(
                    color: Colors.pink,
                    padding: EdgeInsets.all(8),
                    child: Screenshot(
                      controller: screenshotController,
                      child: SizedBox.fromSize(
                        size: smartphoneSize,
                        child: showcase,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                showcase.instructions,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
