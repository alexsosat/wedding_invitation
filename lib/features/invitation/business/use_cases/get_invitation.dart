import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";

import "../../data/models/params/invitation_params.dart";
import "../entities/invitation_entity.dart";
import "../repositories/invitation_repository.dart";

class GetInvitation extends UseCaseAsync<InvitationEntity, InvitationParams> {
  final InvitationRepository invitationRepository;

  GetInvitation({required this.invitationRepository});

  @override
  Future<Either<Failure, InvitationEntity>> call({
    required InvitationParams params,
  }) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
