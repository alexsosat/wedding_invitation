import "package:equatable/equatable.dart";

import "guest_entity.dart";

/// Entity that contains the invitation values.
class InvitationEntity extends Equatable {
  /// Entity that contains the invitation values.
  const InvitationEntity({
    required this.id,
    required this.documentId,
    required this.slug,
    required this.name,
    required this.guests,
  });

  /// Identifier of the invitation.
  final int id;

  /// Identifier of the invitation in the database.
  final String documentId;

  /// Slug of the invitation.
  final String slug;

  /// Name of the invitation.
  final String name;

  /// Guests of the invitation.
  final List<GuestEntity> guests;

  @override
  List<Object?> get props => [id, documentId, name];

  @override
  bool get stringify => true;
}
