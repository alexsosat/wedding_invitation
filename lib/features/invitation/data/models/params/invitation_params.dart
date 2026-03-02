import "package:flutter_common_classes/constants/classes/params.dart";

/// Parameters used to make the Invitation request.
class InvitationParams extends Params {
  /// Parameters used to make the Invitation request.
  InvitationParams({required this.slug});

  /// Slug of the invitation.
  final String slug;
}
