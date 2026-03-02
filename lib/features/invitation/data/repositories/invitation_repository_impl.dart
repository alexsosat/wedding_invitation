import "package:flutter_common_classes/errors/failure.dart";
import "package:fpdart/fpdart.dart";

import "../../../../core/errors/error_handler.dart";
import "../../../shared/data/models/invitation_model.dart";
import "../../business/repositories/invitation_repository.dart";
import "../data_sources/remote/invitation_remote_data_source.dart";
import "../models/params/invitation_params.dart";

/// Data operations for the Invitation collection
class InvitationRepositoryImpl implements InvitationRepository {
  /// Data operations for the Invitation collection
  InvitationRepositoryImpl({
    required this.remoteDataSource,
  });

  /// Remote data source for the Invitation collection
  final InvitationRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, InvitationModel>> getInvitation(
    InvitationParams params,
  ) =>
      ErrorHandler.handleApiCall(
        () async => remoteDataSource.getInvitation(params),
      );
}
