import "package:flutter_common_classes/flutter_common_classes.dart";

import "../entities/invitation_entity.dart";
import "../repositories/invitation_repository.dart";

/// Use case to retrieve all invitations with their guests
class GetAllInvitations extends UseCaseAsync<List<InvitationEntity>, NoParams> {
  /// Creates a [GetAllInvitations] usecase instance
  GetAllInvitations({required this.invitationRepository});

  /// Repository providing invitation operations
  final InvitationRepository invitationRepository;

  @override
  Future<Either<Failure, List<InvitationEntity>>> call({
    required NoParams params,
  }) =>
      invitationRepository.getAllInvitations();
}
