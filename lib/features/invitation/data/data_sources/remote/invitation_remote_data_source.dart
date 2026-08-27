import "package:cloud_firestore/cloud_firestore.dart";

import "../../models/dtos/guest_model.dart";
import "../../models/dtos/invitation_model.dart";

/// Remote data source interface for the Invitation and Guest collections
abstract class InvitationRemoteDataSource {
  /// Fetches an invitation by its Firestore document ID
  Future<InvitationModel?> getInvitationById(String id);

  /// Fetches an invitation by its unique URL slug
  Future<InvitationModel?> getInvitationBySlug(String slug);

  /// Fetches all invitations with their guests
  Future<List<InvitationModel>> getAllInvitations();

  /// Creates a new invitation document and its subcollection guests
  Future<InvitationModel> createInvitation(InvitationModel invitation);

  /// Updates an existing invitation and its guests
  Future<InvitationModel> updateInvitation(InvitationModel invitation);

  /// Deletes an invitation and its associated guests
  Future<void> deleteInvitation(String invitationId);

  /// Toggles the sent status of an invitation
  Future<void> toggleSentStatus(String invitationId, bool isSent);

  /// Fetches all guests linked to a specific invitation
  Future<List<GuestModel>> getGuests(String invitationId);

  /// Updates RSVP details for a single guest
  Future<void> updateGuestRsvp(GuestModel guest);

  /// Toggles the admin confirmation status of a single guest
  Future<void> toggleGuestConfirmation(
    String invitationId,
    String guestId,
    bool isConfirmed,
  );
}

/// Remote data source implementation communicating with Cloud Firestore
class InvitationRemoteDataSourceImpl implements InvitationRemoteDataSource {
  /// Creates an [InvitationRemoteDataSourceImpl] with an optional [FirebaseFirestore] instance
  InvitationRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _invitationsCollection = "invitations";
  static const String _guestsSubcollection = "guests";

  @override
  Future<InvitationModel?> getInvitationById(String id) async {
    final docSnapshot =
        await _firestore.collection(_invitationsCollection).doc(id).get();

    if (!docSnapshot.exists) {
      return null;
    }

    final guests = await getGuests(id);
    return InvitationModel.fromFirestoreDoc(docSnapshot, guests);
  }

  @override
  Future<InvitationModel?> getInvitationBySlug(String slug) async {
    final cleanSlug = slug.trim().toLowerCase();
    final querySnapshot = await _firestore
        .collection(_invitationsCollection)
        .where("slug", isEqualTo: cleanSlug)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    final docSnapshot = querySnapshot.docs.first;
    final guests = await getGuests(docSnapshot.id);
    return InvitationModel.fromFirestoreDoc(docSnapshot, guests);
  }

