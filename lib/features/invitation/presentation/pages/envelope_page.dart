import "dart:math" as math;

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";

import "../../../../core/gen/assets.gen.dart";
import "../../../../core/gen/fonts.gen.dart";
import "../widgets/envelope_card.dart";
import "../widgets/envelope_cta_button.dart";

/// Page to display the envelope of the wedding invitation.
///
/// Shows a romantic, textured envelope composition with:
/// - A floral textured dark navy background
/// - A script calligraphy invitation message
/// - A lace-framed envelope with wax seal and personalized guest ribbon
/// - A call to action to open the invitation
@RoutePage()
class EnvelopePage extends StatefulWidget {
  /// Creates an [EnvelopePage].
  const EnvelopePage({
    super.key,
    this.recipientName = "Abigail Lazcano",
    this.onOpen,
  });

  /// The name of the guest or recipient to display on the ribbon.
  final String recipientName;

  /// Callback when opening the invitation.
  final VoidCallback? onOpen;

  @override
  State<EnvelopePage> createState() => _EnvelopePageState();
}

class _EnvelopePageState extends State<EnvelopePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  void _handleOpenInvitation() {
    if (widget.onOpen != null) {
      widget.onOpen!();
    } else {
      // Default interactive feedback when tapped
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "¡Invitación abierta para ${widget.recipientName}!",
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: FontFamily.untoldHistory),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF30405F),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.colorScheme.primary,
        body: Stack(
          children: [
            // 1. Floral paper texture overlay on dark navy background
            Positioned.fill(
              child: Opacity(
                opacity: 0.16,
                child: Assets.images.textures.flowersTransparent.image(
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                ),
              ),
            ),

            // 2. Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 380,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Top calligraphy message (centered)
                              Assets.images.texts.envelopeTitle.svg(
                                width: 340,
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                                colorFilter: ColorFilter.mode(
                                  context.theme.scaffoldBackgroundColor,
                                  BlendMode.srcIn,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Envelope composite card (tilted to match the title calligraphy angle)
                              Transform.rotate(
                                angle: -8 * math.pi / 180,
                                child: EnvelopeCard(
                                  recipientName: widget.recipientName,
                                  onTap: _handleOpenInvitation,
                                ),
                              ),

                              const SizedBox(height: 14),

                              // CTA button (tilted to match envelope & title angle)
                              Transform.rotate(
                                angle: -8 * math.pi / 180,
                                child: EnvelopeCtaButton(
                                  onTap: _handleOpenInvitation,
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
          ],
        ),
      );
}
