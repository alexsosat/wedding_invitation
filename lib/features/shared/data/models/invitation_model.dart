import "../../business/entities/invitation_entity.dart";
import "guest_model.dart";

/// Model that transforms the Invitation data from the API to the application
/// entity
class InvitationModel extends InvitationEntity {
  /// Model that transforms the Invitation data from the API to the application
  /// entity
  const InvitationModel({
    required super.id,
    required super.documentId,
    required super.slug,
    required super.name,
    required super.guests,
  });

  /// Creates a Invitation model from a map
  factory InvitationModel.fromMap({
    required Map<String, dynamic> map,
  }) =>
      InvitationModel(
        id: map["id"],
        documentId: map["documentId"],
        slug: map["slug"],
        name: map["name"],
        guests: List.from(map["guests"])
            .map((guest) => GuestModel.fromMap(map: guest))
            .toList(),
      );
}
