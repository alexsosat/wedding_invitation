import "package:auto_route/auto_route.dart";
import "package:firebase_ui_auth/firebase_ui_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";

import "../../../../core/routes/app_router.gr.dart";
import "../widgets/admin_login_header.dart";
import "../widgets/admin_login_side_panel.dart";

/// Login page for the administration of invitations.
@RoutePage()
class LoginPage extends StatelessWidget {
  /// Creates a [LoginPage] instance.
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: context.colorScheme.surfaceBright,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              foregroundColor: context.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colorScheme.primary,
              side: BorderSide(
                color: context.colorScheme.primary.withValues(alpha: 0.5),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: context.colorScheme.primary,
            ),
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: context.colorScheme.primary,
              ),
              tooltip: "Regresar",
              onPressed: () {
                if (context.router.canNavigateBack) {
                  context.router.maybePop();
                } else {
                  context.router.back();
                }
              },
            ),
          ),
          extendBodyBehindAppBar: true,
          body: SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                context.router.replace(const AdminDashboardRoute());
              }),
              AuthStateChangeAction<UserCreated>((context, state) {
                context.router.replace(const AdminDashboardRoute());
              }),
            ],
            headerBuilder: (context, constraints, shrinkOffset) =>
                const AdminLoginHeader(),
            sideBuilder: (context, constraints) => const AdminLoginSidePanel(),
            subtitleBuilder: (context, action) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                action == AuthAction.signIn
                    ? "Ingresa tus credenciales para administrar las invitaciones"
                    : "Registra una cuenta de administración",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            footerBuilder: (context, action) => Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text(
                "© ${DateTime.now().year} Mayte & Alex • Administración",
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ),
      );
}
