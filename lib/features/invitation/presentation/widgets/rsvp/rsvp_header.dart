import "package:flutter/material.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../core/gen/assets.gen.dart";

/// Header section for the RSVP page.
class RsvpHeader extends StatelessWidget {
  /// Creates a [RsvpHeader] widget.
  const RsvpHeader({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: const Color(0xFFb0cae5),
          image: DecorationImage(
            image: Assets.images.textures.flowersTransparent.provider(),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            colorFilter: ColorFilter.mode(
              context.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Assets.images.envelopes.rsvpEnvelope.image(
            height: getValueForScreenType(
              context: context,
              mobile: 350,
              tablet: 600,
              desktop: 700,
            ),
          ),
        ),
      );
}
