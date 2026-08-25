import "package:flutter_common_classes/constants/classes/params.dart";

import "../../../business/entities/guest_entity.dart";

/// Parameters used to update a Guest's RSVP status
class UpdateGuestRsvpParams extends Params {
  /// Creates an [UpdateGuestRsvpParams] instance
  UpdateGuestRsvpParams({required this.guest});

  /// The guest entity containing updated RSVP status
  final GuestEntity guest;
}
