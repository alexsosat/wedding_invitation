// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:boda_ma/features/auth/presentation/pages/login_page.dart'
    as _i5;
import 'package:boda_ma/features/invitation/presentation/pages/admin_dashboard_page.dart'
    as _i1;
import 'package:boda_ma/features/invitation/presentation/pages/details_page.dart'
    as _i2;
import 'package:boda_ma/features/invitation/presentation/pages/envelope_page.dart'
    as _i3;
import 'package:boda_ma/features/invitation/presentation/pages/invitation_page.dart'
    as _i4;
import 'package:boda_ma/features/invitation/presentation/pages/rsvp_page.dart'
    as _i6;
import 'package:boda_ma/features/splash/presentation/pages/splash_page.dart'
    as _i7;
import 'package:flutter/material.dart' as _i9;

/// generated route for
/// [_i1.AdminDashboardPage]
class AdminDashboardRoute extends _i8.PageRouteInfo<void> {
  const AdminDashboardRoute({List<_i8.PageRouteInfo>? children})
      : super(AdminDashboardRoute.name, initialChildren: children);

  static const String name = 'AdminDashboardRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.AdminDashboardPage();
    },
  );
}

/// generated route for
/// [_i2.DetailsPage]
class DetailsRoute extends _i8.PageRouteInfo<void> {
  const DetailsRoute({List<_i8.PageRouteInfo>? children})
      : super(DetailsRoute.name, initialChildren: children);

  static const String name = 'DetailsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.DetailsPage();
    },
  );
}

/// generated route for
/// [_i3.EnvelopePage]
class EnvelopeRoute extends _i8.PageRouteInfo<EnvelopeRouteArgs> {
  EnvelopeRoute({
    _i9.Key? key,
    String recipientName = "Abigail Lazcano",
    _i9.VoidCallback? onOpen,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          EnvelopeRoute.name,
          args: EnvelopeRouteArgs(
            key: key,
            recipientName: recipientName,
            onOpen: onOpen,
          ),
          initialChildren: children,
        );

  static const String name = 'EnvelopeRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EnvelopeRouteArgs>(
        orElse: () => const EnvelopeRouteArgs(),
      );
      return _i3.EnvelopePage(
        key: args.key,
        recipientName: args.recipientName,
        onOpen: args.onOpen,
      );
    },
  );
}

class EnvelopeRouteArgs {
  const EnvelopeRouteArgs({
    this.key,
    this.recipientName = "Abigail Lazcano",
    this.onOpen,
  });

  final _i9.Key? key;

  final String recipientName;

  final _i9.VoidCallback? onOpen;

  @override
  String toString() {
    return 'EnvelopeRouteArgs{key: $key, recipientName: $recipientName, onOpen: $onOpen}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EnvelopeRouteArgs) return false;
    return key == other.key &&
        recipientName == other.recipientName &&
        onOpen == other.onOpen;
  }

  @override
  int get hashCode => key.hashCode ^ recipientName.hashCode ^ onOpen.hashCode;
}

/// generated route for
/// [_i4.InvitationPage]
class InvitationRoute extends _i8.PageRouteInfo<void> {
  const InvitationRoute({List<_i8.PageRouteInfo>? children})
      : super(InvitationRoute.name, initialChildren: children);

  static const String name = 'InvitationRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.InvitationPage();
    },
  );
}

/// generated route for
/// [_i5.LoginPage]
class LoginRoute extends _i8.PageRouteInfo<void> {
  const LoginRoute({List<_i8.PageRouteInfo>? children})
      : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.LoginPage();
    },
  );
}

/// generated route for
/// [_i6.RsvpPage]
class RsvpRoute extends _i8.PageRouteInfo<void> {
  const RsvpRoute({List<_i8.PageRouteInfo>? children})
      : super(RsvpRoute.name, initialChildren: children);

  static const String name = 'RsvpRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.RsvpPage();
    },
  );
}

/// generated route for
/// [_i7.SplashPage]
class SplashRoute extends _i8.PageRouteInfo<void> {
  const SplashRoute({List<_i8.PageRouteInfo>? children})
      : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.SplashPage();
    },
  );
}
