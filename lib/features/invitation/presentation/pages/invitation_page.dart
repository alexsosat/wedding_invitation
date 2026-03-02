// ignore_for_file: use_colored_box

import "package:flutter/material.dart";

import "package:get/get.dart";

import "../../../../core/routes/names.dart";
import "../../../shared/presentation/widgets/page_template.dart";
import "../getX/invitation_controller.dart";

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
        nextRoute: RoutesNames.schedule(Get.parameters["tag"] ?? ""),
        child: controller.obx(
          (invitation) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: "title",
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      "Boda de Mayte y Alex",
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  invitation!.guests.length > 1
                      ? "Nos gustaría que nos acompañaran en este día tan especial"
                      : "Nos gustaría que nos acompañaras en este día tan especial",
                ),
                Text(
                  invitation.name,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                const IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Domingo"),
                      VerticalDivider(
                        color: Colors.red,
                        thickness: 3.5,
                      ),
                      Column(
                        children: [
                          Text("Nov"),
                          Text("22"),
                          Text("2026"),
                        ],
                      ),
                      VerticalDivider(
                        color: Colors.red,
                        thickness: 3.5,
                      ),
                      Text("5:30 PM"),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );
}
