import "package:flutter/material.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:responsive_builder/responsive_builder.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../../../core/gen/adobe_fonts.dart";
import "../../../../../core/gen/assets.gen.dart";
import "../../../../../core/gen/fonts.gen.dart";

import "schedule_section.dart";

/// Details Content Widget
class DetailsContent extends StatelessWidget {
  /// Creates a [DetailsContent] widget
  const DetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final titleTextSize = getValueForScreenType<double>(
      context: context,
      mobile: 45,
      tablet: 55,
      desktop: 65,
    );
    final subtitleTextSize = getValueForScreenType<double>(
      context: context,
      mobile: 18,
      tablet: 22,
      desktop: 24,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 40,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.secondaryContainer,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            context.theme.scaffoldBackgroundColor,
            BlendMode.srcIn,
          ),
          fit: BoxFit.cover,
          image: Assets.images.textures.flowersTransparent.provider(),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            children: [
              /// Starting text
              Text(
                "Queremos que disfrutes de esta celebración tanto como nosotros. Aquí vas a encontrar lo necesario para acompañarnos y compartir cada momento.",
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.untoldHistory,
                ),
              ),
              const SizedBox(height: 40),

              /// Big date section
              _MainInfo(
                titleTextSize: titleTextSize,
                subtitleTextSize: subtitleTextSize,
              ),
              SizedBox(
                height: getValueForScreenType<double>(
                  context: context,
                  mobile: 50,
                  tablet: 60,
                  desktop: 80,
                ),
              ),

              /// Cronograma / Schedule timeline section
              const ScheduleSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainInfo extends StatelessWidget {
  const _MainInfo({
    required this.titleTextSize,
    required this.subtitleTextSize,
  });

  final double titleTextSize;
  final double subtitleTextSize;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Assets.images.symbols.bird.svg(
            height: getValueForScreenType(
              context: context,
              mobile: 150,
              tablet: 160,
              desktop: 190,
            ),
            colorFilter: ColorFilter.mode(
              context.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          Text(
            "El Gran Día",
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.3,
              fontSize: getValueForScreenType(
                context: context,
                mobile: 50,
                tablet: 60,
                desktop: 70,
              ),
              fontFamily: AdobeFonts.altesse,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Domingo 8 de noviembre",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: subtitleTextSize,
              fontFamily: FontFamily.untoldHistory,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: getValueForScreenType(
              context: context,
              mobile: 40,
              tablet: 40,
              desktop: 60,
            ),
          ),
          Text(
            "Horario",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: titleTextSize,
              fontFamily: AdobeFonts.altesse,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "4:30 p.m.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: subtitleTextSize,
              fontFamily: FontFamily.untoldHistory,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: getValueForScreenType(
              context: context,
              mobile: 40,
              tablet: 40,
              desktop: 60,
            ),
          ),
          Text(
            "Ubicación",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: titleTextSize,
              fontFamily: AdobeFonts.altesse,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "El Chalet Del Barrial",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: subtitleTextSize,
              fontFamily: FontFamily.untoldHistory,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "San Roberto 152, El barrial, Santiago N.L",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: subtitleTextSize,
              fontFamily: FontFamily.untoldHistory,
            ),
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: _openMaps,
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              foregroundColor: context.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Ver en Google Maps",
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.secondaryContainer,
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.untoldHistory,
              ),
            ),
          ),
        ],
      );

  Future<void> _openMaps() async {
    final uri = Uri.parse(
      "https://www.google.com/maps/place/El+Chalet+Del+Barrial/@25.4803788,-100.1879203,17z/data=!3m1!4b1!4m6!3m5!1s0x8662c911e140994b:0x4a70f99c4fa07f9a!8m2!3d25.480374!4d-100.1853454!16s%2Fg%2F11jd8pb5t8?entry=ttu&g_ep=EgoyMDI2MDgyMy4wIKXMDSoASAFQAw%3D%3D",
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
