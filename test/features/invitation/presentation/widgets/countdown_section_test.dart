import "package:boda_ma/features/invitation/presentation/widgets/invitation/sections/countdown_section.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  Widget createWidgetUnderTest({DateTime? targetDate}) => MaterialApp(
        theme: ThemeData(splashFactory: InkRipple.splashFactory),
        home: Scaffold(
          body: SingleChildScrollView(
            child: CountdownSection(
              targetDate: targetDate,
            ),
          ),
        ),
      );

  group("CountdownSection Tests", () {
    testWidgets("renders countdown labels correctly", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text("DÍAS"), findsOneWidget);
      expect(find.text("HORAS"), findsOneWidget);
      expect(find.text("MINUTOS"), findsOneWidget);
      expect(find.text("Queremos que seas parte!"), findsOneWidget);
    });

    testWidgets("calculates remaining time based on GMT-6 target date", (tester) async {
      final nowUtc = DateTime.now().toUtc();
      final nowGmt6 = nowUtc.subtract(const Duration(hours: 6));
      // Set target to exactly 2 days, 3 hours, 4 minutes ahead in GMT-6
      final target = nowGmt6.add(
        const Duration(days: 2, hours: 3, minutes: 4, seconds: 10),
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          targetDate: DateTime(
            target.year,
            target.month,
            target.day,
            target.hour,
            target.minute,
            target.second,
          ),
        ),
      );

      expect(find.text("02"), findsOneWidget);
      expect(find.text("03"), findsOneWidget);
      expect(find.text("04"), findsOneWidget);
    });

    testWidgets("displays zero when target date is in the past", (tester) async {
      final pastDate = DateTime(2020, 1, 1);

      await tester.pumpWidget(
        createWidgetUnderTest(targetDate: pastDate),
      );

      expect(find.text("00"), findsNWidgets(3));
    });

    testWidgets("updates target date when widget updates", (tester) async {
      final nowUtc = DateTime.now().toUtc();
      final nowGmt6 = nowUtc.subtract(const Duration(hours: 6));
      final target1 = nowGmt6.add(
        const Duration(days: 5, hours: 10, minutes: 20, seconds: 10),
      );
      final target2 = nowGmt6.add(
        const Duration(days: 12, hours: 8, minutes: 45, seconds: 10),
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          targetDate: DateTime(
            target1.year,
            target1.month,
            target1.day,
            target1.hour,
            target1.minute,
            target1.second,
          ),
        ),
      );

      expect(find.text("05"), findsOneWidget);
      expect(find.text("10"), findsOneWidget);
      expect(find.text("20"), findsOneWidget);

      await tester.pumpWidget(
        createWidgetUnderTest(
          targetDate: DateTime(
            target2.year,
            target2.month,
            target2.day,
            target2.hour,
            target2.minute,
            target2.second,
          ),
        ),
      );

      expect(find.text("12"), findsOneWidget);
      expect(find.text("08"), findsOneWidget);
      expect(find.text("45"), findsOneWidget);
    });
  });
}
