import "package:flutter/material.dart";

import "package:get/get.dart";

import "../getX/schedule_controller.dart";

/// Page to display the schedule of the wedding.
class SchedulePage extends GetView<ScheduleController> {
  /// Page to display the schedule of the wedding.
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Hero(
            tag: "title",
            child: Material(
              child: Text("Created with clean arq brick"),
            ),
          ),
        ),
      );
}
