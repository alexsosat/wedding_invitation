// ignore_for_file: use_colored_box

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";

import "../../../shared/presentation/widgets/page_template.dart";
import "../getX/invitation_controller.dart";
import "../widgets/invitation_props.dart";

/// Page to display the invitation.
///
/// In this invitation page, the user will be able to see the most important
/// information about the wedding such as the date, and a welcome message with
/// the name of the bride and groom and the invitees.
class InvitationPage extends GetView<InvitationController> {
  /// Invitation page.

  const InvitationPage({super.key});

  @override
  Widget build(BuildContext context) => PageTemplate(
        child: controller.obx(
          (invitation) => Stack(
            children: [
              const InvitationProps(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "BODA",
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Mayte y Alex",
                        textAlign: TextAlign.center,
                        style: context.textTheme.headlineLarge?.copyWith(
                          fontSize: 68,
                          fontFamily: GoogleFonts.parisienne().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        invitation!.guests.length > 1
                            ? "Nos gustaría que nos acompañaran en este día tan especial"
                            : "Nos gustaría que nos acompañaras en este día tan especial",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        invitation.name,
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Domingo",
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.black,
                              thickness: 0.5,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Nov",
                                  style:
                                      context.textTheme.bodyLarge?.copyWith(),
                                ),
                                Text(
                                  "8",
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "2026",
                                  style:
                                      context.textTheme.bodyLarge?.copyWith(),
                                ),
                              ],
                            ),
                            const VerticalDivider(
                              color: Colors.black,
                              thickness: 0.5,
                            ),
                            Text(
                              "5:30 PM",
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
