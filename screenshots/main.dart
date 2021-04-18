import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:minilist/core/core.dart';
import 'package:minilist/main.dart';

import 'showcases.dart';
import 'utils.dart';

void main() async {
  await initializeChest();
  registerTapers();
  history.mock([]);
  list.mock(ShoppingList(
    items: ['Toast', 'Tomatoes', 'Cheese', 'Cucumber'],
    inTheCart: [],
    notAvailable: [],
  ));
  onboarding.mock(OnboardingState(
    swipeToPutInCart: OnboardingCountdown(0),
    swipeToSmartCompose: OnboardingCountdown(0),
  ));
  settings.mock(Settings(
    theme: ThemeMode.light,
  ));
  suggestionEngine.state.mock(RememberState(
    lastDecay: DateTime.now(),
    scores: {
      'Bananas': 6,
      'Milk': 5,
      'Water': 4,
      'Potatoes': 3,
      'Bread': 2,
      'Walnuts': 1,
    },
  ));
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
  Widget showcase = showcases.first;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            for (var i = 0; i < showcases.length; i++)
              IconButton(
                icon: Text('$i'),
                onPressed: () => setState(() => showcase = showcases[i]),
              ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: FittedBox(
            child: ClipRect(
              clipBehavior: Clip.hardEdge,
              child: SizedBox.fromSize(size: smartphoneSize, child: showcase),
            ),
          ),
        ),
      ),
    );
  }
}
