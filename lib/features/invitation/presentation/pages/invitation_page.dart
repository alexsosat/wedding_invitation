import "package:auto_route/annotations.dart";
import "package:flutter/material.dart";

import "../widgets/sections/countdown_section.dart";
import "../widgets/sections/invitation_header.dart";

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
          ],
        ),
      );
}
