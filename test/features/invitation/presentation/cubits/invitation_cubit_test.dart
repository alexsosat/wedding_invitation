import "package:boda_ma/core/errors/failures.dart";
import "package:boda_ma/features/invitation/business/entities/guest_entity.dart";
import "package:boda_ma/features/invitation/business/entities/invitation_entity.dart";
import "package:boda_ma/features/invitation/business/repositories/invitation_repository.dart";
import "package:boda_ma/features/invitation/business/use_cases/get_invitation.dart";
import "package:boda_ma/features/invitation/business/use_cases/update_guest_rsvp.dart";
import "package:boda_ma/features/invitation/data/models/params/invitation_params.dart";
import "package:boda_ma/features/invitation/presentation/cubits/invitation_cubit.dart";
import "package:boda_ma/features/invitation/presentation/cubits/invitation_state.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:flutter_test/flutter_test.dart";
import "package:fpdart/fpdart.dart";

class FakeInvitationRepository implements InvitationRepository {
  InvitationEntity? invitation;
  bool shouldFailUpdate = false;

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
    if (shouldFailUpdate) {
      return Left(ServerFailure(message: "Failed to update RSVP"));
    }
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

  const sampleGuest = GuestEntity(
    id: "g-1",
    firstName: "Alejandro",
    lastName: "Sosa",
    attendance: AttendanceStatus.pending,
    dietary: DietaryRequirement.none,
    invitationId: "inv-1",
  );

  const sampleInvitation = InvitationEntity(
    id: "inv-1",
    groupName: "Familia Sosa Trejo",
    slug: "sosa-trejo",
    guests: [sampleGuest],
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

  test("loads invitation by slug successfully", () async {
    await cubit.loadInvitationBySlug("sosa-trejo");

    expect(cubit.state, isA<InvitationLoaded>());
    final loadedState = cubit.state as InvitationLoaded;
    expect(loadedState.invitation.groupName, equals("Familia Sosa Trejo"));
  });

  test("updates guest RSVP attendance and dietary successfully", () async {
    await cubit.loadInvitationBySlug("sosa-trejo");

    final updatedGuest = sampleGuest.copyWith(
      attendance: AttendanceStatus.attending,
      dietary: DietaryRequirement.vegetarian,
    );

    await cubit.updateGuestRsvp(updatedGuest);

    expect(cubit.state, isA<InvitationLoaded>());
    final loadedState = cubit.state as InvitationLoaded;
    expect(loadedState.isUpdatingRsvp, isFalse);
    expect(loadedState.rsvpUpdateMessage, isNotNull);
    final guestInState = loadedState.invitation.guests.first;
    expect(guestInState.attendance, equals(AttendanceStatus.attending));
    expect(guestInState.dietary, equals(DietaryRequirement.vegetarian));
  });

  test("handles updateGuestRsvp failure while preserving loaded invitation",
      () async {
    await cubit.loadInvitationBySlug("sosa-trejo");

    repository.shouldFailUpdate = true;

    final updatedGuest = sampleGuest.copyWith(
      attendance: AttendanceStatus.notAttending,
    );

    await cubit.updateGuestRsvp(updatedGuest);

    expect(cubit.state, isA<InvitationLoaded>());
    final loadedState = cubit.state as InvitationLoaded;
    expect(loadedState.isUpdatingRsvp, isFalse);
    expect(loadedState.rsvpErrorMessage, equals("Failed to update RSVP"));
  });
}
