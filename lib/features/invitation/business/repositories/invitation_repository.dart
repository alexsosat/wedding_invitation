import "package:flutter_common_classes/errors/failure.dart";
import "package:fpdart/fpdart.dart";

import "../../data/models/params/invitation_params.dart";
import "../entities/guest_entity.dart";
import "../entities/invitation_entity.dart";

/// Domain interface for Invitation and Guest operations
abstract class InvitationRepository {
  /// Fetches an invitation with its guests using ID or Slug
  Future<Either<Failure, InvitationEntity>> getInvitation({
    required InvitationParams params,
  });

  /// Fetches all invitations stored in the system with their guests
  Future<Either<Failure, List<InvitationEntity>>> getAllInvitations();

  /// Creates a new invitation and adds its initial guest list
  Future<Either<Failure, InvitationEntity>> createInvitation({
    required InvitationEntity invitation,
  });

  /// Updates an existing invitation and its guests
  Future<Either<Failure, InvitationEntity>> updateInvitation({
    required InvitationEntity invitation,
  });

  /// Deletes an invitation and all associated guests
  Future<Either<Failure, Unit>> deleteInvitation({
    required String invitationId,
  });

  /// Toggles the sent status of an invitation
  Future<Either<Failure, Unit>> toggleInvitationSentStatus({
    required String invitationId,
    required bool isSent,
  });

  /// Fetches the list of guests belonging to an invitation
  Future<Either<Failure, List<GuestEntity>>> getGuests({
    required String invitationId,
  });

  /// Updates the RSVP status of a specific guest
  Future<Either<Failure, Unit>> updateGuestRsvp({
    required GuestEntity guest,
  });

  /// Toggles the admin confirmation status of a specific guest
  Future<Either<Failure, Unit>> toggleGuestConfirmationStatus({
    required String invitationId,
    required String guestId,
    required bool isConfirmed,
  });
}
