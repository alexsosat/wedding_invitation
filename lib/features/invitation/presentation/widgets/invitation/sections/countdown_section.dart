import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../../core/gen/adobe_fonts.dart";
import "../../../../../../core/gen/assets.gen.dart";
import "../../../../../../core/gen/fonts.gen.dart";

/// A section widget that displays the wedding countdown timer and welcome message.
class CountdownSection extends StatelessWidget {
  /// Creates a [CountdownSection].
  const CountdownSection({
    super.key,
    this.targetDate,
  });

  /// Target wedding date. Defaults to November 8, 2026.
  final DateTime? targetDate;

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFf7efea),
              image: DecorationImage(
                image: Assets.images.textures.flowersTransparent.provider(),
                fit: BoxFit.cover,
                alignment: const Alignment(0, 0.12),
                opacity: .5,
                colorFilter: ColorFilter.mode(
                  context.colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: getValueForScreenType<double>(
                        context: context,
                        mobile: 70,
                        tablet: 70,
                        desktop: 160,
                      ),
                    ),

                    // Countdown Digits and Labels
                    CountdownTimerText(
                      targetDate: targetDate,
                    ),
                    const SizedBox(height: 36),

                    // Pink Welcome Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 36,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Queremos que seas parte!",
                            style: context.textTheme.headlineLarge?.copyWith(
                              fontFamily: AdobeFonts.altesse,
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.onSecondaryContainer,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Estamos preparando una celebración muy especial y nos hace felices poder compartirlo con las personas que queremos.",
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontFamily: FontFamily.untoldHistory,
                              color: context.colorScheme.onSecondaryContainer,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Creamos este espacio para compartir un poquito de todo lo que nos trajo hasta este momento y para que puedas encontrar, en un mismo lugar, todos los detalles de este día que esperamos con tanta ilusión",
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontFamily: FontFamily.untoldHistory,
                              color: context.colorScheme.onSecondaryContainer,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Nos entusiasma saber que podremos compartir este momento contigo y guardar juntos nuevos recuerdos.",
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontFamily: FontFamily.untoldHistory,
                              color: context.colorScheme.onSecondaryContainer,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Con cariño,",
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontFamily: FontFamily.untoldHistory,
                              color: context.colorScheme.onSecondaryContainer,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: Assets.images.logos.mayteAlex.svg(
                              width: 150,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getValueForScreenType<double>(
                        context: context,
                        mobile: 70,
                        tablet: 70,
                        desktop: 160,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FractionalTranslation(
              translation: const Offset(0, -0.45),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Assets.images.texts.countDown.svg(),
                ),
              ),
            ),
          ),
        ],
      );
}

/// A stateful widget that displays the ticking countdown timer digits and labels.
class CountdownTimerText extends StatefulWidget {
  /// Creates a [CountdownTimerText].
  const CountdownTimerText({
    super.key,
    this.targetDate,
  });

  /// Target wedding date. Defaults to November 8, 2026.
  final DateTime? targetDate;

  @override
  State<CountdownTimerText> createState() => _CountdownTimerTextState();
}

class _CountdownTimerTextState extends State<CountdownTimerText> {
  late Timer _timer;
  late DateTime _targetDate;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _targetDate = widget.targetDate ?? DateTime(2026, 11, 8, 16);
    _calculateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateRemaining();
    });
  }

  void _calculateRemaining() {
    final now = DateTime.now();
    final difference = _targetDate.difference(now);
    if (mounted) {
      setState(() {
        _remaining = difference.isNegative ? Duration.zero : difference;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _remaining.inDays.toString().padLeft(2, "0");
    final hours = (_remaining.inHours % 24).toString().padLeft(2, "0");
    final minutes = (_remaining.inMinutes % 60).toString().padLeft(2, "0");

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CountdownColumn(
          value: days,
          label: "DÍAS",
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            ":",
            style: TextStyle(
              fontFamily: FontFamily.untoldHistory,
              fontSize: 44,
              fontWeight: FontWeight.w400,
              color: Color(0xFF30405F),
            ),
          ),
        ),
        _CountdownColumn(
          value: hours,
          label: "HORAS",
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            ":",
            style: TextStyle(
              fontFamily: FontFamily.untoldHistory,
              fontSize: 44,
              fontWeight: FontWeight.w400,
              color: Color(0xFF30405F),
            ),
          ),
        ),
        _CountdownColumn(
          value: minutes,
          label: "MINUTOS",
        ),
      ],
    );
  }
}

class _CountdownColumn extends StatelessWidget {
  const _CountdownColumn({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: FontFamily.gourmetLeFrench,
              fontSize: 44,
              fontWeight: FontWeight.w400,
              color: context.colorScheme.primary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: FontFamily.untoldHistory,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: context.colorScheme.primary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      );
}
