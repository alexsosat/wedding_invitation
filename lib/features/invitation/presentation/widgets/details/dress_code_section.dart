import "package:flutter/material.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../core/gen/adobe_fonts.dart";
import "../../../../../core/gen/assets.gen.dart";
import "../../../../../core/gen/fonts.gen.dart";

/// Section that displays the Dress Code information.
class DressCodeSection extends StatelessWidget {
  /// Creates a [DressCodeSection] widget.
  const DressCodeSection({super.key});

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
    final bodyTextSize = getValueForScreenType<double>(
      context: context,
      mobile: 16,
      tablet: 18,
      desktop: 20,
    );

    return Column(
      children: [
        /// Section Title
        Text(
          "Dress Code",
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

        /// Cups Illustration
        Assets.images.symbols.cups.svg(
          height: getValueForScreenType<double>(
            context: context,
            mobile: 70,
            tablet: 80,
            desktop: 90,
          ),
          colorFilter: ColorFilter.mode(
            context.colorScheme.primary,
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

        /// Subtitle / Category
        Text(
          "Formal de jardín",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: subtitleTextSize,
            fontFamily: FontFamily.untoldHistory,
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),

        /// Description paragraph 1
        Text(
          "Para que estés cómodo y puedas disfrutar de principio a fin, elegimos un código de vestimenta pensado especialmente para la ocasión.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: bodyTextSize,
            fontFamily: FontFamily.untoldHistory,
            color: context.colorScheme.primary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),

        /// Description paragraph 2 with highlighted text
        Text.rich(
          const TextSpan(
            text: "Te invitamos a vestir ",
            children: [
              TextSpan(
                text: "elegante",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: " y "),
              TextSpan(
                text: "cómodo",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: " para una "),
              TextSpan(
                text: "celebración al aire libre",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    ". Te recomendamos elegir un calzado adecuado para caminar sobre césped y disfrutar de cada momento con nosotros.",
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: bodyTextSize,
            fontFamily: FontFamily.untoldHistory,
            color: context.colorScheme.primary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
