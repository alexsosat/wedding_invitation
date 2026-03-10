import "package:flutter_common_classes/constants/classes/params.dart";

import "../../../../invitation/business/entities/guest_rsvp_form_entity.dart";

/// Parameters used to send the RSVP form.
class SendRsvpParams extends Params {
  /// Parameters used to send the RSVP form.
  SendRsvpParams({
    required this.slug,
    required this.responses,
  });

  /// Invitation slug.
  final String slug;

  /// RSVP form responses per guest.
  final List<GuestRsvpFormEntity> responses;
}
