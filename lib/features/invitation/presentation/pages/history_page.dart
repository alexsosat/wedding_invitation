import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";

import "../widgets/history/history_header.dart";
import "../widgets/history/history_masonry_images_section.dart";
import "../widgets/history/history_story_section.dart";

/// Page where the history of the couple is shown.
@RoutePage()
class HistoryPage extends StatelessWidget {
  /// Page where the history of the couple is shown.
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: const [
            HistoryHeader(),
            HistoryStorySection(),
            HistoryMasonryImagesSection(),
          ],
        ),
      );
}
