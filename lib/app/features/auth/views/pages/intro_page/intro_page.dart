// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class IntroPage extends HookConsumerWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We watch the intro page video controller here and ensure we pass the same parameters
    // (looping: true) to get the same instance of the already initialized provider from SplashPage.
    final videoController = ref
        .watch(
          videoControllerProvider(
            const VideoControllerParams(
              sourcePath: Assets.videosIntro,
              looping: true,
              autoPlay: true,
            ),
          ),
        )
        .value;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Fallback white background if the video isn't initialized or an error occurs.
          if (videoController == null ||
              !videoController.value.isInitialized ||
              videoController.value.hasError)
            const ColoredBox(
              color: Colors.white,
              child: Center(
                child: IconAsset(Assets.svgLogoLogoCircle, size: 148),
              ),
            )
          else
            Center(
              child: AspectRatio(
                aspectRatio: videoController.value.aspectRatio,
                child: CachedVideoPlayerPlus(videoController),
              ),
            ),
          PositionedDirectional(
            start: 40.0.s,
            end: 40.0.s,
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
                trailingIcon: IconAssetColored(
                  Assets.svgIconButtonNext,
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
