import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";

import "../../data/models/params/admin_invitation_params.dart";
import "../repositories/invitation_repository.dart";

/// Use case to delete an invitation and all associated guests
class DeleteInvitation extends UseCaseAsync<Unit, DeleteInvitationParams> {
  /// Creates a [DeleteInvitation] usecase instance
  DeleteInvitation({required this.invitationRepository});

  /// Repository providing invitation operations
  final InvitationRepository invitationRepository;

  @override
  Future<Either<Failure, Unit>> call({
    required DeleteInvitationParams params,
  }) =>
      invitationRepository.deleteInvitation(
        invitationId: params.invitationId,
      );
}
