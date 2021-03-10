import 'package:chest_flutter/chest_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenshots/screenshots.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/main.dart';

void main() {
  WidgetsApp.debugAllowBannerOverride = false;

  testWidgets('Minimalistic', (WidgetTester tester) async {
    registerTapers();
    history.mock();
    list.mock();
    onboarding.mock();
    settings.mock();
    suggestionEngine.state.mock();
    suggestionEngine.initialize();
    await tester.pumpWidget(ShoppingListApp());
    await tester.pump(Duration(seconds: 1));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(ShoppingListApp),
      matchesGoldenFile('main.png'),
    );
    final config = Config();
    await screenshot(tester, config, 'screenshot');
  });
}
