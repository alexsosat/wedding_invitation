import "package:flutter/material.dart";
import "package:flutter_common_classes/localization/l10n.dart";
import "package:flutter_flavor/flutter_flavor.dart";
import "package:get/get.dart";

import "core/constants/theme/material_theme.dart";
import "core/constants/theme/util.dart";
import "core/routes/app_router.dart";
import "core/routes/names.dart";
import "features/unknown/presentation/pages/unknown_page.dart";

/// [BodaMaApp] is the entry point of the application.
class BodaMaApp extends StatelessWidget {
  /// [BodaMaApp] is the entry point of the application.
  const BodaMaApp({super.key});

  @override
  Widget build(BuildContext context) => FlavorBanner(
        child: GetMaterialApp(
          title: "BodaMa",
          debugShowCheckedModeBanner: false,

          localizationsDelegates: const [
            FlutterCommonLocalizations.delegate,
          ],

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
      );
}
