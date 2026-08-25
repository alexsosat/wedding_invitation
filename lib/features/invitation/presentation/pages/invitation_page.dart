import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";

import "../../../../core/routes/app_router.gr.dart";
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
          children: [
            const InvitationHeader(),
            const CountdownSection(),
            DetailsSection(
              onTap: () => _goToDetails(context),
            ),
            const ConfirmationSection(),
            const HistorySection(),
            const FooterSection(),
          ],
        ),
      );

  Future _goToDetails(BuildContext context) => context.router.navigate(
        const DetailsRoute(),
      );
}
