import "package:flutter/material.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../core/gen/adobe_fonts.dart";
import "../../../../../core/gen/assets.gen.dart";
import "../../../../../core/gen/fonts.gen.dart";

/// Section that displays the couple's history and story with illustrations.
class HistoryStorySection extends StatelessWidget {
  /// Creates a [HistoryStorySection].
  const HistoryStorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final bodyTextSize = getValueForScreenType<double>(
      context: context,
      mobile: 13.5,
      tablet: 15.5,
      desktop: 17,
    );

    final titleTextSize = getValueForScreenType<double>(
      context: context,
      mobile: 32,
      tablet: 44,
      desktop: 52,
    );

    final bodyTextStyle = TextStyle(
      fontSize: bodyTextSize,
      fontFamily: FontFamily.untoldHistory,
      fontWeight: FontWeight.bold,
      color: context.colorScheme.primary,
      height: 1.45,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        image: DecorationImage(
          image: Assets.images.couple.hug.provider(),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          opacity: 0.18,
        ),
      ),
      child: Column(
        children: [
          /// Top hanging stars
          SizedBox(
            width: double.infinity,
            child: Assets.images.symbols.stars.svg(
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          SizedBox(
            height: getValueForScreenType<double>(
              context: context,
              mobile: 16,
              tablet: 24,
              desktop: 32,
            ),
          ),

          /// Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Lo esencial es invisible a los ojos",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleTextSize,
                fontFamily: AdobeFonts.altesse,
                fontWeight: FontWeight.bold,
                color: context.colorScheme.primary,
                height: 1.2,
              ),
            ),
          ),
          SizedBox(
            height: getValueForScreenType<double>(
              context: context,
              mobile: 24,
              tablet: 36,
              desktop: 44,
            ),
          ),

          /// Story content container
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getValueForScreenType<double>(
                    context: context,
                    mobile: 20,
                    tablet: 32,
                    desktop: 40,
                  ),
                ),
                child: Column(
                  children: [
                    /// Block 1: Rose + Paragraph 1
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Assets.images.symbols.rose.svg(
                          height: getValueForScreenType<double>(
                            context: context,
                            mobile: 110,
                            tablet: 140,
                            desktop: 165,
                          ),
                        ),
                        SizedBox(
                          width: getValueForScreenType<double>(
                            context: context,
                            mobile: 14,
                            tablet: 20,
                            desktop: 28,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Nos conocimos una tarde de octubre, cuando ninguno de los dos estaba buscando encontrar a alguien. Nuestros amigos nos llevaron a compartir una tarde juntos, casi sin saber que, entre tantas salidas inventadas, conversaciones y pequeños momentos, empezaríamos a encontrarnos el uno en el otro.",
                            style: bodyTextStyle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getValueForScreenType<double>(
                        context: context,
                        mobile: 18,
                        tablet: 24,
                        desktop: 30,
                      ),
                    ),

                    /// Block 2: Paragraph 2 + Birds
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            "No teníamos los mismos gustos ni demasiadas cosas en común, pero descubrimos que siempre había algo que sí queríamos compartir: un poco más de tiempo juntos. Entre libros, series, paseos y días de universidad, fuimos construyendo una historia que, con sus altas y bajas, nos enseñó a acompañarnos y a estar ahí cuando más lo necesitábamos.",
                            style: bodyTextStyle,
                          ),
                        ),
                        SizedBox(
                          width: getValueForScreenType<double>(
                            context: context,
                            mobile: 10,
                            tablet: 16,
                            desktop: 20,
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Assets.images.symbols.starsBirds.svg(
                            width: getValueForScreenType<double>(
                              context: context,
                              mobile: 115,
                              tablet: 155,
                              desktop: 185,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getValueForScreenType<double>(
                        context: context,
                        mobile: 18,
                        tablet: 24,
                        desktop: 30,
                      ),
                    ),

                    /// Block 3: Fox + Paragraph 3
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Assets.images.symbols.fox.svg(
                          width: getValueForScreenType<double>(
                            context: context,
                            mobile: 100,
                            tablet: 130,
                            desktop: 155,
                          ),
                        ),
                        SizedBox(
                          width: getValueForScreenType<double>(
                            context: context,
                            mobile: 14,
                            tablet: 20,
                            desktop: 28,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Y así, casi sin darnos cuenta, aquel encuentro de octubre se convirtió en nuestro lugar favorito: el uno junto al otro.",
                            style: bodyTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: getValueForScreenType<double>(
              context: context,
              mobile: 40,
              tablet: 60,
              desktop: 80,
            ),
          ),
        ],
      ),
    );
  }
}
