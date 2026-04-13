import "package:flutter/material.dart";
import "package:flutter_common_classes/extensions/color_extension.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";
import "package:get/get_state_manager/src/simple/get_view.dart";
import "package:turn_page_transition/turn_page_transition.dart";

import "../../../invitation/presentation/pages/invitation_page.dart";
import "../../../rsvp/presentation/pages/rsvp_page.dart";
import "../../../schedule/presentation/pages/schedule_page.dart";
import "../getX/book_controller.dart";

/// Page to display the book.
class BookPage extends GetView<BookController> {
  /// Page to display the book.
  const BookPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: TurnPageView.builder(
          controller: controller.turnPageViewController,
          itemCount: 3,
          itemBuilder: (context, index) => const [
            InvitationPage(),
            SchedulePage(),
            RsvpPage(),
          ][index],
          overleafColorBuilder: (index) =>
              context.theme.scaffoldBackgroundColor.darken(5),
          animationTransitionPoint: 0.5,
          overleafBorderColorBuilder: (index) =>
              context.theme.scaffoldBackgroundColor.darken(15),
        ),
      );
}
