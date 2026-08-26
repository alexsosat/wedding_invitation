import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_common_classes/errors/failure.dart";
import "package:flutter_common_classes/extensions/cubit_extension.dart";

import "../../../../core/config/dependency_injection.dart";
import "../../../invitation/presentation/cubits/invitation_cubit.dart";

part "splash_screen_state.dart";

/// Cubit in charge of managing the splash screen state.
class SplashScreenCubit extends Cubit<SplashScreenState> {
  /// Constructor for the cubit.
  SplashScreenCubit({
    this.slug,
    InvitationCubit? invitationCubit,
  })  : _invitationCubit = invitationCubit,
        super(const SplashScreenLoading()) {
    _startApp();
  }

  /// Optional slug to load the invitation during app start
  final String? slug;
  final InvitationCubit? _invitationCubit;

  bool _isAnimationFinished = false;
  bool _areServicesReady = false;
  bool _anErrorOccurred = false;

  /// Method to be called when the animation has finished.
  ///
  /// If the services are ready, it will emit a [SplashScreenSuccess] state.
  /// If the services are not ready, it will emit a
  /// [SplashScreenAnimationFinished] state.
  void markAnimationFinished() {
    if (_anErrorOccurred) {
      return;
    }
    _isAnimationFinished = true;

    if (_areServicesReady) {
      safeEmit(
        const SplashScreenSuccess(),
      );
    } else {
      safeEmit(const SplashScreenAnimationFinished());
    }
  }

  /// Entry point of the application.
  Future<void> _startApp() async {
    await _injectDependencies();
    if (state is SplashScreenFailure) {
      return;
    }
    await _loadInvitationData();
    _markServicesReady();
  }

  void _markServicesReady() {
    _areServicesReady = true;

    if (_isAnimationFinished) {
      safeEmit(
        const SplashScreenSuccess(),
      );
    }
  }

  Future<void> _loadInvitationData() async {
    final cleanSlug = slug?.trim().toLowerCase();
    if (cleanSlug != null &&
        cleanSlug.isNotEmpty &&
        !cleanSlug.startsWith(":")) {
      try {
        final cubit = _invitationCubit ?? getIt<InvitationCubit>();
        await cubit.loadInvitationBySlug(cleanSlug);
      } catch (_) {
        // Handled within InvitationCubit states
      }
    }
  }

  Future<void> _injectDependencies() async {
    try {
      await DependencyInjection.injectServices();
      await DependencyInjection.injectRepositories();
    } catch (e) {
      _anErrorOccurred = true;
      safeEmit(
        SplashScreenFailure(
          failure: AppFailure.unexpected(
            e.toString(),
          ),
        ),
      );
    }
  }
}
