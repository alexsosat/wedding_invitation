import "package:flutter/material.dart";
import "package:get/get.dart";

/// Widget used to set the navigation logic and background image of the page.
class PageTemplate extends StatelessWidget {
  /// Widget used to set the navigation logic and background image of the page.
  const PageTemplate({
    required this.child,
    required this.nextRoute,
    super.key,
  });

  /// Child widget to be displayed in the page.
  final Widget child;

  /// next route to be navigated to.
  final String nextRoute;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: GestureDetector(
          onTap: () => Get.toNamed(
            nextRoute,
          ),
          child: Container(
            /// TODO: Add background image.
            color: Colors.transparent,
            child: child,
          ),
        ),
      );
}
