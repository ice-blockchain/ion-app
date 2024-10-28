// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:lottie/lottie.dart';

enum IndicatorType {
  light,
  dark,
}

class IonLoadingIndicator extends HookWidget {
  const IonLoadingIndicator({
    this.type = IndicatorType.light,
    this.size,
    super.key,
  });

  final IndicatorType type;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController();

    final loader =
        type == IndicatorType.light ? Assets.lottie.whiteLoader : Assets.lottie.darkLoader;
    return SizedBox(
      width: size?.width ?? 20.0.s,
      height: size?.height ?? 20.0.s,
      child: loader.lottie(
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
