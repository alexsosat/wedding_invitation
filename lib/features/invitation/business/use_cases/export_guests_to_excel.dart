import "package:equatable/equatable.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:syncfusion_flutter_xlsio/xlsio.dart";

import "../../../../core/errors/failures.dart";
import "../entities/guest_entity.dart";
import "../entities/invitation_entity.dart";

/// Parameters for exporting guests to Excel
class ExportGuestsToExcelParams extends Equatable {
  /// Creates an [ExportGuestsToExcelParams] instance
  const ExportGuestsToExcelParams({required this.invitations});

  /// List of invitations with guests to export
  final List<InvitationEntity> invitations;

  @override
  List<Object?> get props => [invitations];
}

/// Use case to generate an Excel file (.xlsx) from invitations' guests
class ExportGuestsToExcel
    extends UseCase<List<int>, ExportGuestsToExcelParams> {
  /// Creates an [ExportGuestsToExcel] instance
  ExportGuestsToExcel();

  @override
  Either<Failure, List<int>> call({
    required ExportGuestsToExcelParams params,
  }) {
    try {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0]
        ..name = "Invitados"
        ..showGridlines = true;

      // Header labels
      final headers = [
        "Nombre Completo",
        "Teléfono",
        "Asistencia (RSVP)",
        "Confirmado Admin",
        "Opción Dietética",
        "Detalles de Dieta",
      ];

      // Set headers
      for (int i = 0; i < headers.length; i++) {
        sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
      }

      // Header row styling
      final Range headerRange = sheet.getRangeByIndex(1, 1, 1, headers.length);
      headerRange.cellStyle
        ..backColor = "#30405F"
        ..fontColor = "#FFFFFF"
        ..bold = true
        ..fontSize = 11
        ..hAlign = HAlignType.center
        ..vAlign = VAlignType.center;
      sheet.getRangeByIndex(1, 1).rowHeight = 28;

      int currentRow = 2;
      for (final invitation in params.invitations) {
        for (final guest in invitation.guests) {
          sheet.getRangeByIndex(currentRow, 1).rowHeight = 22;

          // 1. Full Name
          final guestFullName = guest.fullName.isNotEmpty
              ? guest.fullName
              : "${guest.firstName} ${guest.lastName}".trim();
          final nameCell = sheet.getRangeByIndex(currentRow, 1)
            ..setText(guestFullName.isNotEmpty ? guestFullName : "-");
          nameCell.cellStyle.vAlign = VAlignType.center;

          // 2. Phone
          final phoneCell = sheet.getRangeByIndex(currentRow, 2)
            ..setText(
              guest.phone != null && guest.phone!.isNotEmpty
                  ? guest.phone!
                  : "-",
            );
          phoneCell.cellStyle
            ..hAlign = HAlignType.center
            ..vAlign = VAlignType.center;

          // 3. Attendance Status
          final attendanceCell = sheet.getRangeByIndex(currentRow, 3);
          attendanceCell.cellStyle
            ..hAlign = HAlignType.center
            ..vAlign = VAlignType.center;
          switch (guest.attendance) {
            case AttendanceStatus.attending:
              attendanceCell.setText("Confirmado");
              attendanceCell.cellStyle
                ..backColor = "#D4EDDA"
                ..fontColor = "#155724"
                ..bold = true;
            case AttendanceStatus.notAttending:
              attendanceCell.setText("Declinado");
              attendanceCell.cellStyle
                ..backColor = "#F8D7DA"
                ..fontColor = "#721C24"
                ..bold = true;
            case AttendanceStatus.pending:
              attendanceCell.setText("Pendiente");
              attendanceCell.cellStyle
                ..backColor = "#FFF3CD"
                ..fontColor = "#856404";
          }

          // 4. Admin Confirmation Status
          final confirmedCell = sheet.getRangeByIndex(currentRow, 4);
          confirmedCell.cellStyle
            ..hAlign = HAlignType.center
            ..vAlign = VAlignType.center;
          if (guest.isConfirmed) {
            confirmedCell.setText("Confirmado");
            confirmedCell.cellStyle
              ..backColor = "#D4EDDA"
              ..fontColor = "#155724"
              ..bold = true;
          } else {
            confirmedCell.setText("Pendiente");
            confirmedCell.cellStyle
              ..backColor = "#F2F2F2"
              ..fontColor = "#595959";
          }

          // 5. Dietary Option
          final dietaryCell = sheet.getRangeByIndex(currentRow, 5);
          dietaryCell.cellStyle
            ..hAlign = HAlignType.center
            ..vAlign = VAlignType.center;
          switch (guest.dietary) {
            case DietaryRequirement.meat:
              dietaryCell.setText("Carne");
              dietaryCell.cellStyle
                ..backColor = "#FCE4D6"
                ..fontColor = "#833C0C";
            case DietaryRequirement.vegetarian:
              dietaryCell.setText("Vegetariano");
              dietaryCell.cellStyle
                ..backColor = "#E2EFDA"
                ..fontColor = "#375623";
            case DietaryRequirement.vegan:
              dietaryCell.setText("Vegano");
              dietaryCell.cellStyle
                ..backColor = "#C6E0B4"
                ..fontColor = "#1E4D2B";
            case DietaryRequirement.none:
              dietaryCell.setText("No especificado");
              dietaryCell.cellStyle
                ..backColor = "#F2F2F2"
                ..fontColor = "#595959";
          }

          // 6. Dietary Details
          final detailsCell = sheet.getRangeByIndex(currentRow, 6)
            ..setText(
              guest.dietaryDetails != null && guest.dietaryDetails!.isNotEmpty
                  ? guest.dietaryDetails!
                  : "-",
            );
          detailsCell.cellStyle.vAlign = VAlignType.center;

          currentRow++;
        }
      }

      final int totalRows = currentRow - 1;

      // Add AutoFilter to enable native Excel column filters
      if (totalRows >= 1) {
        sheet.autoFilters.filterRange =
            sheet.getRangeByIndex(1, 1, totalRows, headers.length);
      }

      // Auto-fit all columns for readability
      sheet
          .getRangeByIndex(1, 1, totalRows >= 2 ? totalRows : 2, headers.length)
          .autoFitColumns();

      // Ensure minimum readable column widths
      final defaultWidths = [24.0, 16.0, 18.0, 18.0, 20.0, 26.0];
      for (int i = 0; i < defaultWidths.length; i++) {
        final currentWidth = sheet.getRangeByIndex(1, i + 1).columnWidth;
        if (currentWidth < defaultWidths[i]) {
          sheet.getRangeByIndex(1, i + 1).columnWidth = defaultWidths[i];
        }
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      return Right(bytes);
    } catch (e) {
      return Left(
        ServerFailure(
          message: "Error al generar el archivo Excel: $e",
        ),
      );
    }
  }
}
