import "package:boda_ma/features/invitation/business/entities/guest_entity.dart";
import "package:boda_ma/features/invitation/business/entities/invitation_entity.dart";
import "package:boda_ma/features/invitation/business/repositories/invitation_repository.dart";
import "package:boda_ma/features/invitation/business/use_cases/create_invitation.dart";
import "package:boda_ma/features/invitation/business/use_cases/delete_invitation.dart";
import "package:boda_ma/features/invitation/business/use_cases/get_all_invitations.dart";
import "package:boda_ma/features/invitation/business/use_cases/toggle_invitation_sent_status.dart";
import "package:boda_ma/features/invitation/business/use_cases/update_invitation.dart";
import "package:boda_ma/features/invitation/data/models/params/admin_invitation_params.dart";
import "package:boda_ma/features/invitation/data/models/params/invitation_params.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:flutter_test/flutter_test.dart";
import "package:fpdart/fpdart.dart";

class FakeInvitationRepository implements InvitationRepository {
  List<InvitationEntity> invitations = [];

  @override
  Future<Either<Failure, List<InvitationEntity>>> getAllInvitations() async =>
      Right(invitations);

  @override
  Future<Either<Failure, InvitationEntity>> createInvitation({
    required InvitationEntity invitation,
  }) async {
    final created = invitation.copyWith(id: "inv_${invitations.length + 1}");
    invitations.add(created);
    return Right(created);
  }

  @override
  Future<Either<Failure, InvitationEntity>> updateInvitation({
    required InvitationEntity invitation,
  }) async {
    final index = invitations.indexWhere((i) => i.id == invitation.id);
    if (index >= 0) {
      invitations[index] = invitation;
    }
    return Right(invitation);
  }

  @override
  Future<Either<Failure, Unit>> deleteInvitation({
    required String invitationId,
  }) async {
    invitations.removeWhere((i) => i.id == invitationId);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> toggleInvitationSentStatus({
    required String invitationId,
    required bool isSent,
  }) async {
    final index = invitations.indexWhere((i) => i.id == invitationId);
    if (index >= 0) {
      invitations[index] = invitations[index].copyWith(
        isSent: isSent,
        sentAt: isSent ? DateTime.now() : null,
      );
    }
    return const Right(unit);
  }

  @override
  Future<Either<Failure, InvitationEntity>> getInvitation({
    required InvitationParams params,
  }) async =>
      Right(invitations.first);

  @override
  Future<Either<Failure, List<GuestEntity>>> getGuests({
    required String invitationId,
  }) async =>
      const Right([]);

  @override
  Future<Either<Failure, Unit>> updateGuestRsvp({
    required GuestEntity guest,
  }) async =>
      const Right(unit);
}

void main() {
  late FakeInvitationRepository repository;
  late GetAllInvitations getAllInvitations;
  late CreateInvitation createInvitation;
  late UpdateInvitation updateInvitation;
  late DeleteInvitation deleteInvitation;
  late ToggleInvitationSentStatus toggleInvitationSentStatus;

  setUp(() {
    repository = FakeInvitationRepository();
    getAllInvitations = GetAllInvitations(invitationRepository: repository);
    createInvitation = CreateInvitation(invitationRepository: repository);
    updateInvitation = UpdateInvitation(invitationRepository: repository);
    deleteInvitation = DeleteInvitation(invitationRepository: repository);
    toggleInvitationSentStatus =
        ToggleInvitationSentStatus(invitationRepository: repository);
  });

  test("creates, retrieves, updates, and deletes invitations", () async {
    // 1. Create
    const newInv = InvitationEntity(
      groupName: "Familia Sosa",
      slug: "familia-sosa",
      guests: [
        GuestEntity(
          id: "g1",
          firstName: "Alejandro",
          lastName: "Sosa",
          attendance: AttendanceStatus.attending,
          dietary: DietaryRequirement.none,
          invitationId: "",
        ),
      ],
    );

    final createResult =
        await createInvitation(params: CreateInvitationParams(invitation: newInv));
    expect(createResult.isRight(), isTrue);
    final created = createResult.getOrElse((_) => throw Exception());
    expect(created.id, equals("inv_1"));
    expect(created.groupName, equals("Familia Sosa"));

    // 2. Get All
    final listResult = await getAllInvitations(params: const NoParams());
    expect(listResult.isRight(), isTrue);
    expect(listResult.getOrElse((_) => []).length, equals(1));

    // 3. Toggle Sent
    final toggleResult = await toggleInvitationSentStatus(
      params: ToggleInvitationSentParams(
        invitationId: "inv_1",
        isSent: true,
      ),
    );
    expect(toggleResult.isRight(), isTrue);
    expect(repository.invitations.first.isSent, isTrue);

    // 4. Update
    final updatedInv = created.copyWith(groupName: "Familia Sosa Pérez");
    final updateResult = await updateInvitation(
      params: UpdateInvitationParams(invitation: updatedInv),
    );
    expect(updateResult.isRight(), isTrue);
    expect(
      updateResult.getOrElse((_) => throw Exception()).groupName,
      equals("Familia Sosa Pérez"),
    );

    // 5. Delete
    final deleteResult = await deleteInvitation(
      params: DeleteInvitationParams(invitationId: "inv_1"),
    );
    expect(deleteResult.isRight(), isTrue);
    expect(repository.invitations, isEmpty);
  });
}
