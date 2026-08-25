import "package:boda_ma/features/auth/business/entities/auth_user_entity.dart";
import "package:boda_ma/features/auth/business/repositories/auth_repository.dart";
import "package:boda_ma/features/auth/business/use_cases/get_current_user.dart";
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
  late GetCurrentUser useCase;

  setUp(() {
    repository = FakeAuthRepository();
    useCase = GetCurrentUser(authRepository: repository);
  });

  test("returns current user when user is logged in", () async {
    repository.mockUser = const AuthUserEntity(
      id: "admin-1",
      email: "admin@bodama.com",
    );

    final result = await useCase(params: const NoParams());

    expect(result.isRight(), isTrue);
    result.fold(
      (failure) => fail("Should not fail"),
      (user) {
        expect(user, isNotNull);
        expect(user!.id, equals("admin-1"));
        expect(user.email, equals("admin@bodama.com"));
      },
    );
  });

  test("returns null when no user is logged in", () async {
    repository.mockUser = null;

    final result = await useCase(params: const NoParams());

    expect(result.isRight(), isTrue);
    result.fold(
      (failure) => fail("Should not fail"),
      (user) => expect(user, isNull),
    );
  });
}
