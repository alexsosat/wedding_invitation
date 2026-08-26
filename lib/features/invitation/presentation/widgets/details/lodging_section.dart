import "package:flutter/material.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:responsive_builder/responsive_builder.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../../../core/gen/adobe_fonts.dart";
import "../../../../../core/gen/assets.gen.dart";
import "../../../../../core/gen/fonts.gen.dart";

/// Section that displays lodging/hotel recommendations.
class LodgingSection extends StatelessWidget {
  /// Creates a [LodgingSection] widget.
  const LodgingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final titleTextSize = getValueForScreenType<double>(
      context: context,
      mobile: 45,
      tablet: 55,
      desktop: 65,
    );
    final hotelSpacing = getValueForScreenType<double>(
      context: context,
      mobile: 24,
      tablet: 28,
      desktop: 32,
    );

    return Column(
      children: [
        /// Section Title
        Text(
          "Hospedaje",
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.3,
            fontSize: titleTextSize,
            fontFamily: AdobeFonts.altesse,
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
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

        /// Phone Illustration
        Assets.images.symbols.phone.svg(
          height: getValueForScreenType<double>(
            context: context,
            mobile: 75,
            tablet: 85,
            desktop: 95,
          ),
        ),
        SizedBox(
          height: getValueForScreenType<double>(
            context: context,
            mobile: 20,
            tablet: 24,
            desktop: 28,
          ),
        ),

        /// Hotel 1
        const _HotelItem(
          name: "Hotel El Encino Santiago",
          address:
              "Hermenegildo Galeana 200,\nCol. Centro, 67310\nSantiago, N.L., México",
          website: "hotelelencino.com",
        ),
        SizedBox(height: hotelSpacing),

        /// Hotel 2
        const _HotelItem(
          name: "Gamma Monterrey Rincón de Santiago",
          address:
              "Camino a la Cortina 119-122,\nCongregación San Javier, 67323\nSantiago, N.L., México",
          website: "gammahoteles.com",
        ),
        SizedBox(height: hotelSpacing),

        /// Hotel 3
        const _HotelItem(
          name: "Hotel Hacienda Cola de Caballo",
          address:
              "Km. 6, Carr. a la Cola de Caballo,\nCieneguilla, 67320\nSantiago, N.L., México",
          website: "hotelhaciendacoladecaballo.com",
        ),
      ],
    );
  }
}

class _HotelItem extends StatelessWidget {
  const _HotelItem({
    required this.name,
    required this.address,
    required this.website,
  });

  final String name;
  final String address;
  final String website;

  @override
  Widget build(BuildContext context) {
    final nameTextSize = getValueForScreenType<double>(
      context: context,
      mobile: 18,
      tablet: 20,
      desktop: 22,
    );
    final addressTextSize = getValueForScreenType<double>(
      context: context,
      mobile: 15,
      tablet: 16,
      desktop: 17,
    );

    return Column(
      children: [
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: nameTextSize,
            fontFamily: FontFamily.untoldHistory,
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          address,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: addressTextSize,
            fontFamily: FontFamily.untoldHistory,
            color: context.colorScheme.primary,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: () => _openWebsite(website),
          style: FilledButton.styleFrom(
            backgroundColor: context.colorScheme.primary,
            foregroundColor: context.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            website,
            style: TextStyle(
              fontFamily: FontFamily.untoldHistory,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: context.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openWebsite(String url) async {
    final uri = Uri.parse(url.startsWith("http") ? url : "https://$url");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
