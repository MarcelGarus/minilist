import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({required this.title, this.actions = const []});

  final String title;
  final List<Widget> actions;

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backwardsCompatibility: false,
      title: Text(title, style: context.accentStyle.copyWith(fontSize: 20)),
      actions: actions,
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
    this.onTap,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: context.accentStyle),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: context.secondaryStyle),
      onTap: onTap,
      trailing: trailing,
    );
  }
}
