
  import "package:get/get.dart"; 
  import "rsvp_controller.dart";

  class RsvpBinding implements Bindings {
    @override
    void dependencies() => Get.lazyPut(() => RsvpController());
  }
  