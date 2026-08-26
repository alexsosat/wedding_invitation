import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart" hide EmailAuthProvider;
import "package:firebase_core/firebase_core.dart";
import "package:firebase_ui_auth/firebase_ui_auth.dart";
import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

import "../../features/auth/business/repositories/auth_repository.dart";
import "../../features/auth/business/use_cases/get_current_user.dart";
import "../../features/auth/business/use_cases/send_password_reset.dart";
import "../../features/auth/business/use_cases/sign_in_with_email.dart";
import "../../features/auth/business/use_cases/sign_out.dart";
import "../../features/auth/data/data_sources/remote/auth_remote_data_source.dart";
import "../../features/auth/data/repositories/auth_repository_impl.dart";
import "../../features/invitation/business/repositories/invitation_repository.dart";
import "../../features/invitation/business/use_cases/create_invitation.dart";
import "../../features/invitation/business/use_cases/delete_invitation.dart";
import "../../features/invitation/business/use_cases/get_all_invitations.dart";
import "../../features/invitation/business/use_cases/get_guests.dart";
import "../../features/invitation/business/use_cases/get_invitation.dart";
import "../../features/invitation/business/use_cases/toggle_invitation_sent_status.dart";
import "../../features/invitation/business/use_cases/update_guest_rsvp.dart";
import "../../features/invitation/business/use_cases/update_invitation.dart";
import "../../features/invitation/data/data_sources/remote/invitation_remote_data_source.dart";
import "../../features/invitation/data/repositories/invitation_repository_impl.dart";
import "../../features/invitation/presentation/cubits/invitation_cubit.dart";
import "../../firebase_options.dart";

/// Service Locator instance
final getIt = GetIt.instance;

/// Class to inject the dependencies in the application
class DependencyInjection {
  /// Inject critical services in the application before runApp
  static Future<void> injectCriticalServices() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);
  }

  /// Initialize the services in the application
  static Future<void> injectServices() async {
    if (!getIt.isRegistered<FirebaseFirestore>()) {
      getIt.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
      );
    }

    if (!getIt.isRegistered<FirebaseAuth>()) {
      getIt.registerLazySingleton<FirebaseAuth>(
        () => FirebaseAuth.instance,
      );
    }

    if (!getIt.isRegistered<AuthRemoteDataSource>()) {
      getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
          auth: getIt<FirebaseAuth>(),
        ),
      );
    }

    if (!getIt.isRegistered<InvitationRemoteDataSource>()) {
      getIt.registerLazySingleton<InvitationRemoteDataSource>(
        () => InvitationRemoteDataSourceImpl(
          firestore: getIt<FirebaseFirestore>(),
        ),
      );
    }
  }

  /// Inject the repositories and use cases in the application
  static Future<void> injectRepositories() async {
    // Auth Repositories and Use Cases
    if (!getIt.isRegistered<AuthRepository>()) {
      getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
          remoteDataSource: getIt<AuthRemoteDataSource>(),
        ),
      );
    }

    if (!getIt.isRegistered<GetCurrentUser>()) {
      getIt.registerLazySingleton<GetCurrentUser>(
        () => GetCurrentUser(
          authRepository: getIt<AuthRepository>(),
        ),
      );
    }

    if (!getIt.isRegistered<SignInWithEmail>()) {
      getIt.registerLazySingleton<SignInWithEmail>(
        () => SignInWithEmail(
          authRepository: getIt<AuthRepository>(),
        ),
      );
    }

    if (!getIt.isRegistered<SignOut>()) {
      getIt.registerLazySingleton<SignOut>(
        () => SignOut(
          authRepository: getIt<AuthRepository>(),
        ),
      );
    }

    if (!getIt.isRegistered<SendPasswordReset>()) {
      getIt.registerLazySingleton<SendPasswordReset>(
        () => SendPasswordReset(
          authRepository: getIt<AuthRepository>(),
        ),
      );
    }

    // Invitation Repositories and Use Cases
    if (!getIt.isRegistered<InvitationRepository>()) {
      getIt.registerLazySingleton<InvitationRepository>(
        () => InvitationRepositoryImpl(
          remoteDataSource: getIt<InvitationRemoteDataSource>(),
        ),
      );
    }

    if (!getIt.isRegistered<GetInvitation>()) {
      getIt.registerLazySingleton<GetInvitation>(
        () => GetInvitation(
          invitationRepository: getIt<InvitationRepository>(),
        ),
      );
    }

    if (!getIt.isRegistered<GetAllInvitations>()) {
      getIt.registerLazySingleton<GetAllInvitations>(
        () => GetAllInvitations(
          invitationRepository: getIt<InvitationRepository>(),
        ),
      );
    }

    if (!getIt.isRegistered<CreateInvitation>()) {
      getIt.registerLazySingleton<CreateInvitation>(
        () => CreateInvitation(
          invitationRepository: getIt<InvitationRepository>(),
        ),
      );
    }

    if (!getIt.isRegistered<UpdateInvitation>()) {
      getIt.registerLazySingleton<UpdateInvitation>(
        () => UpdateInvitation(
          invitationRepository: getIt<InvitationRepository>(),
        ),
      );
    }

    if (!getIt.isRegistered<DeleteInvitation>()) {
      getIt.registerLazySingleton<DeleteInvitation>(
        () => DeleteInvitation(
          invitationRepository: getIt<InvitationRepository>(),
        ),
      );
    }

    if (!getIt.isRegistered<ToggleInvitationSentStatus>()) {
      getIt.registerLazySingleton<ToggleInvitationSentStatus>(
        () => ToggleInvitationSentStatus(
          invitationRepository: getIt<InvitationRepository>(),
        ),
      );
    }

    if (!getIt.isRegistered<GetGuests>()) {
      getIt.registerLazySingleton<GetGuests>(
        () => GetGuests(
          invitationRepository: getIt<InvitationRepository>(),
        ),
      );
    }

    if (!getIt.isRegistered<UpdateGuestRsvp>()) {
      getIt.registerLazySingleton<UpdateGuestRsvp>(
        () => UpdateGuestRsvp(
          invitationRepository: getIt<InvitationRepository>(),
        ),
      );
    }

    // Invitation Blocs / Cubits
    if (!getIt.isRegistered<InvitationCubit>()) {
      getIt.registerLazySingleton<InvitationCubit>(
        () => InvitationCubit(
          getInvitation: getIt<GetInvitation>(),
          updateGuestRsvp: getIt<UpdateGuestRsvp>(),
        ),
      );
    }
  }
}
