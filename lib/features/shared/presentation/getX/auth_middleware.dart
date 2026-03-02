import "package:flutter/widgets.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:get/get.dart";

import "../../../../core/routes/names.dart";
import "../../../invitation/presentation/getX/invitation_controller.dart";

/// Middleware to check if the invitation is populated
class AuthMiddleware extends GetMiddleware {
  final _logger = getLogger("AuthMiddleware");

  /// Middleware to check if the invitation is populated.
  @override
  RouteSettings? redirect(String? route) {
    try {
      final invitation = Get.find<InvitationController>();

      if (invitation.state == null) {
        _logger.e("Invitation is not populated");
        return const RouteSettings(name: RoutesNames.unknown);
      }

      final tag = Get.parameters["tag"];

      if (tag == null || tag.isEmpty || tag == ":invitation") {
        _logger.e("Tag is not valid");
        return const RouteSettings(name: RoutesNames.unknown);
      }

      if (tag != invitation.state?.slug) {
        _logger.e("Tag is not the same as the invitation slug");
        return const RouteSettings(name: RoutesNames.unknown);
      }

      return null;
    } catch (e) {
      _logger.e("Error in auth middleware: $e");
      return const RouteSettings(name: RoutesNames.unknown);
    }
  }
}
