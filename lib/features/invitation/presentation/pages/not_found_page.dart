import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../core/gen/adobe_fonts.dart";
import "../../../../core/gen/assets.gen.dart";
import "../../../../core/gen/fonts.gen.dart";

/// Elegant 404 / Not Invited Page displayed when a slug is missing or not found in the guest list.
@RoutePage()
class NotFoundPage extends StatelessWidget {
  /// Creates a [NotFoundPage]
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.colorScheme.primary,
        body: Stack(
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

            // 2. Centered Content Card
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: getValueForScreenType<double>(
                      context: context,
                      mobile: 20,
                      tablet: 36,
                      desktop: 40,
                    ),
                    vertical: 30,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 580),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: getValueForScreenType<double>(
                          context: context,
                          mobile: 24,
                          tablet: 44,
                          desktop: 52,
                        ),
                        vertical: getValueForScreenType<double>(
                          context: context,
                          mobile: 36,
                          tablet: 48,
                          desktop: 56,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: context.theme.scaffoldBackgroundColor
                            .withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Couple Logo / Monogram
                          Assets.images.logos.logo.svg(
                            height: getValueForScreenType<double>(
                              context: context,
                              mobile: 65,
                              tablet: 80,
                              desktop: 90,
                            ),
                            colorFilter: ColorFilter.mode(
                              context.colorScheme.primary,
                              BlendMode.srcIn,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Script Title
                          Text(
                            "Con todo nuestro cariño",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AdobeFonts.altesse,
                              fontSize: getValueForScreenType<double>(
                                context: context,
                                mobile: 32,
                                tablet: 40,
                                desktop: 44,
                              ),
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.primary,
                              height: 1.1,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Decorative Divider
                          Container(
                            width: 60,
                            height: 1.5,
                            decoration: BoxDecoration(
                              color: context.colorScheme.secondary
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Heartfelt apology and gratitude message
                          Text(
                            "Queremos agradecerte de corazón tu cariño, tus bendiciones y tus buenos deseos en esta etapa tan especial de nuestras vidas.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FontFamily.untoldHistory,
                              fontSize: getValueForScreenType<double>(
                                context: context,
                                mobile: 14,
                                tablet: 15.5,
                                desktop: 16,
                              ),
                              color: context.colorScheme.onSurface,
                              height: 1.45,
                            ),
                          ),

                          const SizedBox(height: 14),

                          Text(
                            "Por cuestiones de espacio y capacidad del lugar, en esta ocasión no fue posible hacer una invitación presencial a todas las personas que apreciamos y quisiéramos tener con nosotros.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FontFamily.untoldHistory,
                              fontSize: getValueForScreenType<double>(
                                context: context,
                                mobile: 14,
                                tablet: 15.5,
                                desktop: 16,
                              ),
                              color: context.colorScheme.onSurface,
                              height: 1.45,
                            ),
                          ),

                          const SizedBox(height: 14),

                          Text(
                            "Sin embargo, sabemos que nos acompañas con el corazón y valoramos profundamente tu amistad y aprecio.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FontFamily.untoldHistory,
                              fontSize: getValueForScreenType<double>(
                                context: context,
                                mobile: 14,
                                tablet: 15.5,
                                desktop: 16,
                              ),
                              color: context.colorScheme.onSurface,
                              height: 1.45,
                            ),
                          ),

                          const SizedBox(height: 22),

                          // Closing signature & date
                          Text(
                            "¡Gracias por tus mejores deseos!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FontFamily.untoldHistory,
                              fontWeight: FontWeight.bold,
                              fontSize: getValueForScreenType<double>(
                                context: context,
                                mobile: 15,
                                tablet: 16.5,
                                desktop: 17,
                              ),
                              color: context.colorScheme.primary,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "08.11.2026",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FontFamily.gourmetLeFrenchScript,
                              fontSize: getValueForScreenType<double>(
                                context: context,
                                mobile: 20,
                                tablet: 24,
                                desktop: 26,
                              ),
                              color: context.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
