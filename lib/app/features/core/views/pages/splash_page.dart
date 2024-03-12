import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/features/core/providers/splash_provider.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends IceSimplePage {
  const SplashPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final AnimationController animationController = useAnimationController();

    return ColoredBox(
      color: const Color(0xFF0166FF),
      child: FittedBox(
        fit: BoxFit.cover,
        child: Assets.lottie.splashLogo.lottie(
          frameRate: const FrameRate(60),
          controller: animationController,
          onLoaded: (LottieComposition composition) {
            animationController
              ..duration = composition.duration
              ..forward().whenComplete(
                () =>
                    ref.read(splashProvider.notifier).animationCompleted = true,
              );
          },
        ),
      ),
    );
  }
}
