import "package:flutter_common_classes/flutter_common_classes.dart";

import "../../business/entities/invitation_entity.dart";
import "../../business/use_cases/create_invitation.dart";
import "../../business/use_cases/delete_invitation.dart";
import "../../business/use_cases/get_all_invitations.dart";
import "../../business/use_cases/toggle_invitation_sent_status.dart";
import "../../business/use_cases/update_invitation.dart";
import "../../data/models/params/admin_invitation_params.dart";
import "admin_dashboard_state.dart";

/// Cubit managing admin dashboard operations and invitations CRUD
class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  /// Creates an [AdminDashboardCubit] instance
  AdminDashboardCubit({
    required GetAllInvitations getAllInvitations,
    required CreateInvitation createInvitation,
    required UpdateInvitation updateInvitation,
    required DeleteInvitation deleteInvitation,
    required ToggleInvitationSentStatus toggleInvitationSentStatus,
  })  : _getAllInvitations = getAllInvitations,
        _createInvitation = createInvitation,
        _updateInvitation = updateInvitation,
        _deleteInvitation = deleteInvitation,
        _toggleInvitationSentStatus = toggleInvitationSentStatus,
        super(const AdminDashboardInitial());

  final GetAllInvitations _getAllInvitations;
  final CreateInvitation _createInvitation;
  final UpdateInvitation _updateInvitation;
  final DeleteInvitation _deleteInvitation;
  final ToggleInvitationSentStatus _toggleInvitationSentStatus;

  /// Loads all invitations from Firestore
  Future<void> loadInvitations() async {
    safeEmit(const AdminDashboardLoading());

    final result = await _getAllInvitations(params: const NoParams());

    result.fold(
      (failure) => safeEmit(AdminDashboardError(failure: failure)),
      (invitations) => safeEmit(AdminDashboardLoaded(invitations: invitations)),
    );
  }

  /// Updates the active search query
  void updateSearchQuery(String query) {
    final currentState = state;
    if (currentState is AdminDashboardLoaded) {
      safeEmit(currentState.copyWith(searchQuery: query));
    }
  }

  /// Updates the active filter tab
  void updateFilter(InvitationFilterStatus filter) {
    final currentState = state;
    if (currentState is AdminDashboardLoaded) {
      safeEmit(currentState.copyWith(selectedFilter: filter));
    }
  }

  /// Creates a new invitation
  Future<void> createInvitation(InvitationEntity invitation) async {
    final currentState = state;
    if (currentState is! AdminDashboardLoaded) {
      return;
    }

    safeEmit(currentState.copyWith(isPerformingAction: true));

    final result = await _createInvitation(
      params: CreateInvitationParams(invitation: invitation),
    );

    result.fold(
      (failure) => safeEmit(AdminDashboardError(failure: failure)),
      (created) {
        final updatedList = [created, ...currentState.invitations];
        safeEmit(
          currentState.copyWith(
            invitations: updatedList,
            isPerformingAction: false,
            actionSuccessMessage: "Invitación creada exitosamente",
          ),
        );
      },
    );
  }

  /// Updates an existing invitation
  Future<void> updateInvitation(InvitationEntity invitation) async {
    final currentState = state;
    if (currentState is! AdminDashboardLoaded) {
      return;
    }

    safeEmit(currentState.copyWith(isPerformingAction: true));

    final result = await _updateInvitation(
      params: UpdateInvitationParams(invitation: invitation),
    );

    result.fold(
      (failure) => safeEmit(AdminDashboardError(failure: failure)),
      (updated) {
        final updatedList = currentState.invitations
            .map((inv) => inv.id == updated.id ? updated : inv)
            .toList();

        safeEmit(
          currentState.copyWith(
            invitations: updatedList,
            isPerformingAction: false,
            actionSuccessMessage: "Invitación actualizada correctamente",
          ),
        );
      },
    );
  }

  /// Deletes an invitation
  Future<void> deleteInvitation(String invitationId) async {
    final currentState = state;
    if (currentState is! AdminDashboardLoaded) {
      return;
    }

    safeEmit(currentState.copyWith(isPerformingAction: true));

    final result = await _deleteInvitation(
      params: DeleteInvitationParams(invitationId: invitationId),
    );

    result.fold(
      (failure) => safeEmit(AdminDashboardError(failure: failure)),
      (_) {
        final updatedList = currentState.invitations
            .where((inv) => inv.id != invitationId)
            .toList();

        safeEmit(
          currentState.copyWith(
            invitations: updatedList,
            isPerformingAction: false,
            actionSuccessMessage: "Invitación eliminada",
          ),
        );
      },
    );
  }

  /// Toggles sent status of an invitation
  Future<void> toggleSentStatus(String invitationId, bool isSent) async {
    final currentState = state;
    if (currentState is! AdminDashboardLoaded) {
      return;
    }

    final result = await _toggleInvitationSentStatus(
      params: ToggleInvitationSentParams(
        invitationId: invitationId,
        isSent: isSent,
      ),
    );

    result.fold(
      (failure) => safeEmit(AdminDashboardError(failure: failure)),
      (_) {
        final updatedList = currentState.invitations.map((inv) {
          if (inv.id == invitationId) {
            return inv.copyWith(
              isSent: isSent,
              sentAt: isSent ? DateTime.now() : null,
            );
          }
          return inv;
        }).toList();

        safeEmit(
          currentState.copyWith(
            invitations: updatedList,
            actionSuccessMessage: isSent
                ? "Invitación marcada como enviada"
                : "Invitación marcada como no enviada",
          ),
        );
      },
    );
  }

  /// Clears transient action message
  void clearActionMessage() {
    final currentState = state;
    if (currentState is AdminDashboardLoaded) {
      safeEmit(currentState.copyWith(actionSuccessMessage: null));
    }
  }
}
