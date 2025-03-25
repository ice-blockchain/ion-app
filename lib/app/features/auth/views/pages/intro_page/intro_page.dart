// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class IntroPage extends HookConsumerWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We watch the intro page video controller here and ensure we pass the same parameters
    // (looping: true) to get the same instance of the already initialized provider from SplashPage.
    final videoController = ref.watch(
      videoControllerProvider(
        VideoControllerParams(
          sourcePath: Assets.videos.intro,
          looping: true,
          options: VideoPlayerOptions(mixWithOthers: true),
        ),
      ),
    );

    // Playing the intro video as soon as the widget is built.
    // This ensures the video starts playing immediately after the page is displayed.
    useOnInit(videoController.play);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Fallback white background if the video isn't initialized or an error occurs.
          if (!videoController.value.isInitialized || videoController.value.hasError)
            ColoredBox(
              color: Colors.white,
              child: Center(
                child: Assets.svg.logo.logoCircle.icon(size: 148.0.s),
              ),
            )
          else
            Center(
              child: AspectRatio(
                aspectRatio: videoController.value.aspectRatio,
                child: CachedVideoPlayerPlus(videoController),
              ),
            ),
          Positioned(
            left: 40.0.s,
            right: 40.0.s,
            bottom: MediaQuery.of(context).padding.bottom + 46.0.s,
            child: Animate(
              effects: [
                ScaleEffect(
                  duration: 500.ms,
                  curve: Curves.easeOutBack,
                  delay: 2.0.seconds,
                ),
              ],
              child: Button(
                onPressed: () => GetStartedRoute().go(context),
                label: Text(context.i18n.button_continue),
                trailingIcon: Assets.svg.iconButtonNext.icon(
                  color: context.theme.appColors.secondaryBackground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
