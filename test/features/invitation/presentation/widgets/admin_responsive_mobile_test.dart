import "package:boda_ma/features/invitation/business/entities/guest_entity.dart";
import "package:boda_ma/features/invitation/business/entities/invitation_entity.dart";
import "package:boda_ma/features/invitation/presentation/widgets/admin/dashboard_stats_card.dart";
import "package:boda_ma/features/invitation/presentation/widgets/admin/delete_invitation_dialog.dart";
import "package:boda_ma/features/invitation/presentation/widgets/admin/guest_form_item.dart";
import "package:boda_ma/features/invitation/presentation/widgets/admin/invitation_card.dart";
import "package:boda_ma/features/invitation/presentation/widgets/admin/invitation_form_dialog.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  final sampleInvitation = InvitationEntity(
    id: "inv-1",
    groupName: "Familia Francisco Javier Hernández González y Asociados",
    slug: "familia-francisco-javier-hernandez-gonzalez-y-asociados",
    isSent: true,
    sentAt: DateTime(2026, 8, 25),
    createdAt: DateTime(2026, 8, 20),
    guests: const [
      GuestEntity(
        id: "g-1",
        firstName: "Alejandro Francisco",
        lastName: "Sosa Rodríguez",
        phone: "+52 55 1234 5678",
        attendance: AttendanceStatus.attending,
        dietary: DietaryRequirement.meat,
        invitationId: "inv-1",
      ),
      GuestEntity(
        id: "g-2",
        firstName: "María Fernanda",
        lastName: "Pérez Gómez",
        phone: "+52 55 9876 5432",
        attendance: AttendanceStatus.notAttending,
        dietary: DietaryRequirement.vegetarian,
        invitationId: "inv-1",
      ),
      GuestEntity(
        id: "g-3",
        firstName: "Carlos Alberto",
        lastName: "Hernández",
        phone: null,
        attendance: AttendanceStatus.pending,
        dietary: DietaryRequirement.vegan,
        invitationId: "inv-1",
      ),
    ],
  );

  group("Admin Mobile Responsive Tests (No Overflow)", () {
    testWidgets("InvitationCard renders on 320px mobile width without overflow",
        (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: InvitationCard(
                invitation: sampleInvitation,
                onEdit: () {},
                onDelete: () {},
                onToggleSent: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(InvitationCard), findsOneWidget);
    });

    testWidgets("DashboardStatsCard renders on 320px mobile grid without overflow",
        (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.15,
                children: const [
                  DashboardStatsCard(
                    title: "Total Invitaciones",
                    value: "142",
                    icon: Icons.mail_outline,
                    color: Color(0xff30405F),
                    subtitle: "98 enviadas / 44 pendientes",
                  ),
                  DashboardStatsCard(
                    title: "Confirmados",
                    value: "285",
                    icon: Icons.check_circle_outline,
                    color: Colors.green,
                    subtitle: "78.5% del total",
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(DashboardStatsCard), findsNWidgets(2));
    });

    testWidgets("GuestFormItem renders on 320px width without overflow",
        (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final firstNameCtrl = TextEditingController(text: "Alejandro Francisco");
      final lastNameCtrl = TextEditingController(text: "Sosa Rodríguez");
      final phoneCtrl = TextEditingController(text: "+52 55 1234 5678");
      final dietaryDetailsCtrl = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: GuestFormItem(
                index: 0,
                firstNameController: firstNameCtrl,
                lastNameController: lastNameCtrl,
                phoneController: phoneCtrl,
                attendance: AttendanceStatus.attending,
                dietary: DietaryRequirement.none,
                side: GuestSide.none,
                dietaryDetailsController: dietaryDetailsCtrl,
                onAttendanceChanged: (_) {},
                onDietaryChanged: (_) {},
                onSideChanged: (_) {},
                onRemove: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(GuestFormItem), findsOneWidget);

      firstNameCtrl.dispose();
      lastNameCtrl.dispose();
      phoneCtrl.dispose();
      dietaryDetailsCtrl.dispose();
    });

    testWidgets("InvitationFormDialog renders on 320x600 screen without overflow",
        (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InvitationFormDialog(
              invitation: sampleInvitation,
              onSave: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(InvitationFormDialog), findsOneWidget);
    });

    testWidgets("DeleteInvitationDialog renders on 320x600 screen without overflow",
        (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteInvitationDialog(
              invitation: sampleInvitation,
              onConfirm: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(DeleteInvitationDialog), findsOneWidget);
    });
  });
}
