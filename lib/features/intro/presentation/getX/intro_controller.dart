import "package:get/get.dart";
import "package:video_player/video_player.dart";

import "../../../../core/routes/names.dart";

/// Phases of the intro video flow.
enum IntroPhase {
  /// First clip: book intro (plays once).
  intro,

  /// Looping idle clip; user can tap to continue.
  idle,

  /// Final clip before navigating to the book.
  ending,
}

/// Controller for the Intro page.
class IntroController extends GetxController with StateMixin<IntroPhase> {
  /// Plays [book_intro.mp4] once.
  VideoPlayerController? introVideoController;

  /// Loops [book_idle.mp4].
  VideoPlayerController? idleVideoController;

  /// Plays [book_end.mp4] once.
  VideoPlayerController? endVideoController;

  final Rx<IntroPhase> _phase = IntroPhase.intro.obs;

  bool _pendingEndEvent = false;

  /// Current phase of the intro sequence.
  IntroPhase get phase => _phase.value;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.loading());
    _startControllers();
  }

  @override
  void onClose() {
    _disposeIntro();
    _disposeIdle();
    _disposeEnd();
    super.onClose();
  }

  Future<void> _startControllers() async {
    await _startEnd();
    await _startIdle();
    await _startIntro();
  }

  Future<void> _disposeIntro() async {
    introVideoController?.removeListener(_onIntroVideoTick);
    await introVideoController?.dispose();
    introVideoController = null;
  }

  Future<void> _disposeIdle() async {
    idleVideoController?.removeListener(_onIdleVideoTick);
    await idleVideoController?.dispose();
    idleVideoController = null;
  }

  Future<void> _disposeEnd() async {
    endVideoController?.removeListener(_onEndVideoTick);
    await endVideoController?.dispose();
    endVideoController = null;
  }

  Future<void> _startIntro() async {
    await _disposeIntro();
    _pendingEndEvent = false;
    _phase.value = IntroPhase.intro;

    final controller = VideoPlayerController.asset(_assetIntro);
    introVideoController = controller;
    try {
      await controller.initialize();
      await controller.setLooping(false);
      controller.addListener(_onIntroVideoTick);
      await controller.setVolume(0);
      await controller.play();
      change(IntroPhase.intro, status: RxStatus.success());
    } catch (e) {
      await _disposeIntro();
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> _startIdle() async {
    await _disposeIdle();

    idleVideoController = VideoPlayerController.asset(_assetIdle);
    try {
      await idleVideoController?.initialize();
      await idleVideoController?.setLooping(true);
      idleVideoController?.addListener(_onIdleVideoTick);
      await idleVideoController?.setVolume(0);
    } catch (e) {
      await _disposeIdle();
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> _startEnd() async {
    await _disposeEnd();

    endVideoController = VideoPlayerController.asset(_assetEnd);
    try {
      await endVideoController?.initialize();
      await endVideoController?.setLooping(false);
      endVideoController?.addListener(_onEndVideoTick);
      await endVideoController?.setVolume(0);
    } catch (e) {
      await _disposeEnd();
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void _onIntroVideoTick() {
    final c = introVideoController;
    if (c == null || !c.value.isInitialized || _pendingEndEvent) {
      return;
    }
    if (c.value.isLooping) {
      return;
    }
    final duration = c.value.duration;
    if (duration == Duration.zero) {
      return;
    }
    if (c.value.position >= duration - const Duration(milliseconds: 120)) {
      _pendingEndEvent = true;
      _goToIdle();
    }
  }

  void _onIdleVideoTick() {
    final c = idleVideoController;
    if (c == null || !c.value.isInitialized) {
      return;
    }
  }

  void _onEndVideoTick() {
    final c = endVideoController;
    if (c == null || !c.value.isInitialized || _pendingEndEvent) {
      return;
    }
    if (c.value.isLooping) {
      return;
    }
    final duration = c.value.duration;
    if (duration == Duration.zero) {
      return;
    }
    if (c.value.position >= duration - const Duration(milliseconds: 120)) {
      _pendingEndEvent = true;
      _goToBook();
    }
  }

  Future<void> _goToIdle() async {
    _phase.value = IntroPhase.idle;
    _pendingEndEvent = false;

    await idleVideoController?.play();
    change(IntroPhase.idle, status: RxStatus.success());
  }

  void _goToBook() {
    final tag = _invitationTag;
    if (tag == null) {
      Get.offAllNamed(RoutesNames.unknown);
      return;
    }
    Get.offNamed(RoutesNames.invitation(tag));
  }

  /// From [IntroPhase.idle], starts the ending video.
  Future<void> onScreenPressed() async {
    print("Phase: $_phase");
    if (_phase != IntroPhase.idle) {
      print("Not idle");
      return;
    }

    print("Idle");

    _phase.value = IntroPhase.ending;
    _pendingEndEvent = false;

    await endVideoController?.play();

    change(IntroPhase.ending, status: RxStatus.success());
  }

  String? get _invitationTag {
    final tag = Get.parameters["tag"];
    if (tag == null || tag.isEmpty || tag == ":invitation") {
      return null;
    }
    return tag;
  }
}

const String _assetIntro = "assets/videos/book_intro.mp4";
const String _assetIdle = "assets/videos/book_idle.mp4";
const String _assetEnd = "assets/videos/book_end.mp4";
