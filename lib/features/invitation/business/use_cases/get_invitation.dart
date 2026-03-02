import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";

import "../../../shared/business/entities/invitation_entity.dart";
import "../../data/models/params/invitation_params.dart";
import "../repositories/invitation_repository.dart";

/// Use case to get the invitation by the slug.
class GetInvitation extends UseCaseAsync<InvitationEntity, InvitationParams> {
  /// Use case to get the invitation by the slug.
  GetInvitation({required this.invitationRepository});

  /// Repository to get the invitation by the slug.
  final InvitationRepository invitationRepository;

  @override
  Future<Either<Failure, InvitationEntity>> call({
    required InvitationParams params,
  }) =>
      invitationRepository.getInvitation(params);
}
