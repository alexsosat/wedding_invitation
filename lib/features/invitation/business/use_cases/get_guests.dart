import "package:flutter_common_classes/flutter_common_classes.dart";

import "../entities/guest_entity.dart";
import "../repositories/invitation_repository.dart";

/// Parameters for [GetGuests] use case
class GetGuestsParams extends Params {
  /// Creates a [GetGuestsParams]
  GetGuestsParams({required this.invitationId});

  /// Associated invitation ID
  final String invitationId;
}

/// Use case to retrieve all guests belonging to an invitation
class GetGuests extends UseCaseAsync<List<GuestEntity>, GetGuestsParams> {
  /// Creates a [GetGuests] use case
  GetGuests({required this.invitationRepository});

  /// Repository providing invitation and guest operations
  final InvitationRepository invitationRepository;

  @override
  Future<Either<Failure, List<GuestEntity>>> call({
    required GetGuestsParams params,
  }) =>
      invitationRepository.getGuests(invitationId: params.invitationId);
}
