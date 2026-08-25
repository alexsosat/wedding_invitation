import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../core/gen/adobe_fonts.dart";
import "../../../../../core/gen/assets.gen.dart";

/// Details Header Section
class HeaderSection extends StatelessWidget {
  /// Details Header Section
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: MediaQuery.sizeOf(context).height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.couple.hug.provider(),
            fit: BoxFit.cover,
          ),
        ),
        child: Transform.rotate(
          angle: -8 * math.pi / 180,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Detalles",
                style: TextStyle(
                  height: 0.8,
                  fontFamily: AdobeFonts.altesse,
                  fontSize: getValueForScreenType(
                    context: context,
                    mobile: 120,
                    tablet: 190,
                    desktop: 240,
                  ),
                  color: context.theme.scaffoldBackgroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Todo lo que necesitas saber",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontFamily: AdobeFonts.altesse,
                  fontSize: getValueForScreenType(
                    context: context,
                    mobile: 35,
                    tablet: 50,
                    desktop: 60,
                  ),
                  color: context.theme.scaffoldBackgroundColor,
                ),
              ),
            ],
          ),
        ),
      );
}