  @override
  Future<List<InvitationModel>> getAllInvitations() async {
    final querySnapshot = await _firestore
        .collection(_invitationsCollection)
        .get();

    final List<InvitationModel> invitations = [];
    for (final doc in querySnapshot.docs) {
      final guests = await getGuests(doc.id);
      invitations.add(InvitationModel.fromFirestoreDoc(doc, guests));
    }

    invitations.sort((a, b) {
      final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    return invitations;
  }

  @override
  Future<InvitationModel> createInvitation(InvitationModel invitation) async {
    final invitationRef = invitation.id.isNotEmpty
        ? _firestore.collection(_invitationsCollection).doc(invitation.id)
        : _firestore.collection(_invitationsCollection).doc();

    final now = DateTime.now();
    final data = <String, dynamic>{
      ...invitation.toMap(),
      "createdAt": Timestamp.fromDate(invitation.createdAt ?? now),
      "updatedAt": Timestamp.fromDate(now),
    };

    final batch = _firestore.batch()..set(invitationRef, data);

    final List<GuestModel> createdGuests = [];
    for (final guest in invitation.guests) {
      final guestRef = guest.id.isNotEmpty
          ? invitationRef.collection(_guestsSubcollection).doc(guest.id)
          : invitationRef.collection(_guestsSubcollection).doc();

      final guestModel = GuestModel(
        id: guestRef.id,
        firstName: guest.firstName,
        lastName: guest.lastName,
        phone: guest.phone,
        attendance: guest.attendance,
        dietary: guest.dietary,
        invitationId: invitationRef.id,
        dietaryDetails: guest.dietaryDetails,
        isConfirmed: guest.isConfirmed,
        updatedAt: now,
      );

      batch.set(guestRef, guestModel.toMap());
      createdGuests.add(guestModel);
    }

    await batch.commit();

    return InvitationModel(
      id: invitationRef.id,
      groupName: invitation.groupName,
      slug: invitation.slug,
      isSent: invitation.isSent,
      sentAt: invitation.sentAt,
      createdAt: invitation.createdAt ?? now,
      updatedAt: now,
      guests: createdGuests,
    );
  }

  @override
  Future<InvitationModel> updateInvitation(InvitationModel invitation) async {
    final invitationRef =
        _firestore.collection(_invitationsCollection).doc(invitation.id);

    final now = DateTime.now();
    final data = <String, dynamic>{
      ...invitation.toMap(),
      "updatedAt": Timestamp.fromDate(now),
    };

    final batch = _firestore.batch()..update(invitationRef, data);

    // Fetch existing guests to detect removed ones
    final existingGuestsSnapshot =
        await invitationRef.collection(_guestsSubcollection).get();
    final updatedIds = invitation.guests
        .map((g) => g.id)
        .where((id) => id.isNotEmpty)
        .toSet();

    // Delete removed guests
    for (final doc in existingGuestsSnapshot.docs) {
      if (!updatedIds.contains(doc.id)) {
        batch.delete(doc.reference);
      }
    }

    // Set / update new and existing guests
    final List<GuestModel> updatedGuests = [];
    for (final guest in invitation.guests) {
      final guestRef = guest.id.isNotEmpty
          ? invitationRef.collection(_guestsSubcollection).doc(guest.id)
          : invitationRef.collection(_guestsSubcollection).doc();

      final guestModel = GuestModel(
        id: guestRef.id,
        firstName: guest.firstName,
        lastName: guest.lastName,
        phone: guest.phone,
        attendance: guest.attendance,
        dietary: guest.dietary,
        invitationId: invitation.id,
        dietaryDetails: guest.dietaryDetails,
        isConfirmed: guest.isConfirmed,
        updatedAt: guest.updatedAt ?? now,
      );

      batch.set(guestRef, guestModel.toMap(), SetOptions(merge: true));
      updatedGuests.add(guestModel);
    }

    await batch.commit();

    return InvitationModel(
      id: invitation.id,
      groupName: invitation.groupName,
      slug: invitation.slug,
      isSent: invitation.isSent,
      sentAt: invitation.sentAt,
      createdAt: invitation.createdAt,
      updatedAt: now,
      guests: updatedGuests,
    );
  }

  @override
  Future<void> deleteInvitation(String invitationId) async {
    final invitationRef =
        _firestore.collection(_invitationsCollection).doc(invitationId);

    final guestsSnapshot =
        await invitationRef.collection(_guestsSubcollection).get();

    final batch = _firestore.batch();
    for (final doc in guestsSnapshot.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(invitationRef);

    await batch.commit();
  }

  @override
  Future<void> toggleSentStatus(String invitationId, bool isSent) async {
    final now = DateTime.now();
    await _firestore
        .collection(_invitationsCollection)
        .doc(invitationId)
        .update({
      "isSent": isSent,
      "sentAt": isSent ? Timestamp.fromDate(now) : null,
      "updatedAt": Timestamp.fromDate(now),
    });
  }

  @override
  Future<List<GuestModel>> getGuests(String invitationId) async {
    final querySnapshot = await _firestore
        .collection(_invitationsCollection)
        .doc(invitationId)
        .collection(_guestsSubcollection)
        .get();

    return querySnapshot.docs
        .map(GuestModel.fromFirestoreDoc)
        .toList();
  }

  @override
  Future<void> updateGuestRsvp(GuestModel guest) async {
    await _firestore
        .collection(_invitationsCollection)
        .doc(guest.invitationId)
        .collection(_guestsSubcollection)
        .doc(guest.id)
        .update(guest.toRsvpUpdateMap());
  }

  @override
  Future<void> toggleGuestConfirmation(
    String invitationId,
    String guestId,
    bool isConfirmed,
  ) async {
    final now = DateTime.now();
    await _firestore
        .collection(_invitationsCollection)
        .doc(invitationId)
        .collection(_guestsSubcollection)
        .doc(guestId)
        .update({
      "isConfirmed": isConfirmed,
      "updatedAt": Timestamp.fromDate(now),
    });
  }
}
