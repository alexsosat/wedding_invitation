import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";

import "../../data/models/params/send_rsvp_params.dart";
import "../repositories/rsvp_repository.dart";

/// Use case to send the RSVP form values.
class SendRsvp extends UseCaseAsync<Unit, SendRsvpParams> {
  /// Use case to send the RSVP form values.
  SendRsvp({required this.rsvpRepository});

  /// Repository to send the RSVP.
  final RsvpRepository rsvpRepository;

  @override
  Future<Either<Failure, Unit>> call({
    required SendRsvpParams params,
  }) =>
      rsvpRepository.sendRsvp(params);
}
