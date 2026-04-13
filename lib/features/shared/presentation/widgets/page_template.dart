import "package:flutter/material.dart";

/// Widget used to set the navigation logic and background image of the page.
class PageTemplate extends StatelessWidget {
  /// Widget used to set the navigation logic and background image of the page.
  const PageTemplate({
    required this.child,
    super.key,
  });

  /// Child widget to be displayed in the page.
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.25,
              image: AssetImage(
                "assets/images/texture_1.png",
              ),
              fit: BoxFit.cover,
            ),
            color: Colors.transparent,
          ),
          child: child,
        ),
      );
}
