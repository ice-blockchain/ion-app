import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:video_player/video_player.dart';

Future<void> initializeVideoController(VideoPlayerController controller) async {
  await controller.initialize();
  await controller.setLooping(true);
  await controller.play();
}

VideoPlayerController useVideoController(
  String assetPath, {
  VideoPlayerController Function(String) createController =
      VideoPlayerController.asset,
}) {
  final controller = useMemoized(
    () => createController(assetPath),
    [assetPath],
  );

  useEffect(
    () {
      Future.microtask(() => initializeVideoController(controller));
      return controller.dispose;
    },
    [controller],
  );

  return controller;
}
