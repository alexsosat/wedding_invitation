import "package:firebase_auth/firebase_auth.dart";

/// Remote data source interface for Firebase Authentication operations.
abstract class AuthRemoteDataSource {
  /// Instance of [FirebaseAuth].
  FirebaseAuth get authInstance;

  /// Current authenticated [User] if available.
  User? get currentUser;

  /// Stream emitting changes to the current authentication state.
  Stream<User?> get authStateChanges;

  /// Signs in a user with email and password.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs out the currently authenticated user.
  Future<void> signOut();

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail({
    required String email,
  });
}

/// Remote data source implementation using [FirebaseAuth].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Creates an [AuthRemoteDataSourceImpl] instance.
  AuthRemoteDataSourceImpl({
    FirebaseAuth? auth,
  }) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  FirebaseAuth get authInstance => _auth;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) =>
      _auth.sendPasswordResetEmail(email: email);
}
