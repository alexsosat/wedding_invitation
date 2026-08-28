import "package:boda_ma/features/invitation/business/entities/guest_entity.dart";
import "package:boda_ma/features/invitation/business/entities/invitation_entity.dart";
import "package:boda_ma/features/invitation/presentation/widgets/admin/invitation_card.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  const notSentInvitation = InvitationEntity(
    id: "inv-1",
    groupName: "Familia Sosa",
    slug: "familia-sosa",
    isSent: false,
    guests: [
      GuestEntity(
        id: "g-1",
        firstName: "Alejandro",
        lastName: "Sosa",
        phone: "+52 55 1234 5678",
        attendance: AttendanceStatus.pending,
        dietary: DietaryRequirement.none,
        invitationId: "inv-1",
      ),
    ],
  );

  const sentInvitation = InvitationEntity(
    id: "inv-2",
    groupName: "Familia Pérez",
    slug: "familia-perez",
    isSent: true,
    guests: [
      GuestEntity(
        id: "g-2",
        firstName: "María",
        lastName: "Pérez",
        phone: "+52 55 9876 5432",
        attendance: AttendanceStatus.pending,
        dietary: DietaryRequirement.vegetarian,
        invitationId: "inv-2",
      ),
    ],
  );

  Widget createWidgetUnderTest(InvitationEntity invitation) => MaterialApp(
        theme: ThemeData(splashFactory: InkRipple.splashFactory),
        home: Scaffold(
          body: SingleChildScrollView(
            child: InvitationCard(
              invitation: invitation,
              onEdit: () {},
              onDelete: () {},
              onToggleSent: (_) {},
            ),
          ),
        ),
      );

  group("InvitationCard WhatsApp Template Tests", () {
    testWidgets(
      "shows 'Enviar WhatsApp' when invitation is not yet sent (isSent: false)",
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(notSentInvitation));
        await tester.pumpAndSettle();

        // Tap the phone popup menu to open menu items
        final popupMenuFinder = find.byType(PopupMenuButton<String>);
        expect(popupMenuFinder, findsOneWidget);
        await tester.tap(popupMenuFinder);
        await tester.pumpAndSettle();

        // Should see initial invitation labels
        expect(find.text("Enviar WhatsApp"), findsOneWidget);
        expect(find.text("Invitación con enlace"), findsOneWidget);
        expect(find.text("Recordatorio WhatsApp"), findsNothing);
      },
    );

    testWidgets(
      "shows 'Recordatorio WhatsApp' when invitation is sent (isSent: true) and attendance is pending",
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(sentInvitation));
        await tester.pumpAndSettle();

        // Tap the phone popup menu to open menu items
        final popupMenuFinder = find.byType(PopupMenuButton<String>);
        expect(popupMenuFinder, findsOneWidget);
        await tester.tap(popupMenuFinder);
        await tester.pumpAndSettle();

        // Should see confirmation reminder labels
        expect(find.text("Recordatorio WhatsApp"), findsOneWidget);
        expect(find.text("Recordatorio de confirmación"), findsOneWidget);
        expect(find.text("Enviar WhatsApp"), findsNothing);
      },
    );

    testWidgets(
      "shows 'Confirmar WhatsApp' when invitation is sent (isSent: true) and attendance is filled",
      (tester) async {
        const respondedInvitation = InvitationEntity(
          id: "inv-3",
          groupName: "Familia Gómez",
          slug: "familia-gomez",
          isSent: true,
          guests: [
            GuestEntity(
              id: "g-3",
              firstName: "Carlos",
              lastName: "Gómez",
              phone: "+52 55 1122 3344",
              attendance: AttendanceStatus.attending,
              dietary: DietaryRequirement.meat,
              invitationId: "inv-3",
            ),
          ],
        );

        await tester.pumpWidget(createWidgetUnderTest(respondedInvitation));
        await tester.pumpAndSettle();

        final popupMenuFinder = find.byType(PopupMenuButton<String>);
        expect(popupMenuFinder, findsOneWidget);
        await tester.tap(popupMenuFinder);
        await tester.pumpAndSettle();

        expect(find.text("Confirmar WhatsApp"), findsOneWidget);
        expect(find.text("Validar selección del invitado"), findsOneWidget);
      },
    );

    testWidgets(
      "displays confirmation status badge and invokes onToggleGuestConfirmation",
      (tester) async {
        String? toggledGuestId;
        bool? toggledStatus;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(splashFactory: InkRipple.splashFactory),
            home: Scaffold(
              body: SingleChildScrollView(
                child: InvitationCard(
                  invitation: notSentInvitation,
                  onEdit: () {},
                  onDelete: () {},
                  onToggleSent: (_) {},
                  onToggleGuestConfirmation: (guestId, isConfirmed) {
                    toggledGuestId = guestId;
                    toggledStatus = isConfirmed;
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Initially guest is pending admin confirmation
        expect(find.text("Admin: Pend."), findsOneWidget);

        // Tap on the confirmation badge
        await tester.tap(find.text("Admin: Pend."));
        await tester.pumpAndSettle();

        expect(toggledGuestId, equals("g-1"));
        expect(toggledStatus, isTrue);
      },
    );

    testWidgets(
      "displays host side badge when guest has side assigned",
      (tester) async {
        const invitationWithSide = InvitationEntity(
          id: "inv-side",
          groupName: "Familia Sosa",
          slug: "familia-sosa",
          isSent: true,
          guests: [
            GuestEntity(
              id: "g-bride",
              firstName: "Mayte",
              lastName: "López",
              attendance: AttendanceStatus.attending,
              dietary: DietaryRequirement.vegetarian,
              side: GuestSide.bride,
              invitationId: "inv-side",
            ),
            GuestEntity(
              id: "g-groom",
              firstName: "Alex",
              lastName: "Sosa",
              attendance: AttendanceStatus.attending,
              dietary: DietaryRequirement.meat,
              side: GuestSide.groom,
              invitationId: "inv-side",
            ),
          ],
        );

        await tester.pumpWidget(createWidgetUnderTest(invitationWithSide));
        await tester.pumpAndSettle();

        expect(find.text("Novia"), findsOneWidget);
        expect(find.text("Novio"), findsOneWidget);
      },
    );
  });

  group("InvitationCard.buildWhatsAppMessage Unit Tests", () {
    const testGuest = GuestEntity(
      id: "g-test",
      firstName: "Laura",
      lastName: "Ríos",
      attendance: AttendanceStatus.attending,
      dietary: DietaryRequirement.vegetarian,
      dietaryDetails: "Sin lácteos",
      invitationId: "inv-test",
    );

    test("builds initial invitation message when isInvitationSent is false", () {
      final msg = InvitationCard.buildWhatsAppMessage(
        guest: testGuest,
        invitationSlug: "laura-rios",
        isInvitationSent: false,
        baseOrigin: "https://boda.app",
      );

      expect(msg, contains("¡Hola Laura!"));
      expect(msg, contains("Te compartimos el enlace a tu invitación"));
      expect(msg, contains("https://boda.app/#/laura-rios"));
    });

    test("builds reminder message when isInvitationSent is true and attendance is pending", () {
      final pendingGuest = testGuest.copyWith(attendance: AttendanceStatus.pending);
      final msg = InvitationCard.buildWhatsAppMessage(
        guest: pendingGuest,
        invitationSlug: "laura-rios",
        isInvitationSent: true,
        baseOrigin: "https://boda.app",
      );

      expect(msg, contains("¡Hola Laura!"));
      expect(msg, contains("recordarte confirmar tu asistencia"));
      expect(msg, contains("https://boda.app/#/laura-rios"));
    });

    test("builds validation message with dietary details when attending", () {
      final msg = InvitationCard.buildWhatsAppMessage(
        guest: testGuest,
        invitationSlug: "laura-rios",
        isInvitationSent: true,
        baseOrigin: "https://boda.app",
      );

      expect(msg, contains("¡Hola Laura!"));
      expect(msg, contains("validar los datos que registraste"));
      expect(msg, contains("• Asistencia: Sí asistiré"));
      expect(msg, contains("• Menú: Vegetariano (Sin lácteos)"));
      expect(msg, contains("Por favor confirma si esta información sigue siendo correcta"));
      expect(msg, contains("https://boda.app/#/laura-rios"));
    });

    test("builds validation message when not attending", () {
      final notAttendingGuest = testGuest.copyWith(
        attendance: AttendanceStatus.notAttending,
      );
      final msg = InvitationCard.buildWhatsAppMessage(
        guest: notAttendingGuest,
        invitationSlug: "laura-rios",
        isInvitationSent: true,
        baseOrigin: "https://boda.app",
      );

      expect(msg, contains("¡Hola Laura!"));
      expect(msg, contains("validar los datos que registraste"));
      expect(msg, contains("• Asistencia: No podré asistir"));
      expect(msg, isNot(contains("• Menú:")));
      expect(msg, contains("https://boda.app/#/laura-rios"));
    });

    test("renders correctly with international phone numbers (US, Spain, Mexico)", () {
      const usGuest = GuestEntity(
        id: "g-us",
        firstName: "John",
        lastName: "Doe",
        phone: "+1 202 555 0123",
        attendance: AttendanceStatus.attending,
        dietary: DietaryRequirement.meat,
        invitationId: "inv-us",
      );

      final msg = InvitationCard.buildWhatsAppMessage(
        guest: usGuest,
        invitationSlug: "john-doe",
        isInvitationSent: true,
        baseOrigin: "https://boda.app",
      );

      expect(msg, contains("¡Hola John!"));
      expect(msg, contains("https://boda.app/#/john-doe"));
    });
  });
}
