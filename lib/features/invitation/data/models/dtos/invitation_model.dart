import "dart:convert";

import "../../../business/entities/invitation_entity.dart";

/// Model that transforms the Invitation data from the API to the
/// application entity
class InvitationModel extends InvitationEntity {
  /// Model that transforms the Invitation data from the API to the
  /// application entity
  const InvitationModel();

  

  /// Factory method to create a Home model instance from a JSON
  factory InvitationModel.fromJson({required String json}) => InvitationModel.fromMap(map: jsonDecode(json));

  /// Factory method to create a Invitation model instance from a map
  factory InvitationModel.fromMap({required Map<String, dynamic> map}) =>
     const InvitationModel();

  /// Factory method to create a Invitation model instance from an 
  /// entity
  factory InvitationModel.fromEntity({required InvitationEntity entity}) => InvitationModel();

  /// Converts the Invitation model instance to a map
  Map<String, dynamic> toMap() => {};

  /// Converts the Home model instance to a JSON
  String toJson() => jsonEncode(toMap());
  
  /// Converts the Invitation model instance to an entity
  InvitationEntity toEntity() => InvitationEntity();
}
