import "dart:convert";

import "package:cloud_firestore/cloud_firestore.dart";

import "../../../business/entities/invitation_entity.dart";
import "guest_model.dart";

/// Model that transforms the Invitation data from Firestore to the application entity
class InvitationModel extends InvitationEntity {
  /// Creates an [InvitationModel]
  const InvitationModel({
    super.id = "",
    super.groupName = "",
    super.slug = "",
    super.isSent = false,
    super.sentAt,
    super.createdAt,
    super.updatedAt,
    super.guests = const [],
  });

  /// Factory method to create an [InvitationModel] from Firestore document snapshot
  factory InvitationModel.fromFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> doc, [
    List<GuestModel>? guests,
  ]) {
    final data = doc.data() ?? {};
    return InvitationModel.fromMap(
      map: data,
      id: doc.id,
      guests: guests,
    );
  }

  /// Factory method to create an [InvitationModel] instance from a Map and ID
  factory InvitationModel.fromMap({
    required Map<String, dynamic> map,
    required String id,
    List<GuestModel>? guests,
  }) =>
      InvitationModel(
        id: id,
        groupName: map["groupName"] as String? ?? "",
        slug: map["slug"] as String? ?? "",
        isSent: map["isSent"] as bool? ?? false,
        sentAt: _parseDateTime(map["sentAt"]),
        createdAt: _parseDateTime(map["createdAt"]),
        updatedAt: _parseDateTime(map["updatedAt"]),
        guests: guests ?? const [],
      );

  /// Factory method to create an [InvitationModel] instance from an entity
  factory InvitationModel.fromEntity({required InvitationEntity entity}) =>
      InvitationModel(
        id: entity.id,
        groupName: entity.groupName,
        slug: entity.slug,
        isSent: entity.isSent,
        sentAt: entity.sentAt,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        guests: entity.guests
            .map((g) => GuestModel.fromEntity(entity: g))
            .toList(),
      );

  /// Converts the Invitation model instance to a map for Firestore
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      "groupName": groupName,
      "slug": slug,
      "isSent": isSent,
    };
    if (sentAt != null) {
      map["sentAt"] = Timestamp.fromDate(sentAt!);
    }
    if (createdAt != null) {
      map["createdAt"] = Timestamp.fromDate(createdAt!);
    }
    if (updatedAt != null) {
      map["updatedAt"] = Timestamp.fromDate(updatedAt!);
    }
    return map;
  }

  /// Converts the model instance to a JSON string
  String toJson() => jsonEncode(toMap());

  /// Converts the Invitation model instance to a domain entity
  InvitationEntity toEntity() => InvitationEntity(
        id: id,
        groupName: groupName,
        slug: slug,
        isSent: isSent,
        sentAt: sentAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
        guests: guests,
      );

  static DateTime? _parseDateTime(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
