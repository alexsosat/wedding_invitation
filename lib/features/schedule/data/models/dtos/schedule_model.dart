import "dart:convert";

import "../../../business/entities/schedule_entity.dart";

/// Model that transforms the Schedule data from the API to the
/// application entity
class ScheduleModel extends ScheduleEntity {
  /// Model that transforms the Schedule data from the API to the
  /// application entity
  const ScheduleModel();

  

  /// Factory method to create a Home model instance from a JSON
  factory ScheduleModel.fromJson({required String json}) => ScheduleModel.fromMap(map: jsonDecode(json));

  /// Factory method to create a Schedule model instance from a map
  factory ScheduleModel.fromMap({required Map<String, dynamic> map}) =>
     const ScheduleModel();

  /// Factory method to create a Schedule model instance from an 
  /// entity
  factory ScheduleModel.fromEntity({required ScheduleEntity entity}) => ScheduleModel();

  /// Converts the Schedule model instance to a map
  Map<String, dynamic> toMap() => {};

  /// Converts the Home model instance to a JSON
  String toJson() => jsonEncode(toMap());
  
  /// Converts the Schedule model instance to an entity
  ScheduleEntity toEntity() => ScheduleEntity();
}
