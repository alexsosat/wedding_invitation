import "package:flutter_common_classes/flutter_common_classes.dart";

import "../../data/models/params/admin_invitation_params.dart";
import "../entities/invitation_entity.dart";
import "../repositories/invitation_repository.dart";

/// Use case to update an existing invitation
class UpdateInvitation
    extends UseCaseAsync<InvitationEntity, UpdateInvitationParams> {
  /// Creates an [UpdateInvitation] usecase instance
  UpdateInvitation({required this.invitationRepository});

  /// Repository providing invitation operations
  final InvitationRepository invitationRepository;

  @override
  Future<Either<Failure, InvitationEntity>> call({
    required UpdateInvitationParams params,
  }) =>
      invitationRepository.updateInvitation(invitation: params.invitation);
}
