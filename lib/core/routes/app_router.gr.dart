// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:boda_ma/features/invitation/presentation/pages/envelope_page.dart'
    as _i1;
import 'package:boda_ma/features/splash/presentation/pages/splash_page.dart'
    as _i2;
import 'package:flutter/material.dart' as _i4;

/// generated route for
/// [_i1.EnvelopePage]
class EnvelopeRoute extends _i3.PageRouteInfo<EnvelopeRouteArgs> {
  EnvelopeRoute({
    _i4.Key? key,
    String recipientName = "Abigail Lazcano",
    _i4.VoidCallback? onOpen,
    List<_i3.PageRouteInfo>? children,
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

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EnvelopeRouteArgs>(
        orElse: () => const EnvelopeRouteArgs(),
      );
      return _i1.EnvelopePage(
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

  final _i4.Key? key;

  final String recipientName;

  final _i4.VoidCallback? onOpen;

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
/// [_i2.SplashPage]
class SplashRoute extends _i3.PageRouteInfo<void> {
  const SplashRoute({List<_i3.PageRouteInfo>? children})
      : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i2.SplashPage();
    },
  );
}
