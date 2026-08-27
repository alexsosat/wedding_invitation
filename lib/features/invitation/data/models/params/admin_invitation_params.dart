import "package:flutter_common_classes/flutter_common_classes.dart";

import "../../../business/entities/invitation_entity.dart";

/// Parameters for creating a new invitation
class CreateInvitationParams extends Params {
  /// Creates a [CreateInvitationParams] instance
  CreateInvitationParams({required this.invitation});

  /// The invitation entity to create
  final InvitationEntity invitation;
}

/// Parameters for updating an existing invitation
class UpdateInvitationParams extends Params {
  /// Creates an [UpdateInvitationParams] instance
  UpdateInvitationParams({required this.invitation});

  /// The updated invitation entity
  final InvitationEntity invitation;
}

/// Parameters for deleting an invitation
class DeleteInvitationParams extends Params {
  /// Creates a [DeleteInvitationParams] instance
  DeleteInvitationParams({required this.invitationId});

  /// The ID of the invitation to delete
  final String invitationId;
}

/// Parameters for toggling an invitation's sent status
class ToggleInvitationSentParams extends Params {
  /// Creates a [ToggleInvitationSentParams] instance
  ToggleInvitationSentParams({
    required this.invitationId,
    required this.isSent,
  });

  /// The ID of the invitation
  final String invitationId;

  /// The new sent status
  final bool isSent;
}

/// Parameters for toggling a guest's admin confirmation status
class ToggleGuestConfirmationParams extends Params {
  /// Creates a [ToggleGuestConfirmationParams] instance
  ToggleGuestConfirmationParams({
    required this.invitationId,
    required this.guestId,
    required this.isConfirmed,
  });

  /// The ID of the invitation
  final String invitationId;

  /// The ID of the guest
  final String guestId;

  /// The new confirmation status
  final bool isConfirmed;
}
