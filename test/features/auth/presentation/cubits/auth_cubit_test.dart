import "package:boda_ma/features/auth/business/entities/auth_user_entity.dart";
import "package:boda_ma/features/auth/business/repositories/auth_repository.dart";
import "package:boda_ma/features/auth/business/use_cases/get_current_user.dart";
import "package:boda_ma/features/auth/business/use_cases/send_password_reset.dart";
import "package:boda_ma/features/auth/business/use_cases/sign_in_with_email.dart";
import "package:boda_ma/features/auth/business/use_cases/sign_out.dart";
import "package:boda_ma/features/auth/presentation/cubits/auth_cubit.dart";
import "package:boda_ma/features/auth/presentation/cubits/auth_state.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:flutter_test/flutter_test.dart";
import "package:fpdart/fpdart.dart";

class FakeAuthRepository implements AuthRepository {
  AuthUserEntity? mockUser;

  @override
  Stream<AuthUserEntity?> get authStateChanges => Stream.value(mockUser);

  @override
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser() async =>
      Right(mockUser);

  @override
  Future<Either<Failure, AuthUserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final user = AuthUserEntity(id: "123", email: email);
    mockUser = user;
    return Right(user);
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    mockUser = null;
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  }) async =>
      const Right(unit);
}

void main() {
  late FakeAuthRepository repository;
  late GetCurrentUser getCurrentUser;
  late SignInWithEmail signInWithEmail;
  late SignOut signOut;
  late SendPasswordReset sendPasswordReset;
  late AuthCubit cubit;

  setUp(() {
    repository = FakeAuthRepository();
    getCurrentUser = GetCurrentUser(authRepository: repository);
    signInWithEmail = SignInWithEmail(authRepository: repository);
    signOut = SignOut(authRepository: repository);
    sendPasswordReset = SendPasswordReset(authRepository: repository);
    cubit = AuthCubit(
      getCurrentUser: getCurrentUser,
      signInWithEmail: signInWithEmail,
      signOut: signOut,
      sendPasswordReset: sendPasswordReset,
      authRepository: repository,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test("initial state is Unauthenticated when no user is logged in", () async {
    await pumpEventQueue();
    expect(cubit.state, const Unauthenticated());
  });

  test("signIn emits Authenticated state with user", () async {
    await cubit.signIn(email: "admin@test.com", password: "password123");

    expect(
      cubit.state,
      const Authenticated(
        user: AuthUserEntity(id: "123", email: "admin@test.com"),
      ),
    );
  });

  test("logOut emits Unauthenticated state", () async {
    await cubit.signIn(email: "admin@test.com", password: "password123");
    expect(cubit.state, isA<Authenticated>());

    await cubit.logOut();
    expect(cubit.state, const Unauthenticated());
  });
}
