import "package:flutter/material.dart";

import "../../../../core/gen/fonts.gen.dart";

/// Interactive call-to-action button prompting the user to open the invitation.
class EnvelopeCtaButton extends StatefulWidget {
  /// Creates an [EnvelopeCtaButton].
  const EnvelopeCtaButton({
    super.key,
    this.onTap,
  });

  /// Callback triggered when the CTA button is tapped.
  final VoidCallback? onTap;

  @override
  State<EnvelopeCtaButton> createState() => _EnvelopeCtaButtonState();
}

class _EnvelopeCtaButtonState extends State<EnvelopeCtaButton>
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

    _scaleAnimation = Tween<double>(begin: 1, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _isHovered
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
          ),
        ),
      );
}
