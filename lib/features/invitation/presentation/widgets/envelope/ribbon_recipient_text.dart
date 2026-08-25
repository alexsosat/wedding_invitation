import "dart:math" as math;
import "dart:ui" as ui;

import "package:flutter/material.dart";

import "../../../../../core/gen/adobe_fonts.dart";

/// A widget that renders recipient text curved along a path matching the rose ribbon.
class RibbonRecipientText extends StatelessWidget {
  /// Creates a [RibbonRecipientText].
  const RibbonRecipientText({
    required this.recipientName,
    super.key,
    this.prefix = "para: ",
    this.prefixStyle,
    this.nameStyle,
  });

  /// The name of the recipient to curve along the ribbon.
  final String recipientName;

  /// The prefix displayed before the recipient name (e.g. "para: ").
  final String prefix;

  /// Custom style for the prefix text.
  final TextStyle? prefixStyle;

  /// Custom style for the recipient name text.
  final TextStyle? nameStyle;

  @override
  Widget build(BuildContext context) {
    final effectivePrefixStyle = prefixStyle ??
        TextStyle(
          fontFamily: AdobeFonts.altesse,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2E2638),
          shadows: [
            Shadow(
              color: Colors.white.withValues(alpha: 0.6),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        );

    final effectiveNameStyle = nameStyle ??
        TextStyle(
          fontFamily: AdobeFonts.altesse,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2E2638),
          shadows: [
            Shadow(
              color: Colors.white.withValues(alpha: 0.6),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        );

    return LayoutBuilder(
      builder: (context, constraints) => CustomPaint(
        size: Size(constraints.maxWidth, constraints.maxHeight),
        painter: _CurvedTextPainter(
          prefix: prefix,
          recipientName: recipientName,
          prefixStyle: effectivePrefixStyle,
          nameStyle: effectiveNameStyle,
        ),
      ),
    );
  }
}

class _CurvedTextPainter extends CustomPainter {
  const _CurvedTextPainter({
    required this.prefix,
    required this.recipientName,
    required this.prefixStyle,
    required this.nameStyle,
  });

  final String prefix;
  final String recipientName;
  final TextStyle prefixStyle;
  final TextStyle nameStyle;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }

    // Build the curve path alongside the ribbon surface
    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.43)
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.33,
        size.width * 0.40,
        size.height * 0.6,
        size.width * 0.76,
        size.height * 0.55,
      );

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) {
      return;
    }

    final metric = metrics.first;
    final pathLength = metric.length;

    // Collect all glyphs with their respective styles
    final glyphs = <_GlyphInfo>[];
    double totalWidth = 0;

    void addGlyphs(String text, TextStyle style) {
      for (int i = 0; i < text.length; i++) {
        final char = text[i];
        final painter = TextPainter(
          text: TextSpan(text: char, style: style),
          textDirection: TextDirection.ltr,
        )..layout();

        final width = painter.width;
        glyphs.add(_GlyphInfo(painter: painter, width: width));
        totalWidth += width;
      }
    }

    addGlyphs(prefix, prefixStyle);
    addGlyphs(recipientName, nameStyle);

    if (glyphs.isEmpty) {
      return;
    }

    // Center text along the curve or scale if needed
    double startOffset = (pathLength - totalWidth) / 2;
    double scaleFactor = 1;

    if (totalWidth > pathLength * 0.95 && totalWidth > 0) {
      scaleFactor = (pathLength * 0.95) / totalWidth;
      startOffset = pathLength * 0.025;
    }

    double currentDistance = math.max(0, startOffset);

    for (final glyph in glyphs) {
      final glyphAdvance = glyph.width * scaleFactor;
      final centerDistance = currentDistance + glyphAdvance / 2;

      if (centerDistance >= 0 && centerDistance <= pathLength) {
        final ui.Tangent? tangent = metric.getTangentForOffset(centerDistance);
        if (tangent != null) {
          canvas
            ..save()
            ..translate(tangent.position.dx, tangent.position.dy)
            ..rotate(math.atan2(tangent.vector.dy, tangent.vector.dx));

          if (scaleFactor != 1) {
            canvas.scale(scaleFactor, scaleFactor);
          }

          glyph.painter.paint(
            canvas,
            Offset(-glyph.width / 2, -glyph.painter.height * 0.65),
          );
          canvas.restore();
        }
      }

      currentDistance += glyphAdvance;
    }
  }

  @override
  bool shouldRepaint(covariant _CurvedTextPainter oldDelegate) =>
      oldDelegate.prefix != prefix ||
      oldDelegate.recipientName != recipientName ||
      oldDelegate.prefixStyle != prefixStyle ||
      oldDelegate.nameStyle != nameStyle;
}

class _GlyphInfo {
  const _GlyphInfo({
    required this.painter,
    required this.width,
  });

  final TextPainter painter;
  final double width;
}
