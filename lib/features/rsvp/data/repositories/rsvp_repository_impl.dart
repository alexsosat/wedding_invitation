


import "package:flutter_common_classes/errors/failure.dart";
import "package:fpdart/fpdart.dart";

import "../../../../core/errors/error_handler.dart";
import "../../business/repositories/rsvp_repository.dart";
import "../data_sources/remote/rsvp_remote_data_source.dart";
import "../models/params/send_rsvp_params.dart";

/// Data operations for the Rsvp collection
class RsvpRepositoryImpl implements RsvpRepository {
  /// Data operations for the Rsvp collection
  RsvpRepositoryImpl({
    required this.remoteDataSource,
  });

  final RsvpRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, Unit>> sendRsvp(SendRsvpParams params) =>
      ErrorHandler.handleApiCall(
        () async {
          await remoteDataSource.sendRsvp(params);
          return unit;
        },
      );
}
