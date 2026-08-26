import "package:firebase_ui_localizations/firebase_ui_localizations.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_common_classes/localization/l10n.dart";
import "package:flutter_flavor/flutter_flavor.dart";

import "core/config/dependency_injection.dart";
import "core/constants/theme/material_theme.dart";
import "core/constants/theme/util.dart";
import "core/routes/app_router.dart";
import "features/invitation/presentation/cubits/invitation_cubit.dart";

final _appRouter = AppRouter();

/// [BodaMaApp] is the entry point of the application.
class BodaMaApp extends StatelessWidget {
  /// [BodaMaApp] is the entry point of the application.
  const BodaMaApp({super.key});

  @override
  Widget build(BuildContext context) => FlavorBanner(
        child: BlocProvider<InvitationCubit>(
          create: (_) => getIt<InvitationCubit>(),
          child: MaterialApp.router(
            title: "BodaMa",
            debugShowCheckedModeBanner: false,

            //Theming
            themeMode: ThemeMode.light,
            theme: MaterialTheme(
              createTextTheme(context, "UntoldHistory", "altesse-std-24pt"),
            ).light(),
            darkTheme: MaterialTheme(
              createTextTheme(context, "UntoldHistory", "altesse-std-24pt"),
            ).dark(),

            routerConfig: _appRouter.config(),

            localizationsDelegates: const [
              FlutterCommonLocalizations.delegate,
              FirebaseUILocalizations.delegate,
            ],
          ),
        ),
      );
}
