// ignore_for_file: one_member_abstracts

import "package:flutter_common_classes/errors/failure.dart";
import "package:fpdart/fpdart.dart";

import "../../data/models/params/send_rsvp_params.dart";

/// Data operations for the Rsvp collection
abstract class RsvpRepository {
  /// Sends the RSVP form values.
  Future<Either<Failure, Unit>> sendRsvp(SendRsvpParams params);
}
