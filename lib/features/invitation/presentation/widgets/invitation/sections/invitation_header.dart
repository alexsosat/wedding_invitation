import "package:flutter/material.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../../core/gen/assets.gen.dart";
import "../../../../../../core/gen/fonts.gen.dart";

/// Header of the invitation
class InvitationHeader extends StatelessWidget {
  /// Header of the invitation
  const InvitationHeader({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height +
            getValueForScreenType<double>(
              context: context,
              mobile: 30,
              tablet: 30,
              desktop: 60,
            ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.couple.hands.provider(),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 40,
                  bottom: 40,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "08.11.2026",
                      style: context.textTheme.headlineLarge?.copyWith(
                        fontFamily: FontFamily.gourmetLeFrenchScript,
                        color: context.theme.scaffoldBackgroundColor,
                      ),
                    ),
                    const SizedBox(height: 60),
                    Flexible(
                      child: Assets.images.logos.logo.svg(
                        colorFilter: ColorFilter.mode(
                          context.theme.scaffoldBackgroundColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Assets.images.texts.slug.svg(
                      colorFilter: ColorFilter.mode(
                        context.theme.scaffoldBackgroundColor,
                        BlendMode.srcIn,
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
