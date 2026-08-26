import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../core/gen/adobe_fonts.dart";
import "../../../../../core/gen/assets.gen.dart";
import "../../../../../core/gen/fonts.gen.dart";
import "../../../../shared/presentation/widgets/scaling_animated_widget.dart";

/// Section that displays bank account details on an open pink envelope.
class BankDetailsSection extends StatelessWidget {
  /// Creates a [BankDetailsSection] widget.
  const BankDetailsSection({
    super.key,
    this.accountNumber = "638180010139037268",
    this.bankName = "Nu México",
    this.beneficiaryName = "Alejandro Rafael Sosa Trejo",
  });

  /// The bank account / CLABE number to display.
  final String accountNumber;

  /// The name of the bank institution.
  final String bankName;

  /// The name of the account beneficiary.
  final String beneficiaryName;

  @override
  Widget build(BuildContext context) {
    final envelopeHeight = getValueForScreenType<double>(
      context: context,
      mobile: 380,
      tablet: 520,
      desktop: 600,
    );
    final envelopeWidth = envelopeHeight * (1174 / 1340);

    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFE2C4C9),
        image: DecorationImage(
          image: Assets.images.textures.flowersTransparent.provider(),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          colorFilter: const ColorFilter.mode(
            Color(0xFF8B4B60),
            BlendMode.srcIn,
          ),
        ),
      ),
      child: ScalingAnimatedWidget(
        onTap: () => _copyToClipboard(context),
        pulseScaleEnd: 1.02,
        hoverScale: 1.03,
        child: SizedBox(
          width: envelopeWidth,
          height: envelopeHeight,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              /// Pink open envelope background
              Positioned.fill(
                child: Assets.images.envelopes.pink.image(
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),

              /// Card Text Content
              Positioned(
                top: envelopeHeight * 0.22,
                left: envelopeWidth * 0.14,
                width: envelopeWidth * 0.68,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Transform.rotate(
                    angle: -10.2 * math.pi / 180,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          accountNumber,
                          style: TextStyle(
                            fontFamily: FontFamily.untoldHistory,
                            fontSize: envelopeHeight * 0.026,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF682637),
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          bankName,
                          style: TextStyle(
                            fontFamily: FontFamily.untoldHistory,
                            fontSize: envelopeHeight * 0.024,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF682637),
                          ),
                        ),
                        Text(
                          beneficiaryName,
                          style: TextStyle(
                            fontFamily: FontFamily.untoldHistory,
                            fontSize: envelopeHeight * 0.024,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF682637),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Datos",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AdobeFonts.altesse,
                                  fontSize: envelopeHeight * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF682637),
                                  height: 0.9,
                                ),
                              ),
                              Text(
                                "bancarios",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AdobeFonts.altesse,
                                  fontSize: envelopeHeight * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF682637),
                                  height: 0.9,
                                ),
                              ),
                            ],
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
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: accountNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Número de cuenta copiado al portapapeles"),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
