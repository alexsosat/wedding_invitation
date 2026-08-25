import "package:flutter_common_classes/flutter_common_classes.dart";

import "../../data/models/params/admin_invitation_params.dart";
import "../entities/invitation_entity.dart";
import "../repositories/invitation_repository.dart";

/// Use case to create a new invitation
class CreateInvitation
    extends UseCaseAsync<InvitationEntity, CreateInvitationParams> {
  /// Creates a [CreateInvitation] use case instance
  CreateInvitation({required this.invitationRepository});

  /// Repository providing invitation operations
  final InvitationRepository invitationRepository;

  @override
  Future<Either<Failure, InvitationEntity>> call({
    required CreateInvitationParams params,
  }) =>
      invitationRepository.createInvitation(invitation: params.invitation);
}
