import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";

import "../widgets/rsvp/bank_details_section.dart";
import "../widgets/rsvp/rsvp_content.dart";
import "../widgets/rsvp/rsvp_header.dart";

/// Page to confirm attendance at the wedding.
@RoutePage()
class RsvpPage extends StatelessWidget {
  /// Page to confirm attendance at the wedding.
  const RsvpPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: const [
            RsvpHeader(),
            RsvpContent(),
            BankDetailsSection(),
          ],
        ),
      );
}
