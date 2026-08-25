import "dart:async";

import "package:flutter_common_classes/flutter_common_classes.dart";

import "../../business/repositories/auth_repository.dart";
import "../../business/use_cases/get_current_user.dart";
import "../../business/use_cases/send_password_reset.dart";
import "../../business/use_cases/sign_in_with_email.dart";
import "../../business/use_cases/sign_out.dart";
import "../../data/models/params/password_reset_params.dart";
import "../../data/models/params/sign_in_params.dart";
import "auth_state.dart";

/// Cubit managing the authentication lifecycle and states
class AuthCubit extends Cubit<AuthState> {
  /// Creates an [AuthCubit] instance
  AuthCubit({
    required GetCurrentUser getCurrentUser,
    required SignInWithEmail signInWithEmail,
    required SignOut signOut,
    required SendPasswordReset sendPasswordReset,
    required AuthRepository authRepository,
  })  : _getCurrentUser = getCurrentUser,
        _signInWithEmail = signInWithEmail,
        _signOut = signOut,
        _sendPasswordReset = sendPasswordReset,
        _authRepository = authRepository,
        super(const AuthInitial()) {
    _initAuthStateSubscription();
  }

  final GetCurrentUser _getCurrentUser;
  final SignInWithEmail _signInWithEmail;
  final SignOut _signOut;
  final SendPasswordReset _sendPasswordReset;
  final AuthRepository _authRepository;
  StreamSubscription? _authSubscription;

  void _initAuthStateSubscription() {
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        safeEmit(Authenticated(user: user));
      } else {
        safeEmit(const Unauthenticated());
      }
    });
  }

  /// Checks the current authentication status
  Future<void> checkAuthStatus() async {
    safeEmit(const AuthLoading());

    final result = await _getCurrentUser(params: const NoParams());

    result.fold(
      (failure) => safeEmit(AuthError(failure: failure)),
      (user) {
        if (user != null) {
          safeEmit(Authenticated(user: user));
        } else {
          safeEmit(const Unauthenticated());
        }
      },
    );
  }

  /// Signs in the user with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    safeEmit(const AuthLoading());

    final result = await _signInWithEmail(
      params: SignInParams(
        email: email,
        password: password,
      ),
    );

    result.fold(
      (failure) => safeEmit(AuthError(failure: failure)),
      (user) => safeEmit(Authenticated(user: user)),
    );
  }

  /// Signs out the current user
  Future<void> logOut() async {
    safeEmit(const AuthLoading());

    final result = await _signOut(params: const NoParams());

    result.fold(
      (failure) => safeEmit(AuthError(failure: failure)),
      (_) => safeEmit(const Unauthenticated()),
    );
  }

  /// Sends a password reset email
  Future<void> sendPasswordReset(String email) async {
    final result = await _sendPasswordReset(
      params: PasswordResetParams(email: email),
    );

    result.fold(
      (failure) => safeEmit(AuthError(failure: failure)),
      (_) {},
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
