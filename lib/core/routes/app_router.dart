import "package:get/get_navigation/src/routes/get_route.dart";
import "package:get/get_navigation/src/routes/transitions_type.dart";

import "../../features/intro/presentation/getX/intro_binding.dart";
import "../../features/intro/presentation/pages/intro_page.dart";
import "../../features/invitation/presentation/getX/invitation_binding.dart";
import "../../features/invitation/presentation/pages/invitation_page.dart";
import "../../features/rsvp/presentation/getX/rsvp_binding.dart";
import "../../features/rsvp/presentation/pages/rsvp_page.dart";
import "../../features/schedule/presentation/getX/schedule_binding.dart";
import "../../features/schedule/presentation/pages/schedule_page.dart";
import "../../features/shared/presentation/getX/auth_middleware.dart";
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
          binding: InvitationBinding(),
          transition: Transition.fade,
          middlewares: [
            AuthMiddleware(),
          ],
          page: () => const InvitationPage(),
        ),
        GetPage(
          name: RoutesNames.schedule(null),
          binding: ScheduleBinding(),
          transition: Transition.fade,
          page: () => const SchedulePage(),
        ),
        GetPage(
          name: RoutesNames.rsvp(null),
          binding: RsvpBinding(),
          transition: Transition.fade,
          page: () => const RsvpPage(),
        ),
      ];
}
