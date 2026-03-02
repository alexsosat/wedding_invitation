// ignore_for_file: one_member_abstracts

import "package:flutter_common_classes/errors/failure.dart";
import "package:fpdart/fpdart.dart";

import "../../../shared/business/entities/invitation_entity.dart";
import "../../data/models/params/invitation_params.dart";

/// Data operations for the Invitation collection
abstract class InvitationRepository {
  /// Get the invitation by the slug.
  Future<Either<Failure, InvitationEntity>> getInvitation(
    InvitationParams params,
  );
}
