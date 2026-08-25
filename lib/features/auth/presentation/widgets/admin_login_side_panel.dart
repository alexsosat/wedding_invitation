import "package:flutter/material.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";

import "../../../../core/gen/adobe_fonts.dart";
import "../../../../core/gen/assets.gen.dart";

/// Side panel displayed on wide screens for the admin login screen.
class AdminLoginSidePanel extends StatelessWidget {
  /// Creates an [AdminLoginSidePanel] instance.
  const AdminLoginSidePanel({super.key});

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.primary,
          image: DecorationImage(
            image: Assets.images.textures.flowersTransparent.provider(),
            fit: BoxFit.cover,
            opacity: 0.08,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.images.logos.mayteAlex.svg(
                  width: 140,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.onPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Mayte & Alex",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AdobeFonts.altesse,
                    fontSize: 56,
                    color: context.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 60,
                  height: 2,
                  color: context.colorScheme.secondary,
                ),
                const SizedBox(height: 16),
                Text(
                  "Gestión de invitados y confirmaciones",
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color:
                        context.colorScheme.onPrimary.withValues(alpha: 0.85),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
