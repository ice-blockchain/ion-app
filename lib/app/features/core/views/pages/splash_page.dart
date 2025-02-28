// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/splash_provider.c.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  static const Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _setSystemChrome();

    final splashVideoController = ref.watch(
      videoControllerProvider(Assets.videos.logoStatic, autoPlay: true),
    );

    // We watch the intro video controller here to initialize the intro video in advance.
    // This ensures a seamless transition to the IntroPage without flickering or delays.
    ref
      ..watch(videoControllerProvider(Assets.videos.intro, looping: true))
      ..listen<CachedVideoPlayerPlusController>(
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
      backgroundColor: backgroundColor,
      body: Center(
        child: splashVideoController.value.isInitialized
            ? AspectRatio(
                aspectRatio: splashVideoController.value.aspectRatio,
                child: CachedVideoPlayerPlus(splashVideoController),
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
