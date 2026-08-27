import "package:boda_ma/core/errors/failures.dart";
import "package:boda_ma/features/invitation/business/entities/guest_entity.dart";
import "package:boda_ma/features/invitation/business/entities/invitation_entity.dart";
import "package:boda_ma/features/invitation/business/repositories/invitation_repository.dart";
import "package:boda_ma/features/invitation/business/use_cases/get_invitation.dart";
import "package:boda_ma/features/invitation/business/use_cases/update_guest_rsvp.dart";
import "package:boda_ma/features/invitation/data/models/params/invitation_params.dart";
import "package:boda_ma/features/invitation/presentation/cubits/invitation_cubit.dart";
import "package:boda_ma/features/invitation/presentation/widgets/rsvp/rsvp_confirmation_dialog.dart";
import "package:boda_ma/features/invitation/presentation/widgets/rsvp/rsvp_content.dart";
import "package:flutter/material.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:flutter_test/flutter_test.dart";
import "package:fpdart/fpdart.dart";

class FakeInvitationRepository implements InvitationRepository {
  InvitationEntity? invitation;
  GuestEntity? lastUpdatedGuest;

  @override
  Future<Either<Failure, InvitationEntity>> getInvitation({
    required InvitationParams params,
  }) async {
    if (invitation != null) {
      return Right(invitation!);
    }
    return Left(ServerFailure(message: "Not found"));
  }

  @override
  Future<Either<Failure, Unit>> updateGuestRsvp({
    required GuestEntity guest,
  }) async {
    lastUpdatedGuest = guest;
    if (invitation != null) {
      final updatedGuests = invitation!.guests.map((g) {
        if (g.id == guest.id) {
          return guest;
        }
        return g;
      }).toList();
      invitation = invitation!.copyWith(guests: updatedGuests);
    }
    return const Right(unit);
  }

  @override
  Future<Either<Failure, List<InvitationEntity>>> getAllInvitations() async =>
      const Right([]);

  @override
  Future<Either<Failure, InvitationEntity>> createInvitation({
    required InvitationEntity invitation,
  }) async =>
      Right(invitation);

  @override
  Future<Either<Failure, InvitationEntity>> updateInvitation({
    required InvitationEntity invitation,
  }) async =>
      Right(invitation);

  @override
  Future<Either<Failure, Unit>> deleteInvitation({
    required String invitationId,
  }) async =>
      const Right(unit);

  @override
  Future<Either<Failure, Unit>> toggleInvitationSentStatus({
    required String invitationId,
    required bool isSent,
  }) async =>
      const Right(unit);

  @override
  Future<Either<Failure, List<GuestEntity>>> getGuests({
    required String invitationId,
  }) async =>
      const Right([]);

  @override
  Future<Either<Failure, Unit>> toggleGuestConfirmationStatus({
    required String invitationId,
    required String guestId,
    required bool isConfirmed,
  }) async =>
      const Right(unit);
}

