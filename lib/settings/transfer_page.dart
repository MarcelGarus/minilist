import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/material.dart';

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
      body: ListView(
        children: [
          SettingsListTile(
            title: 'Per QR-Code',
            subtitle:
                'Eignet sich, um die Daten auf ein anderes Gerät zu übertragen',
          ),
        ],
      ),
    );
  }
}
