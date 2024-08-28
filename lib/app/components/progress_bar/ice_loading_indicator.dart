import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:lottie/lottie.dart';

class IceLoadingIndicator extends HookWidget {
  const IceLoadingIndicator({
    this.size,
    super.key,
  });

  final Size? size;

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController();

    return SizedBox(
      width: size?.width ?? 20.0.s,
      height: size?.height ?? 20.0.s,
      child: Assets.lottie.whiteLoader.lottie(
        frameRate: const FrameRate(60),
        controller: animationController,
        onLoaded: (composition) {
          animationController
            ..duration = composition.duration
            ..repeat();
        },
      ),
    );
  }
}
