import "package:boda_ma/features/auth/presentation/widgets/admin_login_header.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets(
      "AdminLoginHeader renders without overflow in constrained height",
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 150,
            width: 320,
            child: AdminLoginHeader(),
          ),
        ),
      ),
    );

    expect(find.byType(AdminLoginHeader), findsOneWidget);
    expect(find.text("Administración"), findsOneWidget);
    expect(find.text("Panel de Invitaciones"), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      "AdminLoginHeader renders without overflow in default expanded height",
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 250,
            width: 400,
            child: AdminLoginHeader(),
          ),
        ),
      ),
    );

    expect(find.byType(AdminLoginHeader), findsOneWidget);
    expect(find.text("Administración"), findsOneWidget);
    expect(find.text("Panel de Invitaciones"), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
