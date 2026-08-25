import "dart:math" as Math;
import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../../core/gen/assets.gen.dart";
import "../../../../../shared/presentation/widgets/scaling_animated_widget.dart";

/// Confirmation section for the invitation
class ConfirmationSection extends StatelessWidget {
  /// Confirmation section for the invitation
  const ConfirmationSection({super.key});

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          /// Background
          Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              image: DecorationImage(
                image: Assets.images.textures.flowersTransparent.provider(),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  context.colorScheme.primary.darken(5),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          /// Props
          SizedBox(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height,
            child: const _ConfirmationProps(),
          ),

          /// Envelope
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getValueForScreenType(
                  context: context,
                  mobile: 40,
                  tablet: 140,
                  desktop: 40,
                ),
                vertical: getValueForScreenType(
                  context: context,
                  mobile: 0,
                  tablet: 0,
                  desktop: 60,
                ),
              ),
              child: ScalingAnimatedWidget(
                child: Assets.images.envelopes.confirmation.image(),
              ),
            ),
          ),
        ],
      );
}

class _ConfirmationProps extends StatelessWidget {
  const _ConfirmationProps();

  @override
  Widget build(BuildContext context) {
    final cardsSize = getValueForScreenType<double>(
      context: context,
      mobile: 250,
      tablet: 450,
      desktop: 550,
    );
    return Stack(
      children: [
        Positioned(
          top: getValueForScreenType(
            context: context,
            mobile: -160,
            tablet: -360,
            desktop: -450,
          ),
          right: getValueForScreenType(
            context: context,
            mobile: -10,
            tablet: -40,
            desktop: -50,
          ),
          child: Transform.rotate(
            angle: -54 * Math.pi / 180,
            child: Assets.images.frames.white.image(
              width: cardsSize,
            ),
          ),
        ),
        Positioned(
          bottom: getValueForScreenType(
            context: context,
            mobile: -95,
            tablet: -170,
            desktop: -200,
          ),
          left: getValueForScreenType(
            context: context,
            mobile: -135,
            tablet: -250,
            desktop: -300,
          ),
          child: Transform.rotate(
            angle: -54 * Math.pi / 180,
            child: Assets.images.frames.white.image(
              width: cardsSize,
            ),
          ),
        ),
        Positioned(
          bottom: getValueForScreenType(
            context: context,
            mobile: -20,
            tablet: -40,
            desktop: -50,
          ),
          left: getValueForScreenType(
            context: context,
            mobile: -195,
            tablet: -350,
            desktop: -450,
          ),
          child: Transform.rotate(
            angle: -20 * Math.pi / 180,
            child: _ShadowProp(cardsSize),
          ),
        ),
      ],
    );
  }
}

class _ShadowProp extends StatelessWidget {
  const _ShadowProp(
    this.cardSize,
  );

  final double cardSize;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          // Shadow layer: offset, colored, and blurred
          Transform.translate(
            offset: const Offset(4, 4),
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.black38,
                  BlendMode.srcIn,
                ),
                child: Assets.images.frames.white.image(
                  width: cardSize,
                ),
              ),
            ),
          ),
          // Original image on top
          Assets.images.frames.white.image(
            width: cardSize,
          ),
        ],
      );
}
