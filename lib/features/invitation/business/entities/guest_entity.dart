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
  none("none", "No especificado"),

  /// Meat preference
  meat("meat", "Carne"),

  /// Vegetarian option
  vegetarian("vegetarian", "Vegetariano"),

  /// Vegan option
  vegan("vegan", "Vegano");

  const DietaryRequirement(this.value, this.label);

  /// String value matching Firestore schema
  final String value;

  /// Human-readable label in Spanish
  final String label;

  /// Helper to parse string to [DietaryRequirement]
  static DietaryRequirement fromString(String? value) {
    switch (value) {
      case "meat":
        return DietaryRequirement.meat;
      case "vegetarian":
        return DietaryRequirement.vegetarian;
      case "vegan":
      case "custom":
        return DietaryRequirement.vegan;
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
    this.phone,
    this.dietaryDetails,
    this.isConfirmed = false,
    this.updatedAt,
  });

  /// Unique identifier of the guest in Firestore
  final String id;

  /// First name of the guest
  final String firstName;

  /// Last name of the guest
  final String lastName;

  /// Optional contact phone number of the guest
  final String? phone;

  /// Attendance confirmation status
  final AttendanceStatus attendance;

  /// Dietary requirements
  final DietaryRequirement dietary;

  /// Custom dietary details if specified
  final String? dietaryDetails;

  /// Associated invitation ID
  final String invitationId;

  /// Whether the guest invitation details have been verified and confirmed by the administrator
  final bool isConfirmed;

  /// Timestamp of the last update
  final DateTime? updatedAt;

  /// Full name of the guest
  String get fullName => "$firstName $lastName".trim();

  /// Creates a copy with the given fields replaced by the new values
  GuestEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phone,
    AttendanceStatus? attendance,
    DietaryRequirement? dietary,
    String? dietaryDetails,
    String? invitationId,
    bool? isConfirmed,
    DateTime? updatedAt,
  }) =>
      GuestEntity(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phone: phone ?? this.phone,
        attendance: attendance ?? this.attendance,
        dietary: dietary ?? this.dietary,
        dietaryDetails: dietaryDetails ?? this.dietaryDetails,
        invitationId: invitationId ?? this.invitationId,
        isConfirmed: isConfirmed ?? this.isConfirmed,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        phone,
        attendance,
        dietary,
        dietaryDetails,
        invitationId,
        isConfirmed,
        updatedAt,
      ];

  @override
  bool get stringify => true;
}
