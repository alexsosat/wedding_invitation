import "package:boda_ma/features/invitation/business/entities/guest_entity.dart";
import "package:boda_ma/features/invitation/business/entities/invitation_entity.dart";
import "package:boda_ma/features/invitation/business/repositories/invitation_repository.dart";
import "package:boda_ma/features/invitation/business/use_cases/create_invitation.dart";
import "package:boda_ma/features/invitation/business/use_cases/delete_invitation.dart";
import "package:boda_ma/features/invitation/business/use_cases/get_all_invitations.dart";
import "package:boda_ma/features/invitation/business/use_cases/toggle_guest_confirmation_status.dart";
import "package:boda_ma/features/invitation/business/use_cases/toggle_invitation_sent_status.dart";
import "package:boda_ma/features/invitation/business/use_cases/update_invitation.dart";
import "package:boda_ma/features/invitation/data/models/params/invitation_params.dart";
import "package:boda_ma/features/invitation/presentation/cubits/admin_dashboard_cubit.dart";
import "package:boda_ma/features/invitation/presentation/cubits/admin_dashboard_state.dart";
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
  Future<Either<Failure, Unit>> toggleGuestConfirmationStatus({
    required String invitationId,
    required String guestId,
    required bool isConfirmed,
  }) async {
    final index = invitations.indexWhere((i) => i.id == invitationId);
    if (index >= 0) {
      final updatedGuests = invitations[index].guests.map((g) {
        if (g.id == guestId) {
          return g.copyWith(isConfirmed: isConfirmed);
        }
        return g;
      }).toList();
      invitations[index] = invitations[index].copyWith(guests: updatedGuests);
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
  late AdminDashboardCubit cubit;

  setUp(() {
    repository = FakeInvitationRepository();
    cubit = AdminDashboardCubit(
      getAllInvitations:
          GetAllInvitations(invitationRepository: repository),
      createInvitation:
          CreateInvitation(invitationRepository: repository),
      updateInvitation:
          UpdateInvitation(invitationRepository: repository),
      deleteInvitation:
          DeleteInvitation(invitationRepository: repository),
      toggleInvitationSentStatus:
          ToggleInvitationSentStatus(invitationRepository: repository),
      toggleGuestConfirmationStatus:
          ToggleGuestConfirmationStatus(invitationRepository: repository),
    );
  });

  tearDown(() {
    cubit.close();
  });

  test("loads invitations and computes stats", () async {
    repository.invitations = [
      const InvitationEntity(
        id: "1",
        groupName: "Familia Sosa",
        slug: "familia-sosa",
        isSent: true,
        guests: [
          GuestEntity(
            id: "g1",
            firstName: "Alex",
            lastName: "Sosa",
            attendance: AttendanceStatus.attending,
            dietary: DietaryRequirement.none,
            invitationId: "1",
          ),
          GuestEntity(
            id: "g2",
            firstName: "Mayte",
            lastName: "López",
            attendance: AttendanceStatus.pending,
            dietary: DietaryRequirement.none,
            invitationId: "1",
          ),
        ],
      ),
    ];

    await cubit.loadInvitations();

    expect(cubit.state, isA<AdminDashboardLoaded>());
    final state = cubit.state as AdminDashboardLoaded;
    expect(state.totalInvitations, equals(1));
    expect(state.totalGuests, equals(2));
    expect(state.totalConfirmedGuests, equals(1));
    expect(state.totalPendingGuests, equals(1));
    expect(state.sentInvitationsCount, equals(1));
  });

  test("filters invitations by query and status", () async {
    repository.invitations = [
      const InvitationEntity(
        id: "1",
        groupName: "Familia Sosa",
        slug: "familia-sosa",
        isSent: true,
        guests: [],
      ),
      const InvitationEntity(
        id: "2",
        groupName: "Familia Perez",
        slug: "familia-perez",
        isSent: false,
        guests: [],
      ),
    ];

    await cubit.loadInvitations();

    // Query filter
    cubit.updateSearchQuery("Sosa");
    var state = cubit.state as AdminDashboardLoaded;
    expect(state.filteredInvitations.length, equals(1));
    expect(state.filteredInvitations.first.groupName, equals("Familia Sosa"));

    // Status filter
    cubit
      ..updateSearchQuery("")
      ..updateFilter(InvitationFilterStatus.unsent);
    state = cubit.state as AdminDashboardLoaded;
    expect(state.filteredInvitations.length, equals(1));
    expect(state.filteredInvitations.first.groupName, equals("Familia Perez"));
  });

  test("computes dietary metrics and filters by dietary option", () async {
    repository.invitations = [
      const InvitationEntity(
        id: "1",
        groupName: "Familia Sosa",
        slug: "familia-sosa",
        isSent: true,
        guests: [
          GuestEntity(
            id: "g1",
            firstName: "Alex",
            lastName: "Sosa",
            attendance: AttendanceStatus.attending,
            dietary: DietaryRequirement.meat,
            invitationId: "1",
          ),
          GuestEntity(
            id: "g2",
            firstName: "Mayte",
            lastName: "López",
            attendance: AttendanceStatus.attending,
            dietary: DietaryRequirement.vegetarian,
            invitationId: "1",
          ),
        ],
      ),
      const InvitationEntity(
        id: "2",
        groupName: "Familia Perez",
        slug: "familia-perez",
        isSent: false,
        guests: [
          GuestEntity(
            id: "g3",
            firstName: "Juan",
            lastName: "Perez",
            attendance: AttendanceStatus.attending,
            dietary: DietaryRequirement.vegan,
            invitationId: "2",
          ),
          GuestEntity(
            id: "g4",
            firstName: "Maria",
            lastName: "Perez",
            attendance: AttendanceStatus.attending,
            dietary: DietaryRequirement.none,
            invitationId: "2",
          ),
        ],
      ),
    ];

    await cubit.loadInvitations();

    var state = cubit.state as AdminDashboardLoaded;
    expect(state.totalMeatGuests, equals(1));
    expect(state.totalVegetarianGuests, equals(1));
    expect(state.totalVeganGuests, equals(1));

    // Filter by vegetarian
    cubit.updateDietaryFilter(DietaryFilterStatus.vegetarian);
    state = cubit.state as AdminDashboardLoaded;
    expect(state.filteredInvitations.length, equals(1));
    expect(state.filteredInvitations.first.id, equals("1"));

    // Filter by vegan
    cubit.updateDietaryFilter(DietaryFilterStatus.vegan);
    state = cubit.state as AdminDashboardLoaded;
    expect(state.filteredInvitations.length, equals(1));
    expect(state.filteredInvitations.first.id, equals("2"));
  });

  test("toggles guest confirmation status optimistically and in repository",
      () async {
    repository.invitations = [
      const InvitationEntity(
        id: "inv1",
        groupName: "Familia Sosa",
        slug: "familia-sosa",
        guests: [
          GuestEntity(
            id: "g1",
            firstName: "Alejandro",
            lastName: "Sosa",
            attendance: AttendanceStatus.attending,
            dietary: DietaryRequirement.none,
            invitationId: "inv1",
            isConfirmed: false,
          ),
        ],
      ),
    ];

    await cubit.loadInvitations();
    var state = cubit.state as AdminDashboardLoaded;
    expect(state.totalAdminConfirmedGuests, equals(0));
    expect(state.invitations.first.guests.first.isConfirmed, isFalse);

    // Toggle confirmation to true
    await cubit.toggleGuestConfirmation("inv1", "g1", true);
    state = cubit.state as AdminDashboardLoaded;
    expect(state.totalAdminConfirmedGuests, equals(1));
    expect(state.invitations.first.guests.first.isConfirmed, isTrue);
    expect(repository.invitations.first.guests.first.isConfirmed, isTrue);

    // Toggle confirmation to false
    await cubit.toggleGuestConfirmation("inv1", "g1", false);
    state = cubit.state as AdminDashboardLoaded;
    expect(state.totalAdminConfirmedGuests, equals(0));
    expect(state.invitations.first.guests.first.isConfirmed, isFalse);
    expect(repository.invitations.first.guests.first.isConfirmed, isFalse);
  });
}
