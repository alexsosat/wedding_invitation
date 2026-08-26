import "package:auto_route/auto_route.dart";
import "package:boda_ma/core/routes/app_router.gr.dart";
import "package:boda_ma/core/routes/guards/auth_guard.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_test/flutter_test.dart";

class MockUser implements User {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockFirebaseAuth implements FirebaseAuth {
  User? mockCurrentUser;

  @override
  User? get currentUser => mockCurrentUser;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockNavigationResolver implements NavigationResolver {
  bool? nextValue;

  @override
  void next([bool continueNavigation = true]) {
    nextValue = continueNavigation;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockStackRouter implements StackRouter {
  PageRouteInfo? pushedRoute;

  @override
  Future<T?> push<T extends Object?>(
    PageRouteInfo route, {
    void Function(NavigationFailure)? onFailure,
  }) async {
    pushedRoute = route;
    return null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockNavigationResolver mockResolver;
  late MockStackRouter mockRouter;
  late AuthGuard guard;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockResolver = MockNavigationResolver();
    mockRouter = MockStackRouter();
    guard = AuthGuard(auth: mockAuth);
  });

  group("AuthGuard", () {
    test("given an authenticated user, when onNavigation is called, then resolver continues navigation", () {
      // Given
      mockAuth.mockCurrentUser = MockUser();

      // When
      guard.onNavigation(mockResolver, mockRouter);

      // Then
      expect(mockResolver.nextValue, isTrue);
      expect(mockRouter.pushedRoute, isNull);
    });

    test("given an unauthenticated session, when onNavigation is called, then redirects to /admin/login", () {
      // Given
      mockAuth.mockCurrentUser = null;

      // When
      guard.onNavigation(mockResolver, mockRouter);

      // Then
      expect(mockResolver.nextValue, isNull);
      expect(mockRouter.pushedRoute, isA<LoginRoute>());
    });
  });
}
