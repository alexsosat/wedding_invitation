import "package:equatable/equatable.dart";

import "guest_entity.dart";

/// Entity that contains the data of the Invitation.
class InvitationEntity extends Equatable {
  /// Creates an [InvitationEntity]
  const InvitationEntity({
    this.id = "",
    this.groupName = "",
    this.slug = "",
    this.isSent = false,
    this.sentAt,
    this.createdAt,
    this.updatedAt,
    this.guests = const [],
  });

  /// Unique identifier of the invitation in Firestore
  final String id;

  /// The name of the invitation group (e.g. "Familia Sosa")
  final String groupName;

  /// Unique URL-friendly slug to identify the invitation link
  final String slug;

  /// Whether this invitation has been sent to the guests
  final bool isSent;

  /// Timestamp when the invitation was sent
  final DateTime? sentAt;

  /// Creation timestamp
  final DateTime? createdAt;

  /// Last update timestamp
  final DateTime? updatedAt;

  /// List of guests belonging to this invitation
  final List<GuestEntity> guests;

  /// Total number of guests in this invitation
  int get totalGuests => guests.length;

  /// Number of attending guests
  int get attendingGuestsCount =>
      guests.where((g) => g.attendance == AttendanceStatus.attending).length;

  /// Number of declined guests
  int get declinedGuestsCount =>
      guests.where((g) => g.attendance == AttendanceStatus.notAttending).length;

  /// Number of pending guests
  int get pendingGuestsCount =>
      guests.where((g) => g.attendance == AttendanceStatus.pending).length;

  /// Whether all guests have responded
  bool get hasAllResponded =>
      guests.isNotEmpty &&
      guests.every((g) => g.attendance != AttendanceStatus.pending);

  /// Creates a copy of this entity with the given fields replaced
  InvitationEntity copyWith({
    String? id,
    String? groupName,
    String? slug,
    bool? isSent,
    DateTime? sentAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<GuestEntity>? guests,
  }) =>
      InvitationEntity(
        id: id ?? this.id,
        groupName: groupName ?? this.groupName,
        slug: slug ?? this.slug,
        isSent: isSent ?? this.isSent,
        sentAt: sentAt ?? this.sentAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        guests: guests ?? this.guests,
      );

  @override
  List<Object?> get props => [
        id,
        groupName,
        slug,
        isSent,
        sentAt,
        createdAt,
        updatedAt,
        guests,
      ];

  @override
  bool get stringify => true;
}
