import "package:flutter/material.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../core/gen/adobe_fonts.dart";
import "../../../../../core/gen/assets.gen.dart";
import "../../../../../core/gen/fonts.gen.dart";
import "../../../../shared/presentation/widgets/scaling_animated_widget.dart";

/// Content section for the RSVP page, including the lace invitation card,
/// confirmation CTA button, and gift registry note.
class RsvpContent extends StatelessWidget {
  /// Creates an [RsvpContent] widget.
  const RsvpContent({
    super.key,
    this.onConfirmTap,
  });

  /// Callback when the confirm attendance button is tapped.
  final VoidCallback? onConfirmTap;

  @override
  Widget build(BuildContext context) {
    final frameHeight = getValueForScreenType<double>(
      context: context,
      mobile: 390,
      tablet: 480,
      desktop: 540,
    );

    return Container(
      width: double.infinity,
      color: const Color(0xFFE2C4C9),
      padding: EdgeInsets.symmetric(
        horizontal: getValueForScreenType<double>(
          context: context,
          mobile: 16,
          tablet: 32,
          desktop: 40,
        ),
        vertical: getValueForScreenType<double>(
          context: context,
          mobile: 40,
          tablet: 55,
          desktop: 70,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Lace Frame Card
              _LaceInvitationCard(
                width: double.infinity,
                height: frameHeight,
              ),
              SizedBox(
                height: getValueForScreenType<double>(
                  context: context,
                  mobile: 32,
                  tablet: 40,
                  desktop: 48,
                ),
              ),

              /// Confirm Attendance CTA Button
              _ConfirmButton(onTap: onConfirmTap),
              SizedBox(
                height: getValueForScreenType<double>(
                  context: context,
                  mobile: 36,
                  tablet: 44,
                  desktop: 52,
                ),
              ),

              /// Gifts Section
              const _GiftsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LaceInvitationCard extends StatelessWidget {
  const _LaceInvitationCard({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: RotatedBox(
                quarterTurns: 1,
                child: Assets.images.frames.white.image(
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getValueForScreenType<double>(
                    context: context,
                    mobile: 80,
                    tablet: 130,
                    desktop: 130,
                  ),
                  vertical: height * 0.13,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¡Queremos disfrutar contigo!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AdobeFonts.altesse,
                        fontSize: getValueForScreenType<double>(
                          context: context,
                          mobile: 21,
                          tablet: 27,
                          desktop: 30,
                        ),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF682637),
                        height: 1.1,
                      ),
                    ),
                    SizedBox(
                      height: getValueForScreenType<double>(
                        context: context,
                        mobile: 15,
                        tablet: 20,
                        desktop: 20,
                      ),
                    ),
                    Text(
                      "Este momento no estaría completo sin las personas que queremos. Por eso, nos encantaría saber si vas a poder acompañarnos y compartir con nosotros esta celebración tan especial.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FontFamily.untoldHistory,
                        fontSize: getValueForScreenType<double>(
                          context: context,
                          mobile: 10.5,
                          tablet: 12.5,
                          desktop: 13.5,
                        ),
                        color: const Color(0xFF682637),
                        height: 1.35,
                      ),
                    ),
                    SizedBox(
                      height: getValueForScreenType<double>(
                        context: context,
                        mobile: 10,
                        tablet: 15,
                        desktop: 15,
                      ),
                    ),
                    Text(
                      "Te pedimos que confirmes tu asistencia antes del 15 de septiembre. Así podremos preparar todo con mucho cariño para recibirte.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FontFamily.untoldHistory,
                        fontSize: getValueForScreenType<double>(
                          context: context,
                          mobile: 10.5,
                          tablet: 12.5,
                          desktop: 13.5,
                        ),
                        color: const Color(0xFF682637),
                        height: 1.35,
                      ),
                    ),
                    SizedBox(
                      height: getValueForScreenType<double>(
                        context: context,
                        mobile: 20,
                        tablet: 30,
                        desktop: 30,
                      ),
                    ),
                    Text(
                      "¡Esperamos verte y celebrar juntos!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FontFamily.untoldHistory,
                        fontWeight: FontWeight.bold,
                        fontSize: getValueForScreenType<double>(
                          context: context,
                          mobile: 10.5,
                          tablet: 12.5,
                          desktop: 13.5,
                        ),
                        color: const Color(0xFF682637),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ScalingAnimatedWidget(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: getValueForScreenType<double>(
              context: context,
              mobile: 20,
              tablet: 28,
              desktop: 32,
            ),
            vertical: getValueForScreenType<double>(
              context: context,
              mobile: 12,
              tablet: 14,
              desktop: 16,
            ),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFC88A96),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            "DALE CLICK AQUÍ PARA CONFIRMAR TU ASISTENCIA",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FontFamily.untoldHistory,
              fontWeight: FontWeight.bold,
              fontSize: getValueForScreenType<double>(
                context: context,
                mobile: 12,
                tablet: 14,
                desktop: 15,
              ),
              color: Colors.white,
              letterSpacing: 0.6,
            ),
          ),
        ),
      );
}

class _GiftsSection extends StatelessWidget {
  const _GiftsSection();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.images.symbols.gifts.svg(
            height: getValueForScreenType<double>(
              context: context,
              mobile: 90,
              tablet: 110,
              desktop: 130,
            ),
            colorFilter: const ColorFilter.mode(
              Color(0xFF682637),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(
            height: getValueForScreenType<double>(
              context: context,
              mobile: 16,
              tablet: 20,
              desktop: 24,
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              "Su presencia en este día tan importante para nosotros es, sin duda, el regalo más especial. Pero si desean obsequiarnos algo, preferimos que sea en sobre o transferencia, para poder destinarlo a nuestros sueños y proyectos en esta nueva etapa que comenzamos juntos.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamily.untoldHistory,
                fontSize: getValueForScreenType<double>(
                  context: context,
                  mobile: 13,
                  tablet: 15,
                  desktop: 16,
                ),
                color: const Color(0xFF682637),
                height: 1.45,
              ),
            ),
          ),
        ],
      );
}
