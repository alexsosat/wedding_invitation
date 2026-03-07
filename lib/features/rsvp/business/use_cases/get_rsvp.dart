import "package:flutter_common_classes/constants/classes/use_case.dart";
import "package:flutter_common_classes/errors/failure.dart";
import "package:fpdart/fpdart.dart";

import "../../data/models/params/rsvp_params.dart";
import "../entities/rsvp_entity.dart";
import "../repositories/rsvp_repository.dart";

/// Retrieves the RSVP by the guest slug.
class GetRsvp extends UseCaseAsync<RsvpEntity, RsvpParams> {
  /// Retrieves the RSVP by the guest slug.
  GetRsvp({required this.rsvpRepository});

  /// Retrieves the RSVP by the guest slug.
  final RsvpRepository rsvpRepository;
  @override
  Future<Either<Failure, RsvpEntity>> call({
    required RsvpParams params,
  }) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
