import "package:auto_route/annotations.dart";
import "package:flutter/material.dart";

import "../widgets/details/details_content.dart";
import "../widgets/details/header_section.dart";

/// Page that displays the details of the event.
@RoutePage()
class DetailsPage extends StatelessWidget {
  /// Page that displays the details of the event.
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: const [
            HeaderSection(),
            DetailsContent(),
          ],
        ),
      );
}
