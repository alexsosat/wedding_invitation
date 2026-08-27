import "dart:math" as math;

import "package:flutter/material.dart";

import "../../../../../core/gen/assets.gen.dart";
import "ribbon_recipient_text.dart";

/// Widget that displays the envelope composition including:
/// - The white lace background frame
/// - The main embossed cream envelope
/// - The monogrammed wax seal
/// - The personalized rose ribbon banner
class EnvelopeCard extends StatelessWidget {
  /// Creates an [EnvelopeCard].
  const EnvelopeCard({
    required this.recipientName,
    super.key,
    this.onTap,
    this.ribbonFadeAnimation,
    this.ribbonScaleAnimation,
  });

  /// The name of the guest or recipient to display on the ribbon.
  final String recipientName;

  /// Callback when the envelope or seal is tapped.
  final VoidCallback? onTap;

  /// Optional fade animation for the ribbon.
  final Animation<double>? ribbonFadeAnimation;

  /// Optional scale animation for the ribbon.
  final Animation<double>? ribbonScaleAnimation;

  @override
  Widget build(BuildContext context) {
    const double frameWidth = 356;
    const double frameHeight = 267;
    const double envelopeWidth = 400;
    const double envelopeHeight = 235;

    return MouseRegion(
      cursor:
          onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: frameWidth + 30,
          height: frameHeight + 20,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // 1. White Lace Frame (Doily)
              Positioned(
                top: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: frameWidth,
                    height: frameHeight,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Assets.images.frames.white.image(
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Embossed White/Cream Envelope
              Positioned(
                top: 25,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: envelopeWidth,
                    height: envelopeHeight,
                    child: Assets.images.envelopes.main.image(
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),

              // 3. Wax Seal centered at the flap tip
              Positioned(
                top: 128,
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: Assets.images.seals.waxSeal.image(
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),

              // 4. Rose Ribbon with Guest Name
              if (recipientName.isNotEmpty)
                Positioned(
                  left: -70,
                  bottom: -40,
                  child: _wrapWithRibbonAnimation(
                    child: SizedBox(
                      width: 350,
                      height: 175,
                      child: Transform.rotate(
                        angle: 8 * math.pi / 180,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Assets.images.ribbons.pinkHorizontal.image(
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                            ),
                            Positioned.fill(
                              child: RibbonRecipientText(
                                recipientName: recipientName,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wrapWithRibbonAnimation({required Widget child}) {
    Widget animated = child;
    if (ribbonScaleAnimation != null) {
      animated = ScaleTransition(
        scale: ribbonScaleAnimation!,
        child: animated,
      );
    }
    if (ribbonFadeAnimation != null) {
      animated = FadeTransition(
        opacity: ribbonFadeAnimation!,
        child: animated,
      );
    }
    return animated;
  }
}
