import "package:flutter/widgets.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../../core/gen/adobe_fonts.dart";
import "../../../../../../core/gen/assets.gen.dart";

/// Last section of the invitation
class FooterSection extends StatelessWidget {
  /// Last section of the invitation
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: MediaQuery.sizeOf(context).height * 0.75,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.textures.flowersTransparent.provider(),
            opacity: 0.3,
            colorFilter: ColorFilter.mode(
              context.colorScheme.primary,
              BlendMode.srcIn,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: getValueForScreenType(
                  context: context,
                  mobile: 20,
                  tablet: 80,
                  desktop: 180,
                ),
              ),
              child: Text(
                "Con mucho amor",
                style: TextStyle(
                  fontSize: getValueForScreenType(
                    context: context,
                    mobile: 40,
                    tablet: 60,
                    desktop: 70,
                  ),
                  color: context.colorScheme.primary,
                  fontFamily: AdobeFonts.altesse,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: getValueForScreenType(
                context: context,
                mobile: 20,
                tablet: 60,
                desktop: 60,
              ),
            ),
            Center(
              child: Assets.images.logos.logo.svg(
                height: getValueForScreenType(
                  context: context,
                  mobile: 200,
                  tablet: 250,
                  desktop: 350,
                ),
                colorFilter: ColorFilter.mode(
                  context.colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      );
}
