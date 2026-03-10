import "../../business/entities/guest_entity.dart";

/// Model that transforms the Guest data from the API to the application
/// entity
class GuestModel extends GuestEntity {
  /// Model that transforms the Guest data from the API to the application
  /// entity
  const GuestModel({
    required super.id,
    required super.documentId,
    required super.name,
  });

  /// Creates a Guest model from a map
  factory GuestModel.fromMap({
    required Map<String, dynamic> map,
  }) =>
      GuestModel(
        id: map["id"],
        documentId: map["documentId"],
        name: map["nombre"],
      );
}
