import "package:auto_route/auto_route.dart";

import "app_router.gr.dart";

/// App router.
@AutoRouterConfig(replaceInRouteName: "Page,Route")
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: SplashRoute.page,
        ),
        AutoRoute(
          page: EnvelopeRoute.page,
        ),
        AutoRoute(
          page: InvitationRoute.page,
        ),
        AutoRoute(
          page: DetailsRoute.page,
        ),
        AutoRoute(
          page: LoginRoute.page,
          path: "/admin/login",
        ),
        AutoRoute(
          page: AdminDashboardRoute.page,
          path: "/admin",
        ),
      ];
}
