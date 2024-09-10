import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'video_player_provider.g.dart';

@riverpod
Raw<VideoPlayerController> videoController(
  VideoControllerRef ref,
  String assetPath, {
  bool autoPlay = false,
  bool looping = false,
}) {
  final controller = VideoPlayerController.asset(assetPath);

  controller.initialize().then((_) {
    controller.setLooping(looping);
    if (autoPlay) controller.play();
  });

  controller.addListener(ref.notifyListeners);
  ref.onDispose(() => controller.dispose());

  return controller;
}
