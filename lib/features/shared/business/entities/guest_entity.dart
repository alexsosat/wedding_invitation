import "package:equatable/equatable.dart";

/// Entity that contains the guest values.
class GuestEntity extends Equatable {
  /// Entity that contains the guest values.
  const GuestEntity({
    required this.id,
    required this.documentId,
    required this.name,
  });

  /// Identifier of the guest.
  final int id;

  /// Identifier of the guest in the database.
  final String documentId;

  /// Name of the guest.
  final String name;

  @override
  List<Object?> get props => [id, documentId, name];

  @override
  bool get stringify => true;
}
