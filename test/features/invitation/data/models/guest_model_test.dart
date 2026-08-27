import "package:boda_ma/features/invitation/business/entities/guest_entity.dart";
import "package:boda_ma/features/invitation/data/models/dtos/guest_model.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("GuestModel & GuestEntity", () {
    test("GuestEntity defaults isConfirmed to false", () {
      const entity = GuestEntity(
        id: "g1",
        firstName: "Alejandro",
        lastName: "Sosa",
        attendance: AttendanceStatus.attending,
        dietary: DietaryRequirement.meat,
        invitationId: "inv1",
      );

      expect(entity.isConfirmed, isFalse);
    });

    test("GuestEntity copyWith updates isConfirmed", () {
      const entity = GuestEntity(
        id: "g1",
        firstName: "Alejandro",
        lastName: "Sosa",
        attendance: AttendanceStatus.attending,
        dietary: DietaryRequirement.meat,
        invitationId: "inv1",
        isConfirmed: false,
      );

      final updated = entity.copyWith(isConfirmed: true);
      expect(updated.isConfirmed, isTrue);
      expect(updated.firstName, equals("Alejandro"));
    });

    test("GuestModel fromMap parses isConfirmed correctly", () {
      final map = {
        "firstName": "Mayte",
        "lastName": "López",
        "phone": "+52 123 456 7890",
        "attendance": "Attending",
        "dietary": "vegetarian",
        "dietaryDetails": "Sin gluten",
        "invitationId": "inv1",
        "isConfirmed": true,
      };

      final model = GuestModel.fromMap(map: map, id: "g2");
      expect(model.isConfirmed, isTrue);
      expect(model.fullName, equals("Mayte López"));
      expect(model.dietary, equals(DietaryRequirement.vegetarian));
    });

    test("GuestModel fromMap defaults isConfirmed to false when missing", () {
      final map = {
        "firstName": "Mayte",
        "lastName": "López",
        "attendance": "Pending",
        "dietary": "none",
        "invitationId": "inv1",
      };

      final model = GuestModel.fromMap(map: map, id: "g2");
      expect(model.isConfirmed, isFalse);
    });

    test("GuestModel toMap serializes isConfirmed", () {
      const model = GuestModel(
        id: "g1",
        firstName: "Alejandro",
        lastName: "Sosa",
        attendance: AttendanceStatus.attending,
        dietary: DietaryRequirement.meat,
        invitationId: "inv1",
        isConfirmed: true,
      );

      final map = model.toMap();
      expect(map["isConfirmed"], isTrue);
      expect(map["firstName"], equals("Alejandro"));
    });

    test("GuestModel toRsvpUpdateMap excludes isConfirmed for security", () {
      const model = GuestModel(
        id: "g1",
        firstName: "Alejandro",
        lastName: "Sosa",
        attendance: AttendanceStatus.attending,
        dietary: DietaryRequirement.meat,
        invitationId: "inv1",
        isConfirmed: true,
      );

      final rsvpMap = model.toRsvpUpdateMap();
      expect(rsvpMap.containsKey("isConfirmed"), isFalse);
      expect(rsvpMap.containsKey("attendance"), isTrue);
      expect(rsvpMap.containsKey("dietary"), isTrue);
      expect(rsvpMap.containsKey("updatedAt"), isTrue);
    });
  });
}
