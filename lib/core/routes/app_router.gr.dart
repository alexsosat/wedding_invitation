// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:boda_ma/features/auth/presentation/pages/login_page.dart'
    as _i6;
import 'package:boda_ma/features/invitation/presentation/pages/admin_dashboard_page.dart'
    as _i1;
import 'package:boda_ma/features/invitation/presentation/pages/details_page.dart'
    as _i2;
import 'package:boda_ma/features/invitation/presentation/pages/envelope_page.dart'
    as _i3;
import 'package:boda_ma/features/invitation/presentation/pages/history_page.dart'
    as _i4;
import 'package:boda_ma/features/invitation/presentation/pages/invitation_page.dart'
    as _i5;
import 'package:boda_ma/features/invitation/presentation/pages/not_found_page.dart'
    as _i7;
import 'package:boda_ma/features/invitation/presentation/pages/rsvp_page.dart'
    as _i8;
import 'package:boda_ma/features/splash/presentation/pages/splash_page.dart'
    as _i9;
import 'package:flutter/material.dart' as _i11;

/// generated route for
/// [_i1.AdminDashboardPage]
class AdminDashboardRoute extends _i10.PageRouteInfo<void> {
  const AdminDashboardRoute({List<_i10.PageRouteInfo>? children})
      : super(AdminDashboardRoute.name, initialChildren: children);

  static const String name = 'AdminDashboardRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i1.AdminDashboardPage();
    },
  );
}

/// generated route for
/// [_i2.DetailsPage]
class DetailsRoute extends _i10.PageRouteInfo<void> {
  const DetailsRoute({List<_i10.PageRouteInfo>? children})
      : super(DetailsRoute.name, initialChildren: children);

  static const String name = 'DetailsRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i2.DetailsPage();
    },
  );
}

/// generated route for
/// [_i3.EnvelopePage]
class EnvelopeRoute extends _i10.PageRouteInfo<EnvelopeRouteArgs> {
  EnvelopeRoute({
    _i11.Key? key,
    String recipientName = "Abigail Lazcano",
    _i11.VoidCallback? onOpen,
    List<_i10.PageRouteInfo>? children,
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

  static _i10.PageInfo page = _i10.PageInfo(
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

  final _i11.Key? key;

  final String recipientName;

  final _i11.VoidCallback? onOpen;

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
/// [_i4.HistoryPage]
class HistoryRoute extends _i10.PageRouteInfo<void> {
  const HistoryRoute({List<_i10.PageRouteInfo>? children})
      : super(HistoryRoute.name, initialChildren: children);

  static const String name = 'HistoryRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i4.HistoryPage();
    },
  );
}

/// generated route for
/// [_i5.InvitationPage]
class InvitationRoute extends _i10.PageRouteInfo<void> {
  const InvitationRoute({List<_i10.PageRouteInfo>? children})
      : super(InvitationRoute.name, initialChildren: children);

  static const String name = 'InvitationRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i5.InvitationPage();
    },
  );
}

/// generated route for
/// [_i6.LoginPage]
class LoginRoute extends _i10.PageRouteInfo<void> {
  const LoginRoute({List<_i10.PageRouteInfo>? children})
      : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i6.LoginPage();
    },
  );
}

/// generated route for
/// [_i7.NotFoundPage]
class NotFoundRoute extends _i10.PageRouteInfo<void> {
  const NotFoundRoute({List<_i10.PageRouteInfo>? children})
      : super(NotFoundRoute.name, initialChildren: children);

  static const String name = 'NotFoundRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i7.NotFoundPage();
    },
  );
}

/// generated route for
/// [_i8.RsvpPage]
class RsvpRoute extends _i10.PageRouteInfo<void> {
  const RsvpRoute({List<_i10.PageRouteInfo>? children})
      : super(RsvpRoute.name, initialChildren: children);

  static const String name = 'RsvpRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i8.RsvpPage();
    },
  );
}

/// generated route for
/// [_i9.SplashPage]
class SplashRoute extends _i10.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    String? slug,
    String? querySlug,
    _i11.Key? key,
    List<_i10.PageRouteInfo>? children,
  }) : super(
          SplashRoute.name,
          args: SplashRouteArgs(slug: slug, querySlug: querySlug, key: key),
          rawPathParams: {'slug?': slug},
          rawQueryParams: {'slug': querySlug},
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<SplashRouteArgs>(
        orElse: () => SplashRouteArgs(
          slug: pathParams.optString('slug?'),
          querySlug: queryParams.optString('slug'),
        ),
      );
      return _i9.SplashPage(
        slug: args.slug,
        querySlug: args.querySlug,
        key: args.key,
      );
    },
  );
}

class SplashRouteArgs {
  const SplashRouteArgs({this.slug, this.querySlug, this.key});

  final String? slug;

  final String? querySlug;

  final _i11.Key? key;

  @override
  String toString() {
    return 'SplashRouteArgs{slug: $slug, querySlug: $querySlug, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SplashRouteArgs) return false;
    return slug == other.slug &&
        querySlug == other.querySlug &&
        key == other.key;
  }

  @override
  int get hashCode => slug.hashCode ^ querySlug.hashCode ^ key.hashCode;
}
