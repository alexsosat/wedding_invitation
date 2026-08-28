import "package:boda_ma/features/invitation/business/entities/guest_entity.dart";
import "package:boda_ma/features/invitation/business/entities/invitation_entity.dart";
import "package:boda_ma/features/invitation/business/use_cases/export_guests_to_excel.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  late ExportGuestsToExcel exportGuestsToExcel;

  setUp(() {
    exportGuestsToExcel = ExportGuestsToExcel();
  });

  test("generates valid Excel bytes with correct data and formatting", () {
    const invitations = [
      InvitationEntity(
        id: "inv_1",
        groupName: "Familia Sosa",
        slug: "familia-sosa",
        guests: [
          GuestEntity(
            id: "g1",
            firstName: "Alejandro",
            lastName: "Sosa",
            phone: "+52 123 456 7890",
            attendance: AttendanceStatus.attending,
            dietary: DietaryRequirement.meat,
            dietaryDetails: "Sin cebolla",
            side: GuestSide.groom,
            invitationId: "inv_1",
            isConfirmed: true,
          ),
          GuestEntity(
            id: "g2",
            firstName: "Mayte",
            lastName: "García",
            phone: "+52 098 765 4321",
            attendance: AttendanceStatus.attending,
            dietary: DietaryRequirement.vegetarian,
            dietaryDetails: "Alergia a nueces",
            side: GuestSide.bride,
            invitationId: "inv_1",
            isConfirmed: false,
          ),
        ],
      ),
      InvitationEntity(
        id: "inv_2",
        groupName: "Familia Gómez",
        slug: "familia-gomez",
        guests: [
          GuestEntity(
            id: "g3",
            firstName: "Carlos",
            lastName: "Gómez",
            attendance: AttendanceStatus.notAttending,
            dietary: DietaryRequirement.vegan,
            side: GuestSide.both,
            invitationId: "inv_2",
            isConfirmed: true,
          ),
          GuestEntity(
            id: "g4",
            firstName: "Lucía",
            lastName: "Gómez",
            attendance: AttendanceStatus.pending,
            dietary: DietaryRequirement.none,
            side: GuestSide.none,
            invitationId: "inv_2",
            isConfirmed: false,
          ),
        ],
      ),
    ];

    final result = exportGuestsToExcel(
      params: const ExportGuestsToExcelParams(invitations: invitations),
    );

    expect(result.isRight(), isTrue);
    final bytes = result.getOrElse((_) => []);
    expect(bytes, isNotEmpty);
    // Excel files are zip archives and typically start with PK (0x50, 0x4B)
    expect(bytes.length, greaterThan(100));
    expect(bytes[0], equals(0x50));
    expect(bytes[1], equals(0x4B));
  });

  test("handles empty invitations list gracefully", () {
    final result = exportGuestsToExcel(
      params: const ExportGuestsToExcelParams(invitations: []),
    );

    expect(result.isRight(), isTrue);
    final bytes = result.getOrElse((_) => []);
    expect(bytes, isNotEmpty);
  });
}
