// ignore_for_file: one_member_abstracts

import "package:flutter_common_classes/flutter_common_classes.dart"
    show ClientErrorException, HttpCallException;
import "package:flutter_common_classes/services/logger/logger_service.dart";
import "package:flutter_flavor/flutter_flavor.dart";
import "package:get/get.dart";

import "../../../../../core/adapters/dio_adapter.dart";
import "../../../../../core/config/environment_config.dart";
import "../../../../shared/data/models/invitation_model.dart";
import "../../models/params/invitation_params.dart";

/// Remote data source for the Invitation collection
abstract class InvitationRemoteDataSource {
  /// Get the invitation by the slug.
  Future<InvitationModel> getInvitation(InvitationParams params);
}

/// Remote data source for the Invitation collection
class InvitationRemoteDataSourceImpl implements InvitationRemoteDataSource {
  /// Remote data source for the Invitation collection
  InvitationRemoteDataSourceImpl({
    required this.dio,
  });

  /// Dio instance
  final DioAdapter dio;

  final _logger = getLogger("InvitationRemoteDataSource");

  @override
  Future<InvitationModel> getInvitation(InvitationParams params) async {
    _logger.i("Getting invitation with params: ${params.slug}");

    final response = await dio.get(
      "/invitations",
      queryParameters: {
        "populate": "*",
        r"filters[slug][$eq]": params.slug,
      },
    );

    _logger.i("Response: ${response.data}");

    final data = response.data?["data"];

    if (data == null) {
      _logger.e("No data found for invitation");
      throw ClientErrorException.badRequest(
        title: "Error al obtener la invitación",
        message: "No se encontró la invitación",
      );
    }

    final invitation = List.from(data).first;

    _logger.i("Invitation: $invitation");

    return InvitationModel.fromMap(map: invitation);
  }
}
