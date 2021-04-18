import 'package:flutter/material.dart';

import 'utils.dart';

class Device extends StatelessWidget {
  const Device({this.color = Colors.black, required this.screen});

  final Color color;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16,
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
              padding: EdgeInsets.only(top: 16),
            ),
            child: screen,
          ),
        ),
        StatusBar(),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      height: 32,
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
