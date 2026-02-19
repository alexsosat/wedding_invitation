import "package:flutter/material.dart";

/// Page to display when the route is not found.
class UnknownPage extends StatelessWidget {
  /// Page to display when the route is not found.
  const UnknownPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text("Page not found"),
        ),
      );
}
