import "package:flutter/material.dart";

import "package:get/get.dart";

import "../getX/rsvp_controller.dart";

/// Page to display the RSVP form.
class RsvpPage extends GetView<RsvpController> {
  /// Page to display the RSVP form.
  const RsvpPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Text("Created with clean arq brick"),
        ),
      );
}
