
  import "package:get/get.dart"; 
  import "invitation_controller.dart";

  class InvitationBinding implements Bindings {
    @override
    void dependencies() => Get.lazyPut(() => InvitationController());
  }
  