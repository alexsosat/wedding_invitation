import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";

import "../../data/models/params/admin_invitation_params.dart";
import "../repositories/invitation_repository.dart";

/// Use case to toggle the sent status of an invitation
class ToggleInvitationSentStatus
    extends UseCaseAsync<Unit, ToggleInvitationSentParams> {
  /// Creates a [ToggleInvitationSentStatus] usecase instance
  ToggleInvitationSentStatus({required this.invitationRepository});

  /// Repository providing invitation operations
  final InvitationRepository invitationRepository;

  @override
  Future<Either<Failure, Unit>> call({
    required ToggleInvitationSentParams params,
  }) =>
      invitationRepository.toggleInvitationSentStatus(
        invitationId: params.invitationId,
        isSent: params.isSent,
      );
}
