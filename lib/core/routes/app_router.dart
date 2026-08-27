import "package:auto_route/auto_route.dart";

import "app_router.gr.dart";
import "guards/auth_guard.dart";

/// App router.
@AutoRouterConfig(replaceInRouteName: "Page,Route")
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
          path: "/admin/login",
        ),
        AutoRoute(
          page: AdminDashboardRoute.page,
          path: "/admin",
          guards: [
            AuthGuard(),
          ],
        ),
        AutoRoute(
          page: InvitationRoute.page,
          path: "/invitation",
        ),
        AutoRoute(
          page: DetailsRoute.page,
          path: "/details",
        ),
        AutoRoute(
          page: RsvpRoute.page,
          path: "/rsvp",
        ),
        CustomRoute(
          page: EnvelopeRoute.page,
          path: "/envelope",
          transitionsBuilder: TransitionsBuilders.noTransition,
          duration: Duration.zero,
        ),
        AutoRoute(
          page: HistoryRoute.page,
          path: "/history",
        ),
        AutoRoute(
          page: NotFoundRoute.page,
          path: "/not-found",
        ),
        AutoRoute(
          initial: true,
          page: SplashRoute.page,
          path: "/:slug?",
        ),
      ];
}
