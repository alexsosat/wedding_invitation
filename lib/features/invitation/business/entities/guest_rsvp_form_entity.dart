import "package:equatable/equatable.dart";
import "package:flutter/material.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";

import "../../../shared/business/entities/guest_entity.dart";

/// Attendance options for RSVP.
enum AttendanceOption {
  /// Guest will attend.
  willGo("Acepto"),

  /// Guest will not attend.
  wontGo("Declino");

  const AttendanceOption(this.label);

  /// Label of the attendance option.
  final String label;
}

/// Food options for RSVP.
enum FoodOption {
  /// Meat option.
  meat("Carnivora"),

  /// Vegetarian option.
  vegetarian("Vegetariana");

  const FoodOption(this.label);

  /// Label of the food option.
  final String label;
}

/// Entity that holds RSVP form data for a single guest.
class GuestRsvpFormEntity extends Equatable {
  /// Entity that holds RSVP form data for a single guest.
  const GuestRsvpFormEntity({
    required this.guest,
    required this.formKey,
    this.attendance,
    this.food,
  });

  /// The guest this form belongs to.
  final GuestEntity guest;

  /// Global Form Identifier.
  final GlobalKey<FormBuilderState> formKey;

  /// Attendance selection.
  final AttendanceOption? attendance;

  /// Food preference selection.
  final FoodOption? food;

  /// Copy with new values.
  GuestRsvpFormEntity copyWith({
    GuestEntity? guest,
    AttendanceOption? attendance,
    FoodOption? food,
  }) =>
      GuestRsvpFormEntity(
        formKey: formKey,
        guest: guest ?? this.guest,
        attendance: attendance ?? this.attendance,
        food: food ?? this.food,
      );

  @override
  List<Object?> get props => [guest.documentId, attendance, food];
}
