import "dart:math" as math;

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";

import "../../../../core/gen/assets.gen.dart";
import "../../../../core/routes/app_router.gr.dart";
import "../../../invitation/presentation/cubits/invitation_cubit.dart";
import "../../../invitation/presentation/cubits/invitation_state.dart";
import "../../../invitation/presentation/widgets/envelope/envelope_card.dart";
import "../../../shared/presentation/widgets/scaling_animated_widget.dart";
import "../cubits/splash_screen_cubit.dart";

/// The splash screen page.
///
/// This page is the first page that the user sees when they open the app.
/// It shows a splash animation, initializes services, loads the invitation,
/// and navigates to the [EnvelopePage] or [NotFoundPage].
@RoutePage()
class SplashPage extends StatelessWidget {
  /// The splash screen page.
  const SplashPage({
    @PathParam("slug?") this.slug,
    @QueryParam("slug") this.querySlug,
    super.key,
  });

  /// The invitation slug from the route path parameter (e.g. /sosa-trejo).
  final String? slug;

  /// The invitation slug from query parameter (e.g. ?slug=sosa-trejo).
  final String? querySlug;

  @override
  Widget build(BuildContext context) {
    final effectiveSlug = _resolveEffectiveSlug(
      pathSlug: slug,
      querySlug: querySlug,
    );

    return Scaffold(
      backgroundColor: context.colorScheme.primary,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<SplashScreenCubit>(
            create: (_) => SplashScreenCubit(
              slug: effectiveSlug,
            ),
          ),
        ],
        child: _SplashScreenContent(
          slug: effectiveSlug,
        ),
      ),
    );
  }

  static String? _resolveEffectiveSlug({
    String? pathSlug,
    String? querySlug,
  }) {
    if (pathSlug != null &&
        pathSlug.trim().isNotEmpty &&
        !pathSlug.startsWith(":")) {
      return Uri.decodeComponent(pathSlug.trim()).toLowerCase();
    }

    if (querySlug != null && querySlug.trim().isNotEmpty) {
      return Uri.decodeComponent(querySlug.trim()).toLowerCase();
    }

    // Check base query parameters (?slug=...)
    final qSlug = Uri.base.queryParameters["slug"];
    if (qSlug != null && qSlug.trim().isNotEmpty) {
      return Uri.decodeComponent(qSlug.trim()).toLowerCase();
    }

    // Check fragment (#/... or #...)
    final fragment = Uri.base.fragment;
    if (fragment.isNotEmpty) {
      final normalizedFragment =
          fragment.startsWith("/") ? fragment : "/$fragment";
      final fragmentUri = Uri.tryParse(normalizedFragment);
      if (fragmentUri != null) {
        final fragSlug = fragmentUri.queryParameters["slug"];
        if (fragSlug != null && fragSlug.trim().isNotEmpty) {
          return Uri.decodeComponent(fragSlug.trim()).toLowerCase();
        }

        final segments =
            fragmentUri.pathSegments.where((s) => s.isNotEmpty).toList();
        if (segments.isNotEmpty) {
          final first = segments.first;
          if (!_isReservedRoute(first)) {
            return Uri.decodeComponent(first).toLowerCase();
          }
        }
      }
    }

    // Check base path segments (/...)
    final pathSegments =
        Uri.base.pathSegments.where((s) => s.isNotEmpty).toList();
    if (pathSegments.isNotEmpty) {
      final first = pathSegments.first;
      if (!_isReservedRoute(first)) {
        return Uri.decodeComponent(first).toLowerCase();
      }
    }

    return null;
  }

  static bool _isReservedRoute(String route) =>
      route == "admin" ||
      route == "envelope" ||
      route == "invitation" ||
      route == "details" ||
      route == "rsvp" ||
      route == "not-found";
}

class _SplashScreenContent extends StatefulWidget {
  const _SplashScreenContent({this.slug});

  final String? slug;

  @override
  State<_SplashScreenContent> createState() => _SplashScreenContentState();
}

class _SplashScreenContentState extends State<_SplashScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _initAnimation();
    super.initState();
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _controller
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.read<SplashScreenCubit>().markAnimationFinished();
        }
      });
  }

  void _onPageExit() {
    final invitationState = context.read<InvitationCubit>().state;

    if (invitationState is InvitationLoaded &&
        invitationState.invitation.groupName.trim().isNotEmpty) {
      context.router.replace(
        EnvelopeRoute(
          recipientName: invitationState.invitation.groupName.trim(),
        ),
      );
    } else {
      context.router.replace(
        const NotFoundRoute(),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          // 1. Floral paper texture overlay on dark navy background
          Positioned.fill(
            child: Opacity(
              opacity: 0.16,
              child: Assets.images.textures.flowersTransparent.image(
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: BlocConsumer<SplashScreenCubit, SplashScreenState>(
                listener: (context, state) {
                  if (state is SplashScreenSuccess) {
                    _onPageExit();
                  }
                },
                builder: (context, state) => switch (state.status) {
                  SplashScreenStatus.loading => Transform.rotate(
                      angle: -8 * math.pi / 180,
                      child: const ScalingAnimatedWidget(
                        child: EnvelopeCard(
                          recipientName: "",
                        ),
                      ),
                    ),
                  SplashScreenStatus.animationFinished => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: -8 * math.pi / 180,
                          child: const EnvelopeCard(
                            recipientName: "",
                          ),
                        ),
                        const SizedBox(height: 20),
                        const CircularProgressIndicator.adaptive(),
                      ],
                    ),
                  SplashScreenStatus.success => Transform.rotate(
                      angle: -8 * math.pi / 180,
                      child: const EnvelopeCard(
                        recipientName: "",
                      ),
                    ),
                  SplashScreenStatus.failure => Text(
                      state.failure!.message,
                      style: context.textTheme.headlineLarge?.copyWith(
                        color: context.colorScheme.onSecondary,
                      ),
                    ),
                },
              ),
            ),
          ),
        ],
      );
}
