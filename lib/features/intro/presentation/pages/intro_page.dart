import "package:flutter/material.dart";
import "package:get/route_manager.dart";

import "../../../../core/routes/names.dart";

/// Page to display the intro.
///
/// The intro will be a background video cut into three parts:
/// 1. The first part will be a video of a book being showcased .
/// 2. The second part will be a video of the book on idle animation and the letters open book should be fading in and out.
/// 3. The third part will be a video of the book opening and zooming in.
class IntroPage extends StatefulWidget {
  /// Page to display the intro.
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              final invitationTag = Get.parameters["tag"];

              print(invitationTag);

              if (invitationTag == null ||
                  invitationTag.isEmpty ||
                  invitationTag == ":invitation") {
                print("invitationTag is null");
                return;
              }

              Get.toNamed(
                RoutesNames.invitation(invitationTag),
              );
            },
            child: const Text("Next"),
          ),
        ),
      );
}
