import "package:equatable/equatable.dart";

/// Enum representing the RSVP attendance status
enum AttendanceStatus {
  /// Guest has not yet responded
  pending("Pending"),

  /// Guest confirmed attendance
  attending("Attending"),

  /// Guest declined attendance
  notAttending("Not Attending");

  const AttendanceStatus(this.value);

  /// String value matching Firestore schema
  final String value;

  /// Helper to parse string to [AttendanceStatus]
  static AttendanceStatus fromString(String? value) {
    switch (value) {
      case "Attending":
        return AttendanceStatus.attending;
      case "Not Attending":
        return AttendanceStatus.notAttending;
      case "Pending":
      default:
        return AttendanceStatus.pending;
    }
  }
}

/// Enum representing guest dietary preferences
enum DietaryRequirement {
  /// No special dietary restrictions
  none("none"),

  /// Meat preference
  meat("meat"),

  /// Vegetarian option
  vegetarian("vegetarian"),

  /// Custom dietary requirements
  custom("custom");

  const DietaryRequirement(this.value);

  /// String value matching Firestore schema
  final String value;

  /// Helper to parse string to [DietaryRequirement]
  static DietaryRequirement fromString(String? value) {
    switch (value) {
      case "meat":
        return DietaryRequirement.meat;
      case "vegetarian":
        return DietaryRequirement.vegetarian;
      case "custom":
        return DietaryRequirement.custom;
      case "none":
      default:
        return DietaryRequirement.none;
    }
  }
}

/// Business entity representing a Guest linked to an invitation
class GuestEntity extends Equatable {
  /// Creates a [GuestEntity]
  const GuestEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.attendance,
    required this.dietary,
    required this.invitationId,
    this.dietaryDetails,
    this.updatedAt,
  });

  /// Unique identifier of the guest in Firestore
  final String id;

  /// First name of the guest
  final String firstName;

  /// Last name of the guest
  final String lastName;

  /// Attendance confirmation status
  final AttendanceStatus attendance;

  /// Dietary requirements
  final DietaryRequirement dietary;

  /// Custom dietary details if specified
  final String? dietaryDetails;

  /// Associated invitation ID
  final String invitationId;

  /// Timestamp of the last update
  final DateTime? updatedAt;

  /// Full name of the guest
  String get fullName => "$firstName $lastName".trim();

  /// Creates a copy with the given fields replaced by the new values
  GuestEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    AttendanceStatus? attendance,
    DietaryRequirement? dietary,
    String? dietaryDetails,
    String? invitationId,
    DateTime? updatedAt,
  }) =>
      GuestEntity(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        attendance: attendance ?? this.attendance,
        dietary: dietary ?? this.dietary,
        dietaryDetails: dietaryDetails ?? this.dietaryDetails,
        invitationId: invitationId ?? this.invitationId,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        attendance,
        dietary,
        dietaryDetails,
        invitationId,
        updatedAt,
      ];

  @override
  bool get stringify => true;
}
