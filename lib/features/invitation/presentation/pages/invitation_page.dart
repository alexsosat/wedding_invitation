import "package:auto_route/annotations.dart";
import "package:flutter/material.dart";

import "../widgets/invitation/sections/confirmation_section.dart";
import "../widgets/invitation/sections/countdown_section.dart";
import "../widgets/invitation/sections/details_section.dart";
import "../widgets/invitation/sections/footer_section.dart";
import "../widgets/invitation/sections/history_section.dart";
import "../widgets/invitation/sections/invitation_header.dart";

/// Page that displays the invitation.
@RoutePage()
class InvitationPage extends StatelessWidget {
  /// Creates an [InvitationPage].
  const InvitationPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: const [
            InvitationHeader(),
            CountdownSection(),
            DetailsSection(),
            ConfirmationSection(),
            HistorySection(),
            FooterSection(),
          ],
        ),
      );
}
