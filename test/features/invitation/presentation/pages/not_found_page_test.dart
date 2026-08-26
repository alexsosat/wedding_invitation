import "package:boda_ma/features/invitation/presentation/pages/not_found_page.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("NotFoundPage renders all gratitude elements without errors", (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: NotFoundPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(NotFoundPage), findsOneWidget);
    expect(find.text("Con todo nuestro cariño"), findsOneWidget);
    expect(find.text("¡Gracias por tus mejores deseos!"), findsOneWidget);
    expect(find.text("08.11.2026"), findsOneWidget);
  });
}
