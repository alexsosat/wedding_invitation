// ignore_for_file: one_member_abstracts

import "package:flutter_common_classes/flutter_common_classes.dart"
    show HttpCallException;
import "package:flutter_common_classes/services/logger/logger_service.dart";
import "package:flutter_flavor/flutter_flavor.dart";
import "package:get/get.dart";

import "../../../../../core/config/environment_config.dart";
import "../../../../shared/data/models/invitation_model.dart";
import "../../models/params/invitation_params.dart";

/// Remote data source for the Invitation collection
abstract class InvitationRemoteDataSource {
  /// Get the invitation by the slug.
  Future<InvitationModel> getInvitation(InvitationParams params);
}

/// Remote data source for the Invitation collection
class InvitationRemoteDataSourceImpl extends GetConnect
    implements InvitationRemoteDataSource {
  /// Remote data source for the Invitation collection
  InvitationRemoteDataSourceImpl();

  final _logger = getLogger("InvitationRemoteDataSource");

  @override
  void onInit() {
    super.onInit();

    httpClient.timeout = const Duration(seconds: 10);
  }

  @override
  Future<InvitationModel> getInvitation(InvitationParams params) async {
    _logger.i("Getting invitation with params: ${params.slug}");

    final environment = FlavorConfig.instance.variables;

    final response = await get(
      "${environment[EnvironmentConfig.apiUrlKey]}/invitations",
      headers: {
        "Authorization": "Bearer ${environment[EnvironmentConfig.apiKeyKey]}",
      },
      query: {
        "populate": "*",
        r"filters[slug][$eq]": params.slug,
      },
    );

    _logger.i("Request headers: ${response.request?.headers}");

    _logger.i("Response: ${response.body}");

    if (response.hasError) {
      _logger.e("Error getting invitation: ${response.bodyString}");
      throw HttpCallException(
        title: "Error al obtener la invitación",
        message: response.bodyString ?? "",
      );
    }

    final data = response.body?["data"];

    if (data == null) {
      _logger.e("No data found for invitation");
      throw HttpCallException(
        title: "Error al obtener la invitación",
        message: "No se encontró la invitación",
      );
    }

    final invitation = List.from(data).first;

    _logger.i("Invitation: $invitation");

    return InvitationModel.fromMap(map: invitation);
  }
}
