import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../core/gen/adobe_fonts.dart";
import "../../../../../core/gen/assets.gen.dart";

/// Header of the history section
class HistoryHeader extends StatelessWidget {
  /// Header of the history section
  const HistoryHeader({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: MediaQuery.sizeOf(context).height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.couple.hands.provider(),
            fit: BoxFit.cover,
          ),
        ),
        child: Transform.rotate(
          angle: -8 * math.pi / 180,
          child: Text(
            "Nuestra historia",
            textAlign: TextAlign.center,
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
        ),
      );
}
