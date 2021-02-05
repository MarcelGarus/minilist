import 'dart:math';
import 'dart:ui' as ui;

import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

import 'theme.dart';

class ListAppBar extends StatelessWidget {
  const ListAppBar({
    required this.title,
    required this.subtitle,
    required this.actions,
  });

  final String title;
  final Widget subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final collapsedHeight = 56.0 + context.mediaQuery.padding.top;
    final expandedHeight = context.mediaQuery.size.height * 0.3967;
    return SliverAppBar(
      expandedHeight: expandedHeight,
      backgroundColor: context.appTheme.backgroundColor,
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final rawExpansion = (constraints.maxHeight - collapsedHeight) /
              (expandedHeight - collapsedHeight);
          final expansion = rawExpansion.clamp(0.0, 1.0);
          return Padding(
            padding: context.mediaQuery.padding,
            child: Stack(
              children: [
                _buildTitle(expansion),
                _buildSubtitle(expansion),
                _buildActions(expansion),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle(double expansion) {
    return Align(
      alignment: Alignment(
        Curves.easeInCubic.flipped
            .transform(expansion)
            .lerpDouble(collapsed: -1, expanded: 0),
        0,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: expansion.lerpDouble(collapsed: 16, expanded: 0),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0 + 20 * expansion),
        ),
      ),
    );
  }

  Widget _buildSubtitle(double expansion) {
    return Align(
      alignment: Alignment(0, 0.4),
      child: Opacity(
        opacity: (-3 + 4 * expansion).clamp(0.0, 1.0),
        child: subtitle,
      ),
    );
  }

  Widget _buildActions(double expansion) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        height: 56,
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...actions,
            SizedBox(width: expansion.lerpDouble(collapsed: 0, expanded: 16)),
          ],
        ),
      ),
    );
  }
}

extension _LerpFromExpansion on double {
  T _lerp<T>(T collapsed, T expanded, T Function(T, T, double) lerper) =>
      lerper(collapsed, expanded, this);

  double lerpDouble({
    required double collapsed,
    required double expanded,
  }) =>
      _lerp<double>(collapsed, expanded, (a, b, t) => ui.lerpDouble(a, b, t)!);
}