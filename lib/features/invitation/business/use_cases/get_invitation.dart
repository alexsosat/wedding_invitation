import "package:flutter_common_classes/flutter_common_classes.dart";

import "../../data/models/params/invitation_params.dart";
import "../entities/invitation_entity.dart";
import "../repositories/invitation_repository.dart";

/// Use case to retrieve an invitation by ID or Slug
class GetInvitation extends UseCaseAsync<InvitationEntity, InvitationParams> {
  /// Creates a [GetInvitation] usecase instance
  GetInvitation({required this.invitationRepository});

  /// Repository providing invitation and guest operations
  final InvitationRepository invitationRepository;

  @override
  Future<Either<Failure, InvitationEntity>> call({
    required InvitationParams params,
  }) =>
      invitationRepository.getInvitation(params: params);
}
