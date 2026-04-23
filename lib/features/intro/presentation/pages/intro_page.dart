import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:get/get.dart";
import "package:video_player/video_player.dart";

import "../getX/intro_controller.dart";

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
  late final IntroController _introController;

  @override
  void initState() {
    super.initState();
    _introController = Get.find<IntroController>();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: _introController.obx(
          (_) => const Center(
            child: Stack(
              children: [
                _EndVideo(),
                _IdleVideo(),
                _IntroVideo(),
              ],
            ),
          ),
          onLoading: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
}

class _IntroVideo extends StatelessWidget {
  const _IntroVideo();

  @override
  Widget build(BuildContext context) => GetX<IntroController>(
        builder: (controller) => controller.phase == IntroPhase.intro
            ? VideoPlayer(
                controller.introVideoController!,
              )
            : const SizedBox.shrink(),
      );
}

class _IdleVideo extends StatelessWidget {
  const _IdleVideo();

  @override
  Widget build(BuildContext context) => GetX<IntroController>(
        builder: (controller) => controller.phase == IntroPhase.idle ||
                controller.phase == IntroPhase.intro
            ? Stack(
                children: [
                  VideoPlayer(
                    controller.idleVideoController!,
                  ),
                  Align(
                    alignment: const Alignment(0, 0.75),
                    child: Text(
                      controller.textToShow.value,
                      style: context.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .fadeOut(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          delay: const Duration(milliseconds: 300),
                        ),
                  ),
                  InkWell(
                    onTap: () {
                      controller.onScreenPressed();
                    },
                    child: SizedBox(
                      width: context.width,
                      height: context.height,
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      );
}

class _EndVideo extends GetWidget<IntroController> {
  const _EndVideo();

  @override
  Widget build(BuildContext context) => GetX<IntroController>(
        builder: (controller) => controller.phase == IntroPhase.ending ||
                controller.phase == IntroPhase.idle
            ? VideoPlayer(
                controller.endVideoController!,
              )
            : const SizedBox.shrink(),
      );
}
