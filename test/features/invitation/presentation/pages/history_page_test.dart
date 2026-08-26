import "package:boda_ma/features/invitation/presentation/pages/history_page.dart";
import "package:boda_ma/features/invitation/presentation/widgets/history/history_header.dart";
import "package:boda_ma/features/invitation/presentation/widgets/history/history_masonry_images_section.dart";
import "package:boda_ma/features/invitation/presentation/widgets/history/history_story_section.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("HistoryStorySection renders title and all three story paragraphs", (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: HistoryStorySection(),
          ),
        ),
      ),
    );

    await tester.pump();

    // Verify Title
    expect(find.text("Lo esencial es invisible a los ojos"), findsOneWidget);

    // Verify Story Paragraphs
    expect(
      find.textContaining("Nos conocimos una tarde de octubre"),
      findsOneWidget,
    );
    expect(
      find.textContaining("No teníamos los mismos gustos"),
      findsOneWidget,
    );
    expect(
      find.textContaining("aquel encuentro de octubre"),
      findsOneWidget,
    );
  });

  testWidgets("HistoryMasonryImagesSection renders collage with images", (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: HistoryMasonryImagesSection(),
          ),
        ),
      ),
    );

    await tester.pump();

    // Verify images are rendered
    expect(find.byType(HistoryMasonryImagesSection), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(7));
  });

  testWidgets("HistoryPage renders header and allows scrolling to story and masonry sections", (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HistoryPage(),
      ),
    );

    await tester.pump();

    // Verify HistoryHeader is rendered first
    expect(find.byType(HistoryHeader), findsOneWidget);

    // Scroll down to reveal HistoryStorySection
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pump();

    expect(find.byType(HistoryStorySection), findsOneWidget);
    expect(find.text("Lo esencial es invisible a los ojos"), findsOneWidget);

    // Scroll down further to reveal HistoryMasonryImagesSection
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pump();

    expect(find.byType(HistoryMasonryImagesSection), findsOneWidget);
  });
}