void main() {
  late FakeInvitationRepository repository;
  late InvitationCubit cubit;

  const sampleGuest1 = GuestEntity(
    id: "g-1",
    firstName: "Alejandro",
    lastName: "Sosa",
    attendance: AttendanceStatus.pending,
    dietary: DietaryRequirement.none,
    invitationId: "inv-1",
  );

  const sampleGuest2 = GuestEntity(
    id: "g-2",
    firstName: "Mayte",
    lastName: "López",
    attendance: AttendanceStatus.attending,
    dietary: DietaryRequirement.vegetarian,
    invitationId: "inv-1",
  );

  const sampleInvitation = InvitationEntity(
    id: "inv-1",
    groupName: "Familia Sosa Trejo",
    slug: "sosa-trejo",
    guests: [sampleGuest1, sampleGuest2],
  );

  setUp(() {
    repository = FakeInvitationRepository()..invitation = sampleInvitation;
    cubit = InvitationCubit(
      getInvitation: GetInvitation(invitationRepository: repository),
      updateGuestRsvp: UpdateGuestRsvp(invitationRepository: repository),
    );
  });

  tearDown(() {
    cubit.close();
  });

  Widget buildTestableWidget({Widget? child}) =>
      BlocProvider<InvitationCubit>.value(
        value: cubit,
        child: MaterialApp(
          theme: ThemeData(
            splashFactory: InkRipple.splashFactory,
          ),
          home: Scaffold(
            body: child ?? const RsvpConfirmationDialog(),
          ),
        ),
      );

  group("RsvpConfirmationDialog Widget Tests", () {
    testWidgets("renders all guests with names and dropdowns", (tester) async {
      await cubit.loadInvitationBySlug("sosa-trejo");

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text("Confirmar Asistencia"), findsOneWidget);
      expect(find.text("Familia Sosa Trejo"), findsOneWidget);
      expect(find.text("Alejandro Sosa"), findsOneWidget);
      expect(find.text("Mayte López"), findsOneWidget);
      expect(find.text("Listo"), findsOneWidget);
    });

    testWidgets("selecting attendance dropdown updates guest in cubit",
        (tester) async {
      await cubit.loadInvitationBySlug("sosa-trejo");

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Find the first attendance dropdown
      final dropdowns = find.byType(DropdownButtonFormField<AttendanceStatus>);
      expect(dropdowns, findsNWidgets(2));

      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();

      // Select "Sí asistiré (Confirmado)"
      final attendingOption = find.text("Sí asistiré (Confirmado)").last;
      await tester.tap(attendingOption);
      await tester.pumpAndSettle();

      expect(repository.lastUpdatedGuest?.id, equals("g-1"));
      expect(
        repository.lastUpdatedGuest?.attendance,
        equals(AttendanceStatus.attending),
      );
    });

    testWidgets(
        "selecting not attending resets dietary to none in cubit and repository",
        (tester) async {
      await cubit.loadInvitationBySlug("sosa-trejo");

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Find the second attendance dropdown (sampleGuest2, which is currently attending and vegetarian)
      final dropdowns = find.byType(DropdownButtonFormField<AttendanceStatus>);
      expect(dropdowns, findsNWidgets(2));

      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();

      // Select "No podré asistir"
      final notAttendingOption = find.text("No podré asistir").last;
      await tester.tap(notAttendingOption);
      await tester.pumpAndSettle();

      expect(repository.lastUpdatedGuest?.id, equals("g-2"));
      expect(
        repository.lastUpdatedGuest?.attendance,
        equals(AttendanceStatus.notAttending),
      );
      expect(
        repository.lastUpdatedGuest?.dietary,
        equals(DietaryRequirement.none),
      );
    });

    testWidgets(
        "dietary dropdown only appears when attendance is attending",
        (tester) async {
      await cubit.loadInvitationBySlug("sosa-trejo");

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Initially, sampleGuest1 is pending (no dietary dropdown), sampleGuest2 is attending (1 dietary dropdown)
      expect(
        find.byType(DropdownButtonFormField<DietaryRequirement>),
        findsOneWidget,
      );

      // Change sampleGuest1 attendance to attending
      final attendanceDropdowns =
          find.byType(DropdownButtonFormField<AttendanceStatus>);
      await tester.tap(attendanceDropdowns.first);
      await tester.pumpAndSettle();

      final attendingOption = find.text("Sí asistiré (Confirmado)").last;
      await tester.tap(attendingOption);
      await tester.pumpAndSettle();

      // Now both guests should show dietary dropdown
      expect(
        find.byType(DropdownButtonFormField<DietaryRequirement>),
        findsNWidgets(2),
      );
    });

    testWidgets("selecting dietary dropdown updates guest in cubit",
        (tester) async {
      await cubit.loadInvitationBySlug("sosa-trejo");

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Find the dietary dropdown (belongs to sampleGuest2 which is attending)
      final dropdowns =
          find.byType(DropdownButtonFormField<DietaryRequirement>);
      expect(dropdowns, findsOneWidget);

      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();

      // Select "Vegano"
      final veganOption = find.text("Vegano").last;
      await tester.tap(veganOption);
      await tester.pumpAndSettle();

      expect(repository.lastUpdatedGuest?.id, equals("g-2"));
      expect(
        repository.lastUpdatedGuest?.dietary,
        equals(DietaryRequirement.vegan),
      );
    });

    testWidgets("tapping Listo button closes dialog", (tester) async {
      await cubit.loadInvitationBySlug("sosa-trejo");

      await tester.pumpWidget(
        BlocProvider<InvitationCubit>.value(
          value: cubit,
          child: MaterialApp(
            theme: ThemeData(
              splashFactory: InkRipple.splashFactory,
            ),
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => BlocProvider.value(
                        value: cubit,
                        child: const RsvpConfirmationDialog(),
                      ),
                    );
                  },
                  child: const Text("Open"),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text("Open"));
      await tester.pumpAndSettle();

      expect(find.byType(RsvpConfirmationDialog), findsOneWidget);

      await tester.tap(find.text("Listo"));
      await tester.pumpAndSettle();

      expect(find.byType(RsvpConfirmationDialog), findsNothing);
    });

    testWidgets("renders on 320x600 screen without overflow", (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await cubit.loadInvitationBySlug("sosa-trejo");

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(RsvpConfirmationDialog), findsOneWidget);
    });
  });

  group("RsvpContent CTA interaction", () {
    testWidgets("tapping confirm CTA button opens RsvpConfirmationDialog",
        (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await cubit.loadInvitationBySlug("sosa-trejo");

      await tester.pumpWidget(
        BlocProvider<InvitationCubit>.value(
          value: cubit,
          child: MaterialApp(
            theme: ThemeData(
              splashFactory: InkRipple.splashFactory,
            ),
            home: const Scaffold(
              body: SingleChildScrollView(
                child: RsvpContent(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final ctaButton =
          find.text("DALE CLICK AQUÍ PARA CONFIRMAR TU ASISTENCIA");
      expect(ctaButton, findsOneWidget);

      await tester.ensureVisible(ctaButton);
      await tester.pump();
      await tester.tap(ctaButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(RsvpConfirmationDialog), findsOneWidget);
      expect(find.text("Confirmar Asistencia"), findsOneWidget);
    });
  });
}
