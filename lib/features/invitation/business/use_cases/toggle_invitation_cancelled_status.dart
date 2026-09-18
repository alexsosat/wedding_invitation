import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";

import "../../data/models/params/admin_invitation_params.dart";
import "../repositories/invitation_repository.dart";

/// Use case to toggle the cancelled status of an invitation
class ToggleInvitationCancelledStatus
    extends UseCaseAsync<Unit, ToggleInvitationCancelledParams> {
  /// Creates a [ToggleInvitationCancelledStatus] usecase instance
  ToggleInvitationCancelledStatus({required this.invitationRepository});

  /// Repository providing invitation operations
  final InvitationRepository invitationRepository;

  @override
  Future<Either<Failure, Unit>> call({
    required ToggleInvitationCancelledParams params,
  }) =>
      invitationRepository.toggleInvitationCancelledStatus(
        invitationId: params.invitationId,
        isCancelled: params.isCancelled,
      );
}
