import "package:cloud_firestore/cloud_firestore.dart";

import "../../../business/entities/guest_entity.dart";

/// Data model representing a Guest DTO for Firestore
class GuestModel extends GuestEntity {
  /// Creates a [GuestModel]
  const GuestModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.attendance,
    required super.dietary,
    required super.invitationId,
    super.phone,
    super.dietaryDetails,
    super.side = GuestSide.none,
    super.isConfirmed = false,
    super.updatedAt,
  });

  /// Creates a [GuestModel] from a Firestore Document Snapshot
  factory GuestModel.fromFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return GuestModel.fromMap(map: data, id: doc.id);
  }

  /// Creates a [GuestModel] from a Map and document ID
  factory GuestModel.fromMap({
    required Map<String, dynamic> map,
    required String id,
  }) =>
      GuestModel(
        id: id,
        firstName: map["firstName"] as String? ?? "",
        lastName: map["lastName"] as String? ?? "",
        phone: map["phone"] as String?,
        attendance: AttendanceStatus.fromString(map["attendance"] as String?),
        dietary: DietaryRequirement.fromString(map["dietary"] as String?),
        dietaryDetails: map["dietaryDetails"] as String?,
        side: GuestSide.fromString(map["side"] as String?),
        invitationId: map["invitationId"] as String? ?? "",
        isConfirmed: map["isConfirmed"] as bool? ??
            map["confirmed"] as bool? ??
            false,
        updatedAt: _parseDateTime(map["updatedAt"]),
      );

  /// Creates a [GuestModel] from a domain [GuestEntity]
  factory GuestModel.fromEntity({required GuestEntity entity}) => GuestModel(
        id: entity.id,
        firstName: entity.firstName,
        lastName: entity.lastName,
        phone: entity.phone,
        attendance: entity.attendance,
        dietary: entity.dietary,
        dietaryDetails: entity.dietaryDetails,
        side: entity.side,
        invitationId: entity.invitationId,
        isConfirmed: entity.isConfirmed,
        updatedAt: entity.updatedAt,
      );

  /// Converts model to Map for Firestore writes
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      "firstName": firstName,
      "lastName": lastName,
      "attendance": attendance.value,
      "dietary": dietary.value,
      "side": side.value,
      "invitationId": invitationId,
      "isConfirmed": isConfirmed,
    };
    if (phone != null && phone!.trim().isNotEmpty) {
      map["phone"] = phone!.trim();
    }
    if (dietaryDetails != null) {
      map["dietaryDetails"] = dietaryDetails;
    }
    if (updatedAt != null) {
      map["updatedAt"] = Timestamp.fromDate(updatedAt!);
    }
    return map;
  }

  /// Converts to Map for RSVP update matching Firestore security rules keys
  Map<String, dynamic> toRsvpUpdateMap() {
    final map = <String, dynamic>{
      "attendance": attendance.value,
      "dietary": dietary.value,
      "updatedAt": FieldValue.serverTimestamp(),
    };
    if (dietaryDetails != null && dietaryDetails!.trim().isNotEmpty) {
      map["dietaryDetails"] = dietaryDetails!.trim();
    } else {
      map["dietaryDetails"] = FieldValue.delete();
    }
    return map;
  }

  /// Converts this model to a domain [GuestEntity]
  GuestEntity toEntity() => GuestEntity(
        id: id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        attendance: attendance,
        dietary: dietary,
        dietaryDetails: dietaryDetails,
        side: side,
        invitationId: invitationId,
        isConfirmed: isConfirmed,
        updatedAt: updatedAt,
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
