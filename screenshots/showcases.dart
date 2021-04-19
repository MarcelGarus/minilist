import 'package:flutter/material.dart' hide ThemeMode;
import 'package:minilist/core/core.dart';
import 'package:minilist/main.dart';
import 'package:minilist/theme.dart';

import 'device.dart';
import 'utils.dart';

final showcases = <Showcase>[
  IntroShowcase(),
  SuggestionsShowcase(),
  SmartComposeShowcase(),
  DarkModeShowcase(),
  PrivacyShowcase(),
];

abstract class Showcase extends StatelessWidget {
  String get instructions => '';

  OnboardingState get onboarding {
    return OnboardingState(
      swipeToPutInCart: OnboardingCountdown(0),
      swipeToSmartCompose: OnboardingCountdown(1),
    );
  }

  ShoppingList get list {
    return ShoppingList(
      items: [
        'Toast',
        'Tomatoes',
        'Cheese',
        'Cucumber',
        'Chips',
        'Donuts',
        'Avocado',
        'Guacamole',
      ],
      inTheCart: [],
      notAvailable: [],
    );
  }

  List<HistoryItem> get history => [];

  RememberState get suggestionEngine {
    return RememberState(
      lastDecay: DateTime.now(),
      scores: {
        'Bananas': 6,
        'Milk': 5,
        'Water': 4,
        'Potatoes': 3,
        'Bread': 2,
        'Walnuts': 1,
      },
    );
  }

  Settings get settings => Settings(theme: ThemeMode.light);
}

class IntroShowcase extends Showcase {
  String get instructions => 'Drag the first item a little bit to the right';

  ShoppingList get list {
    return ShoppingList(
      items: [
        'Toast',
        'Tomatoes',
        'Cheese',
        'Cucumber',
      ],
      inTheCart: [],
      notAvailable: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Studio(
      color: Colors.white,
      foregroundColor: Colors.black,
      appTheme: AppThemeData.light(),
      children: [
        Text('A Thoughtful, Minimalistic Shopping List'),
        Transform.translate(
          offset: Offset(0, 250),
          child: FittedBox(child: Device(screen: MiniListApp())),
        ),
      ],
    );
  }
}

class SuggestionsShowcase extends Showcase {
  String get instructions => 'Scroll to the bottom.';

  @override
  Widget build(BuildContext context) {
    return Studio(
      color: Colors.teal,
      foregroundColor: Colors.white,
      appTheme: AppThemeData.dark(),
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Text('Get clever suggestions'),
        ),
        Transform.translate(
          offset: Offset(0, -100),
          child: FittedBox(
            child: Device(
              color: Colors.white,
              screen: MiniListApp(),
            ),
          ),
        ),
      ],
    );
  }
}

class SmartComposeShowcase extends Showcase {
  String get instructions =>
      'Scroll so that Toast is at the top, then click "Add item" and enter a '
      'B. Should complete to Banana.';

  @override
  Widget build(BuildContext context) {
    return Studio(
      color: Colors.white,
      foregroundColor: Colors.teal,
      appTheme: AppThemeData.dark(),
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Text('Type less with Autocomplete'),
        ),
        Transform.translate(
          offset: Offset(0, -100),
          child: FittedBox(
            child: Device(
              screen: Column(
                children: [
                  Expanded(child: MiniListApp()),
                  Image.network(
                    'https://www.androidpolice.com/wp-content/uploads/2020/09/18/gboard-new-design-hero.png',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DarkModeShowcase extends Showcase {
  ShoppingList get list {
    return ShoppingList(
      items: [
        'Toast',
        'Tomatoes',
        'Cheese',
        'Cucumber',
        'Chips',
        'Donuts',
        'Avocado',
        'Guacamole',
      ],
      inTheCart: ['A', 'B', 'C', 'D', 'E', 'F'],
      notAvailable: ['A', 'B'],
    );
  }

  Settings get settings => Settings(theme: ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    return Studio(
      color: Color(0xff121212),
      foregroundColor: Colors.white,
      appTheme: AppThemeData.dark(),
      children: [
        Text('Join the\ndark side.'),
        Transform.translate(
          offset: Offset(0, 200),
          child: FittedBox(
            child: Device(color: Colors.teal, screen: MiniListApp()),
          ),
        ),
      ],
    );
  }
}

class PrivacyShowcase extends Showcase {
  Settings get settings => Settings(theme: ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    return Studio(
      color: Color(0xff121212),
      foregroundColor: Colors.white,
      appTheme: AppThemeData.dark(),
      children: [
        Text(
          'No ads.\nNo tracking.\nOpen source.\nEverything stays on your device.',
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(child: Icon(Icons.lock, color: Colors.teal, size: 100)),
        ),
      ],
    );
  }
}
