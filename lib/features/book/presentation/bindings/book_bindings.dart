import "package:get/get.dart";

import "../getX/book_controller.dart";

/// Binding for the BookController.
class BookBinding implements Bindings {
  /// Binding for the BookController.
  @override
  void dependencies() {
    Get.lazyPut(BookController.new);
  }
}
