import "package:flutter/material.dart";

/// A reusable widget that combines continuous pulse scaling animation with interactive hover scaling.
class ScalingAnimatedWidget extends StatefulWidget {
  /// Creates a [ScalingAnimatedWidget].
  const ScalingAnimatedWidget({
    super.key,
    this.child,
    this.builder,
    this.onTap,
    this.pulseScaleEnd = 1.04,
    this.hoverScale = 1.04,
    this.pulseDuration = const Duration(milliseconds: 1400),
    this.hoverDuration = const Duration(milliseconds: 200),
  }) : assert(
          child != null || builder != null,
          "Either child or builder must be provided",
        );

  /// The child widget to display inside the scaling animation.
  final Widget? child;

  /// A builder function that provides the current hover state ([isHovered]).
  final Widget Function(BuildContext context, bool isHovered)? builder;

  /// Callback triggered when the widget is tapped.
  final VoidCallback? onTap;

  /// Target scale value for the continuous pulse animation (defaults to 1.04).
  final double pulseScaleEnd;

  /// Scale value when hovered (defaults to 1.04).
  final double hoverScale;

  /// Duration of one direction of the pulse animation (defaults to 1400ms).
  final Duration pulseDuration;

  /// Duration of the hover scale transition (defaults to 200ms).
  final Duration hoverDuration;

  @override
  State<ScalingAnimatedWidget> createState() => _ScalingAnimatedWidgetState();
}

class _ScalingAnimatedWidgetState extends State<ScalingAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.pulseDuration,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: widget.pulseScaleEnd,
    ).animate(
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
    final content = widget.builder != null
        ? widget.builder!(context, _isHovered)
        : widget.child!;

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? widget.hoverScale : 1,
          duration: widget.hoverDuration,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: content,
          ),
        ),
      ),
    );
  }
}
