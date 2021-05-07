import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

T? tryOrNull<T>(T Function() callback) {
  try {
    return callback();
  } catch (e) {
    return null;
  }
}

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({
    required this.title,
    this.actions = const [],
    this.elevation,
  });

  final String title;
  final List<Widget> actions;
  final double? elevation;

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backwardsCompatibility: false,
      title: Text(title, style: context.accentStyle.copyWith(fontSize: 20)),
      actions: actions,
      elevation: elevation,
    );
  }
}

class SettingsToggleListTile extends StatelessWidget {
  const SettingsToggleListTile({
    required this.reference,
    required this.title,
    this.subtitle,
  });

  final Reference<bool> reference;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: context.accentStyle),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: context.secondaryStyle),
      onTap: reference.toggle,
      trailing: ReferenceSwitch(reference),
    );
  }
}

class ReferenceSwitch extends StatelessWidget {
  const ReferenceSwitch(this.reference);

  final Reference<bool> reference;

  @override
  Widget build(BuildContext context) {
    return ReferenceBuilder(
      reference: reference,
      builder: (_) => Switch(
        value: reference.value,
        onChanged: (_) => reference.toggle(),
      ),
    );
  }
}

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.isEnabled = true,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool isEnabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1 : 0.5,
      child: ListTile(
        title: Text(title, style: context.accentStyle),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!, style: context.secondaryStyle),
        leading: leading,
        trailing: trailing,
        onTap: isEnabled ? onTap : null,
      ),
    );
  }
}
