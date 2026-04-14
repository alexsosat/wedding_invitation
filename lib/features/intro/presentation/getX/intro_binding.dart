import "package:get/get.dart";
import "../../../invitation/presentation/getX/invitation_controller.dart";
import "intro_controller.dart";

/// Binding for the InvitationController.
class IntroBinding implements Bindings {
  /// Binding for the InvitationController.
  @override
  void dependencies() {
    Get
      ..lazyPut(
        InvitationController.new,
        fenix: true,
      )
      ..lazyPut(
        IntroController.new,
      );
  }
}
