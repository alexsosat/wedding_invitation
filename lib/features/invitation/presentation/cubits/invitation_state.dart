import "package:equatable/equatable.dart";
import "package:flutter_common_classes/errors/failure.dart";

import "../../business/entities/invitation_entity.dart";

/// Base state for [InvitationCubit]
abstract class InvitationState extends Equatable {
  /// Base state constructor
  const InvitationState();

  @override
  List<Object?> get props => [];
}

/// Initial state before fetching invitation
class InvitationInitial extends InvitationState {
  /// Creates an [InvitationInitial] state
  const InvitationInitial();
}

/// Loading state while fetching invitation
class InvitationLoading extends InvitationState {
  /// Creates an [InvitationLoading] state
  const InvitationLoading();
}

/// Success state when invitation is loaded
class InvitationLoaded extends InvitationState {
  /// Creates an [InvitationLoaded] state
  const InvitationLoaded({
    required this.invitation,
    this.isUpdatingRsvp = false,
    this.updatingGuestId,
    this.rsvpUpdateMessage,
    this.rsvpErrorMessage,
  });

  /// The loaded invitation entity
  final InvitationEntity invitation;

  /// Whether an RSVP update is currently in progress
  final bool isUpdatingRsvp;

  /// ID of the specific guest being updated
  final String? updatingGuestId;

  /// Optional message if RSVP was updated successfully
  final String? rsvpUpdateMessage;

  /// Optional error message if RSVP update failed
  final String? rsvpErrorMessage;

  /// Creates a copy of [InvitationLoaded] with modified properties
  InvitationLoaded copyWith({
    InvitationEntity? invitation,
    bool? isUpdatingRsvp,
    String? updatingGuestId,
    String? rsvpUpdateMessage,
    String? rsvpErrorMessage,
    bool clearUpdatingGuest = false,
    bool clearMessages = false,
  }) =>
      InvitationLoaded(
        invitation: invitation ?? this.invitation,
        isUpdatingRsvp: isUpdatingRsvp ?? this.isUpdatingRsvp,
        updatingGuestId: clearUpdatingGuest
            ? null
            : (updatingGuestId ?? this.updatingGuestId),
        rsvpUpdateMessage: clearMessages
            ? null
            : (rsvpUpdateMessage ?? this.rsvpUpdateMessage),
        rsvpErrorMessage: clearMessages
            ? null
            : (rsvpErrorMessage ?? this.rsvpErrorMessage),
      );

  @override
  List<Object?> get props => [
        invitation,
        isUpdatingRsvp,
        updatingGuestId,
        rsvpUpdateMessage,
        rsvpErrorMessage,
      ];
}

/// Error state when fetching or updating fails
class InvitationError extends InvitationState {
  /// Creates an [InvitationError] state
  const InvitationError({required this.failure});

  /// The failure containing error details
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
