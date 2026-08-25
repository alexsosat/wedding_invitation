import "package:flutter_common_classes/constants/classes/params.dart";

/// Parameters used to fetch an Invitation by ID or Slug
class InvitationParams extends Params {
  /// Parameters used to make the Invitation request.
  InvitationParams({
    this.id,
    this.slug,
  }) : assert(
          id != null || slug != null,
          "Either id or slug must be provided",
        );

  /// Convenient factory to query by ID
  factory InvitationParams.byId(String id) => InvitationParams(id: id);

  /// Convenient factory to query by Slug
  factory InvitationParams.bySlug(String slug) => InvitationParams(slug: slug);

  /// Document ID of the invitation
  final String? id;

  /// Unique URL-friendly slug of the invitation
  final String? slug;
}
