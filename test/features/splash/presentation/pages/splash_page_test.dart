import "package:boda_ma/core/routes/app_router.dart";
import "package:boda_ma/core/routes/app_router.gr.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("AppRouter Route Matching & Slug Parsing", () {
    late AppRouter router;

    setUp(() {
      router = AppRouter();
    });

    test("root path '/' matches SplashRoute", () {
      final match = router.matcher.match("/");
      expect(match, isNotNull);
      expect(match!.first.name, equals(SplashRoute.name));
    });

    test("slug path '/sosa-trejo' matches SplashRoute with slug parameter", () {
      final match = router.matcher.match("/sosa-trejo");
      expect(match, isNotNull);
      expect(match!.first.name, equals(SplashRoute.name));
      expect(match.first.params.optString("slug?"), equals("sosa-trejo"));
    });

    test("slug path '/familia-sosa-trejo' matches SplashRoute with slug", () {
      final match = router.matcher.match("/familia-sosa-trejo");
      expect(match, isNotNull);
      expect(match!.first.name, equals(SplashRoute.name));
      expect(
        match.first.params.optString("slug?"),
        equals("familia-sosa-trejo"),
      );
    });

    test("admin paths are prioritized over slug parameter", () {
      final adminMatch = router.matcher.match("/admin");
      expect(adminMatch, isNotNull);
      expect(adminMatch!.first.name, equals(AdminDashboardRoute.name));

      final loginMatch = router.matcher.match("/admin/login");
      expect(loginMatch, isNotNull);
      expect(loginMatch!.first.name, equals(LoginRoute.name));
    });

    test("static feature paths are matched correctly", () {
      final invitationMatch = router.matcher.match("/invitation");
      expect(invitationMatch, isNotNull);
      expect(invitationMatch!.first.name, equals(InvitationRoute.name));

      final detailsMatch = router.matcher.match("/details");
      expect(detailsMatch, isNotNull);
      expect(detailsMatch!.first.name, equals(DetailsRoute.name));

      final rsvpMatch = router.matcher.match("/rsvp");
      expect(rsvpMatch, isNotNull);
      expect(rsvpMatch!.first.name, equals(RsvpRoute.name));

      final envelopeMatch = router.matcher.match("/envelope");
      expect(envelopeMatch, isNotNull);
      expect(envelopeMatch!.first.name, equals(EnvelopeRoute.name));

      final notFoundMatch = router.matcher.match("/not-found");
      expect(notFoundMatch, isNotNull);
      expect(notFoundMatch!.first.name, equals(NotFoundRoute.name));
    });
  });
}
