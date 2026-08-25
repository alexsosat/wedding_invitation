import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";

import "../../../../core/errors/failures.dart";
import "../../business/entities/guest_entity.dart";
import "../../business/entities/invitation_entity.dart";
import "../../business/repositories/invitation_repository.dart";
import "../data_sources/remote/invitation_remote_data_source.dart";
import "../models/dtos/guest_model.dart";
import "../models/dtos/invitation_model.dart";
import "../models/params/invitation_params.dart";

/// Concrete implementation of [InvitationRepository] using [InvitationRemoteDataSource]
class InvitationRepositoryImpl implements InvitationRepository {
  /// Creates an [InvitationRepositoryImpl]
  InvitationRepositoryImpl({
    required this.remoteDataSource,
  });

  /// Remote data source instance for invitation and guest operations
  final InvitationRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, InvitationEntity>> getInvitation({
    required InvitationParams params,
  }) async {
    try {
      final InvitationEntity? result;
      if (params.id != null) {
        result = await remoteDataSource.getInvitationById(params.id!);
      } else if (params.slug != null) {
        result = await remoteDataSource.getInvitationBySlug(params.slug!);
      } else {
        return Left(
          ServerFailure(
            message: "Missing invitation ID or slug parameter",
          ),
        );
      }

      if (result == null) {
        return Left(
          NotFoundFailure(
            message: "Invitation not found",
          ),
        );
      }

      return Right(result);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.message ?? "Firebase error occurred while fetching invitation",
        ),
      );
    } catch (e) {
      return Left(
        AppFailure.unexpected(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<InvitationEntity>>> getAllInvitations() async {
    try {
      final invitations = await remoteDataSource.getAllInvitations();
      return Right(invitations);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.message ?? "Firebase error occurred while fetching invitations",
        ),
      );
    } catch (e) {
      return Left(
        AppFailure.unexpected(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, InvitationEntity>> createInvitation({
    required InvitationEntity invitation,
  }) async {
    try {
      final model = InvitationModel.fromEntity(entity: invitation);
      final created = await remoteDataSource.createInvitation(model);
      return Right(created);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.message ?? "Firebase error occurred while creating invitation",
        ),
      );
    } catch (e) {
      return Left(
        AppFailure.unexpected(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, InvitationEntity>> updateInvitation({
    required InvitationEntity invitation,
  }) async {
    try {
      final model = InvitationModel.fromEntity(entity: invitation);
      final updated = await remoteDataSource.updateInvitation(model);
      return Right(updated);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.message ?? "Firebase error occurred while updating invitation",
        ),
      );
    } catch (e) {
      return Left(
        AppFailure.unexpected(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteInvitation({
    required String invitationId,
  }) async {
    try {
      await remoteDataSource.deleteInvitation(invitationId);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.message ?? "Firebase error occurred while deleting invitation",
        ),
      );
    } catch (e) {
      return Left(
        AppFailure.unexpected(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleInvitationSentStatus({
    required String invitationId,
    required bool isSent,
  }) async {
    try {
      await remoteDataSource.toggleSentStatus(invitationId, isSent);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.message ?? "Firebase error occurred while updating sent status",
        ),
      );
    } catch (e) {
      return Left(
        AppFailure.unexpected(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<GuestEntity>>> getGuests({
    required String invitationId,
  }) async {
    try {
      final guests = await remoteDataSource.getGuests(invitationId);
      return Right(guests);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? "Firebase error occurred while fetching guests",
        ),
      );
    } catch (e) {
      return Left(
        AppFailure.unexpected(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateGuestRsvp({
    required GuestEntity guest,
  }) async {
    try {
      final model = GuestModel.fromEntity(entity: guest);
      await remoteDataSource.updateGuestRsvp(model);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? "Firebase error occurred while updating RSVP",
        ),
      );
    } catch (e) {
      return Left(
        AppFailure.unexpected(
          e.toString(),
        ),
      );
    }
  }
}
