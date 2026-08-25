import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";

import "../../data/models/params/update_guest_rsvp_params.dart";
import "../repositories/invitation_repository.dart";

/// Use case to update a single guest's RSVP response in Firestore
class UpdateGuestRsvp extends UseCaseAsync<Unit, UpdateGuestRsvpParams> {
  /// Creates an [UpdateGuestRsvp] use case
  UpdateGuestRsvp({required this.invitationRepository});

  /// Repository providing invitation and guest operations
  final InvitationRepository invitationRepository;

  @override
  Future<Either<Failure, Unit>> call({
    required UpdateGuestRsvpParams params,
  }) =>
      invitationRepository.updateGuestRsvp(guest: params.guest);
}
