import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/splash_provider.dart';
import 'package:ice/app/features/core/providers/video_player_provider.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashVideoController = ref.watch(
      videoControllerProvider(Assets.videos.logoStatic, autoPlay: true),
    );

    // We watch the intro video controller here to initialize the intro video in advance.
    // This ensures a seamless transition to the IntroPage without flickering or delays.
    ref.watch(videoControllerProvider(Assets.videos.intro, looping: true));

    ref.listen<VideoPlayerController>(
      videoControllerProvider(Assets.videos.logoStatic, autoPlay: true),
      (previous, controller) {
        void onSplashVideoComplete() {
          if (controller.value.position >= controller.value.duration) {
            ref.read(splashProvider.notifier).animationCompleted = true;

            controller.removeListener(onSplashVideoComplete);
          }
        }

        controller.addListener(onSplashVideoComplete);
      },
    );

    return Scaffold(
      body: Center(
        child: splashVideoController.value.isInitialized
            ? AspectRatio(
                aspectRatio: splashVideoController.value.aspectRatio,
                child: VideoPlayer(splashVideoController),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
