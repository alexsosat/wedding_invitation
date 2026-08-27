import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";

import "../../data/models/params/admin_invitation_params.dart";
import "../repositories/invitation_repository.dart";

/// Use case to toggle the admin confirmation status of a guest
class ToggleGuestConfirmationStatus
    extends UseCaseAsync<Unit, ToggleGuestConfirmationParams> {
  /// Creates a [ToggleGuestConfirmationStatus] usecase instance
  ToggleGuestConfirmationStatus({required this.invitationRepository});

  /// Repository providing invitation operations
  final InvitationRepository invitationRepository;

  @override
  Future<Either<Failure, Unit>> call({
    required ToggleGuestConfirmationParams params,
  }) =>
      invitationRepository.toggleGuestConfirmationStatus(
        invitationId: params.invitationId,
        guestId: params.guestId,
        isConfirmed: params.isConfirmed,
      );
}
