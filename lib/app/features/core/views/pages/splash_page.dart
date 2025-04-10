// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/splash_provider.c.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/generated/assets.gen.dart';

class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});

  static const Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _setSystemChrome();

    final splashVideoController = ref
        .watch(
          videoControllerProvider(
            VideoControllerParams(
              sourcePath: Assets.videos.logoStatic,
              autoPlay: true,
            ),
          ),
        )
        .value;

    // We watch the intro video controller here to initialize the intro video in advance.
    // This ensures a seamless transition to the IntroPage without flickering or delays.
    ref.watch(
      videoControllerProvider(
        VideoControllerParams(sourcePath: Assets.videos.intro, looping: true),
      ),
    );

    useEffect(
      () {
        if (splashVideoController == null) {
          return null;
        }
        void onSplashVideoComplete() {
          if (splashVideoController.value.position >= splashVideoController.value.duration ||
              splashVideoController.value.hasError) {
            ref.read(splashProvider.notifier).animationCompleted = true;
          }
        }

        splashVideoController.addListener(onSplashVideoComplete);
        return () => splashVideoController.removeListener(onSplashVideoComplete);
      },
      [splashVideoController],
    );

    // Timer to check if the video is stuck (position remains zero) for too long.
    useEffect(
      () {
        // Only start the timer after the video is initialized.
        if (splashVideoController != null && splashVideoController.value.isInitialized) {
          final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            // If after 2 seconds the position is still zero, we trigger fallback.
            if (splashVideoController.value.position == Duration.zero && timer.tick >= 2) {
              ref.read(splashProvider.notifier).animationCompleted = true;
              timer.cancel();
            } else if (splashVideoController.value.position > Duration.zero) {
              // Video started playing—cancel the timer.
              timer.cancel();
            }
          });
          return timer.cancel;
        }
        return null;
      },
      [splashVideoController?.value.isInitialized],
    );

    useOnInit(
      () {
        if (splashVideoController != null && splashVideoController.value.hasError) {
          ref.read(splashProvider.notifier).animationCompleted = true;
        }
      },
      [splashVideoController?.value.hasError],
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: splashVideoController != null &&
                splashVideoController.value.isInitialized &&
                !splashVideoController.value.hasError
            ? AspectRatio(
                aspectRatio: splashVideoController.value.aspectRatio,
                child: CachedVideoPlayerPlus(splashVideoController),
              )
            : splashVideoController != null && splashVideoController.value.hasError
                ? Assets.svg.logo.logoCircle.icon(size: 148.0.s)
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
