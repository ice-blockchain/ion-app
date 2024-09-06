import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:video_player/video_player.dart';

VideoPlayerController useVideoController(String assetPath, {bool isLooping = true}) {
  final controller = useMemoized(
    () => VideoPlayerController.asset(assetPath),
    [assetPath],
  );

  final isInitialized = useState(false);

  useEffect(
    () {
      Future.microtask(() async {
        await controller.initialize();
        isInitialized.value = true;
        await controller.setLooping(isLooping);
        await controller.play();
      });

      return controller.dispose;
    },
    [controller],
  );

  return controller;
}
