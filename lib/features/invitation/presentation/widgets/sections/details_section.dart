import "dart:math" as Math;

import "package:flutter/material.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../core/gen/adobe_fonts.dart";
import "../../../../../core/gen/assets.gen.dart";
import "../../../../../core/gen/fonts.gen.dart";

/// A section widget that displays the event details CTA card over a background image of the couple hugging.
class DetailsSection extends StatefulWidget {
  /// Creates a [DetailsSection].
  const DetailsSection({
    super.key,
    this.onTap,
  });

  /// Callback when the details card is tapped.
  final VoidCallback? onTap;

  @override
  State<DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<DetailsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sectionHeight = MediaQuery.of(context).size.height;

    final cardWidth = getValueForScreenType<double>(
      context: context,
      mobile: 450,
      tablet: 600,
      desktop: 600,
    );

    return Container(
      width: double.infinity,
      height: sectionHeight,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Assets.images.couple.hug.provider(),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: MouseRegion(
            cursor: widget.onTap != null
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedScale(
                scale: _isHovered ? 1.04 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      width: cardWidth,
                      height: cardWidth,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 1. Center background ribbon (Blue badge)
                          Positioned.fill(
                            child: Assets.images.ribbons.blue.image(
                              fit: BoxFit.fill,
                              filterQuality: FilterQuality.high,
                            ),
                          ),

                          // 2. White frame inside the blue ribbon background
                          Positioned.fill(
                            bottom: 20,
                            child: Padding(
                              padding: EdgeInsets.all(
                                getValueForScreenType<double>(
                                  context: context,
                                  mobile: 45,
                                  tablet: 55,
                                  desktop: 60,
                                ),
                              ),
                              child: Transform.rotate(
                                angle: -99.837 * Math.pi / 180,
                                child: Assets.images.frames.white.image(
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            ),
                          ),

                          // 3. Content inside the frame
                          Positioned.fill(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: cardWidth * 0.16,
                                vertical: cardWidth * 0.14,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // "Detalles" Title
                                  Transform.rotate(
                                    angle: -10 * Math.pi / 180,
                                    child: Text(
                                      "Detalles",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: AdobeFonts.altesse,
                                        fontSize: cardWidth * 0.14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1B2A4A),
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: cardWidth * 0.02),

                                  // "Dale [click] para más información" CTA text
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Transform.rotate(
                                      angle: -10 * Math.pi / 180,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Dale ",
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontFamily:
                                                    FontFamily.untoldHistory,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 2,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1B2A4A),
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Text(
                                                "click",
                                                style: context
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: Colors.white,
                                                  fontFamily:
                                                      FontFamily.untoldHistory,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              " para más información",
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontFamily:
                                                    FontFamily.untoldHistory,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10,
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
                        ],
                      ),
                    ),
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
