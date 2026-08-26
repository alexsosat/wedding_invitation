import "package:flutter_common_classes/flutter_common_classes.dart";

import "../../business/entities/guest_entity.dart";
import "../../business/use_cases/get_invitation.dart";
import "../../business/use_cases/update_guest_rsvp.dart";
import "../../data/models/params/invitation_params.dart";
import "../../data/models/params/update_guest_rsvp_params.dart";
import "invitation_state.dart";

/// Cubit managing the invitation state and guest RSVP lifecycle
class InvitationCubit extends Cubit<InvitationState> {
  /// Creates an [InvitationCubit]
  InvitationCubit({
    required GetInvitation getInvitation,
    required UpdateGuestRsvp updateGuestRsvp,
  })  : _getInvitation = getInvitation,
        _updateGuestRsvp = updateGuestRsvp,
        super(const InvitationInitial());

  final GetInvitation _getInvitation;
  final UpdateGuestRsvp _updateGuestRsvp;

  /// Loads an invitation by its URL slug
  Future<void> loadInvitationBySlug(String slug) async {
    safeEmit(const InvitationLoading());

    final result = await _getInvitation(
      params: InvitationParams.bySlug(slug),
    );

    result.fold(
      (failure) => safeEmit(InvitationError(failure: failure)),
      (invitation) => safeEmit(InvitationLoaded(invitation: invitation)),
    );
  }

  /// Loads an invitation by its Firestore document ID
  Future<void> loadInvitationById(String id) async {
    safeEmit(const InvitationLoading());

    final result = await _getInvitation(
      params: InvitationParams.byId(id),
    );

    result.fold(
      (failure) => safeEmit(InvitationError(failure: failure)),
      (invitation) => safeEmit(InvitationLoaded(invitation: invitation)),
    );
  }

  /// Updates the RSVP attendance and dietary requirements for a specific guest
  Future<void> updateGuestRsvp(GuestEntity guest) async {
    final currentState = state;
    if (currentState is! InvitationLoaded) {
      return;
    }

    // Optimistically update the guest in the local state so the UI responds immediately
    final optimisticGuests = currentState.invitation.guests.map((g) {
      if (g.id == guest.id) {
        return guest;
      }
      return g;
    }).toList();

    final optimisticInvitation = currentState.invitation.copyWith(
      guests: optimisticGuests,
    );

    safeEmit(
      currentState.copyWith(
        invitation: optimisticInvitation,
        isUpdatingRsvp: true,
        updatingGuestId: guest.id,
        clearMessages: true,
      ),
    );

    final result = await _updateGuestRsvp(
      params: UpdateGuestRsvpParams(guest: guest),
    );

    result.fold(
      (failure) {
        final latestState =
            state is InvitationLoaded ? (state as InvitationLoaded) : currentState;
        safeEmit(
          latestState.copyWith(
            isUpdatingRsvp: false,
            clearUpdatingGuest: true,
            rsvpErrorMessage: failure.message,
          ),
        );
      },
      (_) {
        final latestState =
            state is InvitationLoaded ? (state as InvitationLoaded) : currentState;
        final updatedGuests = latestState.invitation.guests.map((g) {
          if (g.id == guest.id) {
            return guest;
          }
          return g;
        }).toList();

        final updatedInvitation = latestState.invitation.copyWith(
          guests: updatedGuests,
        );

        safeEmit(
          latestState.copyWith(
            invitation: updatedInvitation,
            isUpdatingRsvp: false,
            clearUpdatingGuest: true,
            rsvpUpdateMessage: "Respuesta actualizada con éxito",
          ),
        );
      },
    );
  }

  /// Clears any transient RSVP success or error messages
  void clearRsvpMessages() {
    final currentState = state;
    if (currentState is InvitationLoaded) {
      safeEmit(currentState.copyWith(clearMessages: true));
    }
  }
}
