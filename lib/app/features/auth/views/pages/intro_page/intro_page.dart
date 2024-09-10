import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/pages/intro_page/providers/video_player_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:video_player/video_player.dart';

class IntroPage extends ConsumerWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoController = ref.watch(
      videoControllerProvider(Assets.videos.intro, looping: true),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          if (videoController.value.isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: videoController.value.aspectRatio,
                child: VideoPlayer(videoController),
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
                  delay: 4.5.seconds,
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
