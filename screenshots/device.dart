import 'package:flutter/material.dart';

import 'utils.dart';

class Device extends StatelessWidget {
  const Device({
    this.color = Colors.black,
    this.brightness = Brightness.light,
    required this.screen,
  });

  final Color color;
  final Brightness brightness;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      shape: DeviceShape(),
      color: color,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox.fromSize(
            size: smartphoneSize,
            child: _buildScreenContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildScreenContent() {
    return Stack(
      children: [
        Positioned.fill(
          child: MediaQuery(
            data: MediaQueryData(
              size: smartphoneSize,
              viewPadding: EdgeInsets.only(top: StatusBar.height),
              padding: EdgeInsets.only(top: StatusBar.height),
            ),
            child: screen,
          ),
        ),
        StatusBar(brightness: brightness),
      ],
    );
  }
}

class DeviceShape extends ShapeBorder {
  Path get path {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(
            0, 0, smartphoneSize.width + 32, smartphoneSize.height + 32),
        Radius.circular(32),
      ))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(smartphoneSize.width + 16, 100, 16 + 4, 40),
        Radius.circular(4),
      ))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(smartphoneSize.width + 16, 200, 16 + 4, 120),
        Radius.circular(4),
      ));
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;
  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => path;
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => path;
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
  @override
  ShapeBorder scale(double t) => throw "Don't scale DeviceShape.";
}

class StatusBar extends StatelessWidget {
  static const height = 32.0;

  const StatusBar({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: brightness == Brightness.light ? Colors.black12 : Colors.white10,
      height: height,
      child: Row(
        children: [
          Spacer(),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            child: SizedBox.fromSize(size: Size.square(16)),
          ),
          SizedBox(width: 8),
          Material(
            color: Colors.white,
            child: SizedBox.fromSize(size: Size.square(16)),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
