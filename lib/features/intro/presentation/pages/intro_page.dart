import "package:flutter/material.dart";
import "package:get/get.dart";

import "../../../../core/routes/names.dart";
import "../../../invitation/presentation/getX/invitation_controller.dart";

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
  late final InvitationController _controller;
  final RxBool _isWaitingForData = false.obs;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<InvitationController>();
  }

  String? get _invitationTag {
    final tag = Get.parameters["tag"];
    if (tag == null || tag.isEmpty || tag == ":invitation") {
      return null;
    }
    return tag;
  }

  void _onNextPressed() {
    final tag = _invitationTag;
    if (tag == null) {
      return;
    }

    if (_controller.status.isSuccess) {
      _navigateToInvitation(tag);
    } else if (_controller.status.isLoading) {
      _isWaitingForData.value = true;
    }
  }

  void _navigateToInvitation(String tag) {
    if (_hasNavigated) {
      return;
    }
    _hasNavigated = true;
    Get.toNamed(RoutesNames.invitation(tag));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: _controller.obx(
            (_) {
              if (_isWaitingForData.value && !_hasNavigated) {
                final tag = _invitationTag;
                if (tag != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _navigateToInvitation(tag);
                  });
                }
              }
              return ElevatedButton(
                onPressed: _onNextPressed,
                child: const Text("Next"),
              );
            },
            onLoading: Obx(
              () => _isWaitingForData.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _onNextPressed,
                      child: const Text("Next"),
                    ),
            ),
            onError: (_) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Failed to load invitation"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _controller.onInit(),
                  child: const Text("Dismiss"),
                ),
              ],
            ),
          ),
        ),
      );
}
