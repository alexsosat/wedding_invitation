import "package:get/get_navigation/src/routes/get_route.dart";
import "package:get/get_navigation/src/routes/transitions_type.dart";

import "../../features/intro/presentation/pages/intro_page.dart";
import "../../features/invitation/presentation/getX/invitation_binding.dart";
import "../../features/invitation/presentation/pages/invitation_page.dart";
import "names.dart";

/// App router.
class AppRouter {
  /// App router.
  AppRouter._();

  /// Get the routes of the application.
  static List<GetPage> get routes => [
        GetPage(
          name: RoutesNames.initial(null),
          binding: InvitationBinding(),
          transition: Transition.fade,
          page: () => const IntroPage(),
        ),
        GetPage(
          name: RoutesNames.invitation(null),
          binding: InvitationBinding(),
          transition: Transition.fade,
          page: () => const InvitationPage(),
        ),
      ];
}
