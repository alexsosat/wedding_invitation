import "package:auto_route/auto_route.dart";
import "package:firebase_auth/firebase_auth.dart";

import "../app_router.gr.dart";

/// Route guard to protect admin routes requiring authentication.
class AuthGuard extends AutoRouteGuard {
  /// Creates an [AuthGuard] instance.
  AuthGuard({FirebaseAuth? auth}) : _auth = auth;

  final FirebaseAuth? _auth;

  FirebaseAuth? get _resolvedAuth {
    if (_auth != null) {
      return _auth;
    }
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final auth = _resolvedAuth;
    if (auth?.currentUser != null) {
      resolver.next(true);
    } else {
      router.push(const LoginRoute());
    }
  }
}
