import "package:flutter/material.dart";

import "package:get/get.dart";

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
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Boda de Mayte y Alex"),
              SizedBox(height: 40),

              // TODO: Change plural name using the invitation members_count value
              Text("Nos gustaría que nos acompañaras en este día tan especial"),

              // TODO: Change invitee name with the invitation name value
              Text("Familia Herrera"),

              SizedBox(height: 40),

              IntrinsicHeight(
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
            ],
          ),
        ),
      );
}
