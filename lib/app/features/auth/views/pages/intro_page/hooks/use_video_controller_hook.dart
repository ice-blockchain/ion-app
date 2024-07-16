import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:video_player/video_player.dart';

VideoPlayerController useVideoController(String assetPath) {
  final controller = useMemoized(
    () => VideoPlayerController.asset(assetPath),
    [assetPath],
  );

  useEffect(
    () {
      Future.microtask(() async {
        await controller.initialize();
        await controller.setLooping(true);
        await controller.play();
      });

      return controller.dispose;
    },
    [controller],
  );

  return controller;
}
