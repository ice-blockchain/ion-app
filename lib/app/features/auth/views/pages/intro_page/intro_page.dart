import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/intro_page/hooks/use_button_animation.dart';
import 'package:ice/app/features/auth/views/pages/intro_page/providers/video_player_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:video_player/video_player.dart';

class IntroPage extends IcePage {
  const IntroPage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final videoControllerAsync = ref.watch(videoControllerProvider);
    final animation = useButtonAnimation(delay: const Duration(seconds: 10));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          videoControllerAsync.maybeWhen(
            data: (controller) => Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          Positioned(
            left: 40.0.s,
            right: 40.0.s,
            bottom: MediaQuery.of(context).padding.bottom + 46.0.s,
            child: ScaleTransition(
              scale: animation,
              child: Button(
                onPressed: () => AuthRoute().go(context),
                label: Text(context.i18n.button_continue),
                trailingIcon: Assets.images.icons.iconButtonNext
                    .icon(color: context.theme.appColors.secondaryBackground),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
