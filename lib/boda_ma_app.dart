import "package:flutter/material.dart";
import "package:flutter_common_classes/localization/l10n.dart";
import "package:flutter_flavor/flutter_flavor.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:form_builder_validators/localization/l10n.dart";
import "package:get/get.dart";
import "package:toastification/toastification.dart";

import "core/constants/theme/material_theme.dart";
import "core/routes/app_router.dart";
import "core/routes/names.dart";
import "features/unknown/presentation/pages/unknown_page.dart";

/// [BodaMaApp] is the entry point of the application.
class BodaMaApp extends StatelessWidget {
  /// [BodaMaApp] is the entry point of the application.
  const BodaMaApp({super.key});

  @override
  Widget build(BuildContext context) => FlavorBanner(
        child: ToastificationWrapper(
          child: GetMaterialApp(
            title: "BodaMa",
            debugShowCheckedModeBanner: false,

            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FlutterCommonLocalizations.delegate,
              FormBuilderLocalizations.delegate,
            ],

            supportedLocales: const [
              Locale("en"),
              Locale("es"),
            ],
            locale: const Locale("es"),
            fallbackLocale: const Locale("es"),

            //Theming
            themeMode: ThemeMode.system,
            theme: MaterialTheme(
              TextTheme(bodyLarge: TextStyle(fontFamily: "Poppins")),
            ).light(),
            darkTheme: MaterialTheme(
              TextTheme(bodyLarge: TextStyle(fontFamily: "Poppins")),
            ).dark(),

            // Routing
            initialRoute: RoutesNames.initial("familia-ramirez"),
            unknownRoute: GetPage(
              name: RoutesNames.unknown,
              page: () => const UnknownPage(),
            ),
            getPages: AppRouter.routes,
          ),
        ),
      );
}
