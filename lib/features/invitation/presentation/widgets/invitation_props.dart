import "package:flutter/material.dart";
import "package:gif_view/gif_view.dart";

/// Widget to display the invitation background.
class InvitationProps extends StatelessWidget {
  /// Widget to display the invitation background.
  const InvitationProps({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.transparent,
                ],
                stops: [0.3, 0.8],
              ).createShader(
                Rect.fromLTRB(
                  0,
                  0,
                  rect.width,
                  rect.height,
                ),
              ),
              blendMode: BlendMode.dstIn, // This is the secret sauce
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/invitation_image.JPG",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Center(
          //   child: Opacity(
          //     opacity: 0.5,
          //     child: GifView.asset(
          //       "assets/gifs/rings.gif",
          //       height: 100,
          //       width: 100,
          //       frameRate: 15,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 60),
        ],
      );
}
