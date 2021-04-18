import 'package:flutter/material.dart';
import 'package:minilist/main.dart';
import 'package:minilist/theme.dart';

import 'device.dart';
import 'utils.dart';

final showcases = [
  Showcase0(),
  Showcase1(),
  Showcase2(),
];

class Showcase0 extends StatelessWidget {
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

class Showcase1 extends StatelessWidget {
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
            child: Device(color: Colors.white, screen: MiniListApp()),
          ),
        ),
      ],
    );
  }
}

class Showcase2 extends StatelessWidget {
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
          child: Text('Type less with Smart Compose'),
        ),
        Transform.translate(
          offset: Offset(0, -150),
          child: FittedBox(
            child: Device(color: Colors.white, screen: MiniListApp()),
          ),
        ),
      ],
    );
  }
}
