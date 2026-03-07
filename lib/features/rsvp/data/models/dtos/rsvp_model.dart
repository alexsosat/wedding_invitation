import "dart:convert";

import "../../../business/entities/rsvp_entity.dart";

/// Model that transforms the Rsvp data from the API to the
/// application entity
class RsvpModel extends RsvpEntity {
  /// Model that transforms the Rsvp data from the API to the
  /// application entity
  const RsvpModel();

  

  /// Factory method to create a Home model instance from a JSON
  factory RsvpModel.fromJson({required String json}) => RsvpModel.fromMap(map: jsonDecode(json));

  /// Factory method to create a Rsvp model instance from a map
  factory RsvpModel.fromMap({required Map<String, dynamic> map}) =>
     const RsvpModel();

  /// Factory method to create a Rsvp model instance from an 
  /// entity
  factory RsvpModel.fromEntity({required RsvpEntity entity}) => RsvpModel();

  /// Converts the Rsvp model instance to a map
  Map<String, dynamic> toMap() => {};

  /// Converts the Home model instance to a JSON
  String toJson() => jsonEncode(toMap());
  
  /// Converts the Rsvp model instance to an entity
  RsvpEntity toEntity() => RsvpEntity();
}
