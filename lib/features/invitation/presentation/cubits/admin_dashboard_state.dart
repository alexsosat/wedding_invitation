import "package:equatable/equatable.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";

import "../../business/entities/invitation_entity.dart";

/// Filter options for displaying invitations in the admin dashboard
enum InvitationFilterStatus {
  /// Show all invitations
  all("Todos"),

  /// Show sent invitations
  sent("Enviadas"),

  /// Show unsent invitations
  unsent("Pendientes de enviar"),

  /// Show invitations where at least one guest confirmed
  confirmed("Con confirmados"),

  /// Show invitations with pending responses
  pending("Por responder"),

  /// Show invitations where all guests declined
  declined("Declinadas");

  const InvitationFilterStatus(this.label);

  /// User-facing label
  final String label;
}

/// Base state for the Admin Dashboard
sealed class AdminDashboardState extends Equatable {
  const AdminDashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial dashboard state
class AdminDashboardInitial extends AdminDashboardState {
  /// Creates an [AdminDashboardInitial] state
  const AdminDashboardInitial();
}

/// Loading state while fetching invitations
class AdminDashboardLoading extends AdminDashboardState {
  /// Creates an [AdminDashboardLoading] state
  const AdminDashboardLoading();
}

/// Loaded state with all invitations and filtering capabilities
class AdminDashboardLoaded extends AdminDashboardState {
  /// Creates an [AdminDashboardLoaded] state
  const AdminDashboardLoaded({
    required this.invitations,
    this.searchQuery = "",
    this.selectedFilter = InvitationFilterStatus.all,
    this.isPerformingAction = false,
    this.actionSuccessMessage,
  });

  /// All retrieved invitations
  final List<InvitationEntity> invitations;

  /// Current search query string
  final String searchQuery;

  /// Selected filter category
  final InvitationFilterStatus selectedFilter;

  /// Whether an async mutation (create/update/delete) is in flight
  final bool isPerformingAction;

  /// Optional snackbar feedback message
  final String? actionSuccessMessage;

  /// Total number of invitations
  int get totalInvitations => invitations.length;

  /// Total guests across all invitations
  int get totalGuests =>
      invitations.fold(0, (sum, inv) => sum + inv.totalGuests);

  /// Total confirmed guests across all invitations
  int get totalConfirmedGuests =>
      invitations.fold(0, (sum, inv) => sum + inv.attendingGuestsCount);

  /// Total declined guests across all invitations
  int get totalDeclinedGuests =>
      invitations.fold(0, (sum, inv) => sum + inv.declinedGuestsCount);

  /// Total pending guests across all invitations
  int get totalPendingGuests =>
      invitations.fold(0, (sum, inv) => sum + inv.pendingGuestsCount);

  /// Total invitations marked as sent
  int get sentInvitationsCount =>
      invitations.where((inv) => inv.isSent).length;

  /// Total invitations not yet sent
  int get unsentInvitationsCount =>
      invitations.where((inv) => !inv.isSent).length;

  /// Filtered invitations based on search query and status filter
  List<InvitationEntity> get filteredInvitations => invitations.where((inv) {
        // 1. Apply search query
        if (searchQuery.trim().isNotEmpty) {
          final query = searchQuery.toLowerCase().trim();
          final matchesGroup = inv.groupName.toLowerCase().contains(query);
          final matchesSlug = inv.slug.toLowerCase().contains(query);
          final matchesGuest = inv.guests.any(
            (g) =>
                g.fullName.toLowerCase().contains(query) ||
                g.firstName.toLowerCase().contains(query) ||
                g.lastName.toLowerCase().contains(query),
          );

          if (!matchesGroup && !matchesSlug && !matchesGuest) {
            return false;
          }
        }

        // 2. Apply status filter
        switch (selectedFilter) {
          case InvitationFilterStatus.all:
            return true;
          case InvitationFilterStatus.sent:
            return inv.isSent;
          case InvitationFilterStatus.unsent:
            return !inv.isSent;
          case InvitationFilterStatus.confirmed:
            return inv.attendingGuestsCount > 0;
          case InvitationFilterStatus.pending:
            return inv.pendingGuestsCount > 0;
          case InvitationFilterStatus.declined:
            return inv.declinedGuestsCount > 0 &&
                inv.attendingGuestsCount == 0;
        }
      }).toList();

  /// Creates a copy of this state with modified properties
  AdminDashboardLoaded copyWith({
    List<InvitationEntity>? invitations,
    String? searchQuery,
    InvitationFilterStatus? selectedFilter,
    bool? isPerformingAction,
    String? actionSuccessMessage,
  }) =>
      AdminDashboardLoaded(
        invitations: invitations ?? this.invitations,
        searchQuery: searchQuery ?? this.searchQuery,
        selectedFilter: selectedFilter ?? this.selectedFilter,
        isPerformingAction: isPerformingAction ?? this.isPerformingAction,
        actionSuccessMessage: actionSuccessMessage,
      );

  @override
  List<Object?> get props => [
        invitations,
        searchQuery,
        selectedFilter,
        isPerformingAction,
        actionSuccessMessage,
      ];
}

/// Error state if loading or operations fail
class AdminDashboardError extends AdminDashboardState {
  /// Creates an [AdminDashboardError] state
  const AdminDashboardError({required this.failure});

  /// The error failure
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
