import "dart:async";

import "package:boda_ma/features/invitation/presentation/pages/envelope_page.dart";
import "package:boda_ma/features/invitation/presentation/widgets/envelope/envelope_card.dart";
import "package:boda_ma/features/invitation/presentation/widgets/envelope/envelope_cta_button.dart";
import "package:boda_ma/features/invitation/presentation/widgets/envelope/ribbon_recipient_text.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("EnvelopePage renders all elements and handles tap", (
    tester,
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
    await tester.pump(const Duration(milliseconds: 700));

    expect(wasOpened, isTrue);
  });

  testWidgets("EnvelopePage handles tap on EnvelopeCard directly", (
    tester,
  ) async {
    bool wasOpened = false;

    await tester.pumpWidget(
      MaterialApp(
        home: EnvelopePage(
          recipientName: "Invitado Especial",
          onOpen: () {
            wasOpened = true;
          },
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Tap EnvelopeCard
    await tester.tap(find.byType(EnvelopeCard));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(wasOpened, isTrue);
  });

  testWidgets("EnvelopeCard scales on mouse hover", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnvelopeCard(
            recipientName: "Invitado",
            onTap: () {},
          ),
        ),
      ),
    );

    await tester.pump();

    final animatedScaleFinder = find.descendant(
      of: find.byType(EnvelopeCard),
      matching: find.byType(AnimatedScale),
    );
    expect(animatedScaleFinder, findsOneWidget);

    final initialScale =
        tester.widget<AnimatedScale>(animatedScaleFinder).scale;
    expect(initialScale, equals(1.0));

    // Simulate mouse hover
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);

    await gesture.moveTo(tester.getCenter(find.byType(EnvelopeCard)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final hoveredScale =
        tester.widget<AnimatedScale>(animatedScaleFinder).scale;
    expect(hoveredScale, equals(1.04));
  });

  testWidgets("EnvelopeCard applies SlideTransition to ribbon", (
    tester,
  ) async {
    final controller = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 500),
    );
    final slideAnimation = Tween<Offset>(
      begin: const Offset(-0.35, 0),
      end: Offset.zero,
    ).animate(controller);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnvelopeCard(
            recipientName: "Invitado",
            ribbonSlideAnimation: slideAnimation,
          ),
        ),
      ),
    );

    final slideFinder = find.byWidgetPredicate(
      (widget) =>
          widget is SlideTransition && widget.position == slideAnimation,
    );
    expect(slideFinder, findsOneWidget);
    final slideTransition = tester.widget<SlideTransition>(slideFinder);
    expect(slideTransition.position.value, equals(const Offset(-0.35, 0)));

    unawaited(controller.forward());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(slideTransition.position.value, equals(Offset.zero));
    controller.dispose();
  });
}
