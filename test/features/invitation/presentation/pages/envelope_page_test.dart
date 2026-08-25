import "package:boda_ma/features/invitation/presentation/pages/envelope_page.dart";
import "package:boda_ma/features/invitation/presentation/widgets/envelope/envelope_card.dart";
import "package:boda_ma/features/invitation/presentation/widgets/envelope/envelope_cta_button.dart";
import "package:boda_ma/features/invitation/presentation/widgets/envelope/ribbon_recipient_text.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("EnvelopePage renders all elements and handles tap", (
    WidgetTester tester,
  ) async {
    bool wasOpened = false;

    await tester.pumpWidget(
      MaterialApp(
        home: EnvelopePage(
          recipientName: "Abigail Lazcano",
          onOpen: () {
            wasOpened = true;
          },
        ),
      ),
    );

    // Initial pump
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify EnvelopeCard and recipient
    expect(find.byType(EnvelopeCard), findsOneWidget);
    expect(find.byType(RibbonRecipientText), findsOneWidget);
    final ribbonText =
        tester.widget<RibbonRecipientText>(find.byType(RibbonRecipientText));
    expect(ribbonText.recipientName, equals("Abigail Lazcano"));

    // Verify CTA Button
    expect(find.byType(EnvelopeCtaButton), findsOneWidget);
    expect(find.text("DALE "), findsOneWidget);
    expect(find.text("CLICK"), findsOneWidget);
    expect(find.text(" PARA ABRIR TU INVITACIÓN"), findsOneWidget);

    // Tap CTA Button
    await tester.tap(find.byType(EnvelopeCtaButton));
    await tester.pump();

    expect(wasOpened, isTrue);
  });
}
