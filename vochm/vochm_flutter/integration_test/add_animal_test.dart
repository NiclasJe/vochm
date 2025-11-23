import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vochm_flutter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add animal and verify it appears in list', (tester) async {
    print("Starting test add_animal");
    app.main();
    await tester.pumpAndSettle();

    // Open add animal dialog
    final addButton = find.byKey(const Key('addAnimalButton'));
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Enter animal name
    const animalName = 'Lodjur';
    await tester.enterText(find.byKey(const Key('animalNameField')), animalName);
    await tester.tap(find.byKey(const Key('submitAnimalButton')));
    await tester.pumpAndSettle();

    // Switch to Animals tab
    await tester.tap(find.text('Animals'));
    await tester.pumpAndSettle();

    // Verify animal is in list
    expect(find.text(animalName), findsOneWidget);
  });
}

