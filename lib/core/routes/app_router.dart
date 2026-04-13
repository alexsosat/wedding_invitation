import "package:get/get_navigation/src/routes/get_route.dart";
import "package:get/get_navigation/src/routes/transitions_type.dart";

import "../../features/book/presentation/bindings/book_bindings.dart";
import "../../features/book/presentation/pages/book_page.dart";
import "../../features/intro/presentation/getX/intro_binding.dart";
import "../../features/intro/presentation/pages/intro_page.dart";
import "../../features/unknown/presentation/pages/unknown_page.dart";
import "names.dart";

/// App router.
class AppRouter {
  /// App router.
  AppRouter._();

  /// Get the routes of the application.
  static List<GetPage> get routes => [
        GetPage(
          name: RoutesNames.unknown,
          page: () => const UnknownPage(),
        ),
        GetPage(
          name: RoutesNames.initial(null),
          binding: IntroBinding(),
          transition: Transition.fade,
          page: () => const IntroPage(),
        ),
        GetPage(
          name: RoutesNames.invitation(null),
          binding: BookBinding(),
          transition: Transition.fade,
          page: () => const BookPage(),
        ),
      ];
}
