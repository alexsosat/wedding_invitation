import "package:flutter/material.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../core/gen/adobe_fonts.dart";
import "../../../../../core/gen/assets.gen.dart";
import "../../../../../core/gen/fonts.gen.dart";

/// Section that displays the wedding schedule timeline.
class ScheduleSection extends StatelessWidget {
  /// Creates a [ScheduleSection] widget.
  const ScheduleSection({super.key});

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

    return Column(
      children: [
        /// Section Title
        Text(
          "Cronograma",
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.3,
            fontSize: titleTextSize,
            fontFamily: AdobeFonts.altesse,
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),

        /// Subtitle / Description
        Text(
          "Y para que no te pierdas nada, te compartimos cómo será el recorrido de esta celebración",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: subtitleTextSize,
            fontFamily: FontFamily.untoldHistory,
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
        SizedBox(
          height: getValueForScreenType<double>(
            context: context,
            mobile: 28,
            tablet: 36,
            desktop: 44,
          ),
        ),

        /// Timeline Items
        _TimelineItem(
          isFirst: true,
          illustration: Assets.images.symbols.couple.svg(
            height: getValueForScreenType<double>(
              context: context,
              mobile: 72,
              tablet: 82,
              desktop: 90,
            ),
            colorFilter: ColorFilter.mode(
              context.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          time: "4:30 p.m.",
          title: "Ceremonia",
        ),
        _TimelineItem(
          illustration: Assets.images.symbols.camera.svg(
            height: getValueForScreenType<double>(
              context: context,
              mobile: 46,
              tablet: 54,
              desktop: 58,
            ),
            colorFilter: ColorFilter.mode(
              context.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          time: "5:30 p.m.",
          title: "Fotos familiares",
        ),
        _TimelineItem(
          illustration: Assets.images.symbols.cake.svg(
            height: getValueForScreenType<double>(
              context: context,
              mobile: 68,
              tablet: 76,
              desktop: 84,
            ),
            colorFilter: ColorFilter.mode(
              context.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          time: "6:30 p.m.",
          title: "Recepción",
        ),
        _TimelineItem(
          isLast: true,
          illustration: Assets.images.symbols.car.svg(
            height: getValueForScreenType<double>(
              context: context,
              mobile: 62,
              tablet: 72,
              desktop: 78,
            ),
            colorFilter: ColorFilter.mode(
              context.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          time: "9:30 p.m.",
          title: "Despedida y\nfin del evento",
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.illustration,
    required this.time,
    required this.title,
    this.isFirst = false,
    this.isLast = false,
  });

  final Widget illustration;
  final String time;
  final String title;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final heartSize = getValueForScreenType<double>(
      context: context,
      mobile: 36,
      tablet: 40,
      desktop: 44,
    );
    final verticalPadding = getValueForScreenType<double>(
      context: context,
      mobile: 14,
      tablet: 18,
      desktop: 22,
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Left column: Illustration
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: getValueForScreenType<double>(
                    context: context,
                    mobile: 16,
                    tablet: 24,
                    desktop: 28,
                  ),
                  top: verticalPadding,
                  bottom: verticalPadding,
                ),
                child: illustration,
              ),
            ),
          ),

          /// Center column: Heart node & vertical timeline line
          SizedBox(
            width: heartSize + 12,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                if (!isFirst)
                  Positioned.fill(
                    top: getValueForScreenType(
                      context: context,
                      mobile: -100,
                      tablet: -105,
                      desktop: -120,
                    ),
                    child: Center(
                      child: Container(
                        width: 3.5,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                Assets.images.symbols.heart.svg(
                  width: heartSize,
                  height: heartSize,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),

          /// Right column: Time badge + Title
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: getValueForScreenType<double>(
                    context: context,
                    mobile: 16,
                    tablet: 24,
                    desktop: 28,
                  ),
                  top: verticalPadding,
                  bottom: verticalPadding,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          fontFamily: FontFamily.untoldHistory,
                          color: context.colorScheme.onPrimary,
                          fontSize: getValueForScreenType<double>(
                            context: context,
                            mobile: 12,
                            tablet: 14,
                            desktop: 15,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: FontFamily.untoldHistory,
                        fontSize: getValueForScreenType<double>(
                          context: context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 20,
                        ),
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.primary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
