import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/auth/views/pages/intro_page/hooks/use_video_controller_hook.dart';
import 'package:ice/app/features/core/providers/splash_provider.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});

  static const Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _setSystemChrome();

    final videoController = useVideoController(
      Assets.videos.logoStatic,
      isLooping: false,
    );

    useOnInit(() {
      videoController.addListener(() {
        if (videoController.value.position >= videoController.value.duration) {
          ref.read(splashProvider.notifier).animationCompleted = true;
        }
      });
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: videoController.value.isInitialized
            ? AspectRatio(
                aspectRatio: videoController.value.aspectRatio,
                child: VideoPlayer(videoController),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  void _setSystemChrome() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: backgroundColor,
      ),
    );
  }
}
