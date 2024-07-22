import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/intro_page/hooks/use_video_controller_hook.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:video_player/video_player.dart';

class IntroPage extends HookWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final videoController = useVideoController(Assets.videos.intro);

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
                  delay: 10.seconds,
                ),
              ],
              child: Button(
                onPressed: () => GetStartedRoute().go(context),
                label: Text(context.i18n.button_continue),
                trailingIcon: Assets.images.icons.iconButtonNext.icon(
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
