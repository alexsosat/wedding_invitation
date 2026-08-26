import "package:flutter/material.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";

import "../../../../core/gen/adobe_fonts.dart";
import "../../../../core/gen/assets.gen.dart";

/// Header widget for the administration login page.
class AdminLoginHeader extends StatelessWidget {
  /// Creates an [AdminLoginHeader] instance.
  const AdminLoginHeader({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.primaryContainer
                        .withValues(alpha: 0.15),
                    border: Border.all(
                      color: context.colorScheme.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Assets.images.logos.logo.svg(
                    width: 50,
                    height: 50,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Administración",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AdobeFonts.altesse,
                    fontSize: 44,
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        context.colorScheme.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          context.colorScheme.secondary.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    "Panel de Invitaciones",
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
