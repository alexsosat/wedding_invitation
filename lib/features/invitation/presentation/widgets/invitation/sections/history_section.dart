import "dart:math" as math;

import "package:flutter/material.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../../core/gen/adobe_fonts.dart";
import "../../../../../../core/gen/assets.gen.dart";
import "../../../../../shared/presentation/widgets/scaling_animated_widget.dart";

/// A section widget that displays the "Nuestra historia" CTA card over a background image of the couple.
class HistorySection extends StatelessWidget {
  /// Creates a [HistorySection].
  const HistorySection({
    super.key,
    this.onTap,
  });

  /// Callback when the history card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final sectionHeight = MediaQuery.sizeOf(context).height;

    final badgeWidth = getValueForScreenType<double>(
      context: context,
      mobile: 300,
      tablet: 450,
      desktop: 450,
    );

    return Container(
      width: double.infinity,
      height: sectionHeight,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Assets.images.couple.view.provider(),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(
            right: getValueForScreenType(
              context: context,
              mobile: 20,
              tablet: 80,
              desktop: 180,
            ),
            bottom: getValueForScreenType(
              context: context,
              mobile: 60,
              tablet: 80,
              desktop: 90,
            ),
          ),
          child: ScalingAnimatedWidget(
            onTap: onTap,
            pulseScaleEnd: 1.03,
            hoverScale: 1.04,
            child: Transform.rotate(
              angle: -10 * math.pi / 180,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: badgeWidth,
                  height: badgeWidth * 0.72,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // White lace frame background
                      Positioned.fill(
                        child: Assets.images.frames.white.image(
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      ),

                      // Pink ribbon text background
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: badgeWidth * 0.07,
                            vertical: badgeWidth * 0.05,
                          ),
                          child: Assets.images.ribbons.pink.image(
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),

                      // "Nuestra historia" text
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: badgeWidth * 0.12,
                            vertical: badgeWidth * 0.08,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Nuestra",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AdobeFonts.altesse,
                                    fontSize: badgeWidth * 0.16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1B2A4A),
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  "historia",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AdobeFonts.altesse,
                                    fontSize: badgeWidth * 0.16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1B2A4A),
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
