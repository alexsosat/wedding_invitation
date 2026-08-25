import "package:flutter/material.dart";

import "../../../../../core/gen/fonts.gen.dart";
import "../../../../shared/presentation/widgets/scaling_animated_widget.dart";

/// Interactive call-to-action button prompting the user to open the invitation.
class EnvelopeCtaButton extends StatelessWidget {
  /// Creates an [EnvelopeCtaButton].
  const EnvelopeCtaButton({
    super.key,
    this.onTap,
  });

  /// Callback triggered when the CTA button is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ScalingAnimatedWidget(
        onTap: onTap,
        pulseScaleEnd: 1.04,
        hoverScale: 1,
        builder: (context, isHovered) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isHovered
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.transparent,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "DALE ",
                  style: TextStyle(
                    fontFamily: FontFamily.untoldHistory,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.1,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1.5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Text(
                    "CLICK",
                    style: TextStyle(
                      fontFamily: FontFamily.untoldHistory,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF273656),
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Text(
                  " PARA ABRIR TU INVITACIÓN",
                  style: TextStyle(
                    fontFamily: FontFamily.untoldHistory,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.1,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
