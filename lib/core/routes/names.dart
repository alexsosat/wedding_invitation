// ignore_for_file: public_member_api_docs

/// Contains all the routes of the application.
class RoutesNames {
  /// Contains all the routes of the application.
  RoutesNames._();

  static const unknown = "/unknown";

  static String initial(String? tag) => tag == null ? "/:tag" : "/$tag";
  static String invitation(String? tag) =>
      tag == null ? "/invitation/:tag" : "/invitation/$tag";

  static String schedule(String? tag) =>
      tag == null ? "/schedule/:tag" : "/schedule/$tag";

  static String rsvp(String? tag) => tag == null ? "/rsvp/:tag" : "/rsvp/$tag";
}
