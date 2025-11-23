import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vochm_flutter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add finding for animal via map selection', (tester) async {
    print("Starting test add_finding");
    app.main();
    await tester.pumpAndSettle();

    // Add an animal first
    final addButton = find.byKey(const Key('addAnimalButton'));
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    const animalName = 'Varg';
    await tester.enterText(find.byKey(const Key('animalNameField')), animalName);
    await tester.tap(find.byKey(const Key('submitAnimalButton')));
    await tester.pumpAndSettle();

    // Tap on the map to trigger finding registration
    final mapFinder = find.byType(FlutterMap);
    expect(mapFinder, findsOneWidget);
    await tester.tap(mapFinder);
    await tester.pumpAndSettle();
  });
}

