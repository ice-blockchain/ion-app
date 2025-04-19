// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/theme_mode_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:lottie/lottie.dart';

enum IndicatorType {
  light,
  dark,
}

class IONLoadingIndicatorThemed extends ConsumerWidget {
  const IONLoadingIndicatorThemed({
    this.size,
    this.value,
    super.key,
  });

  final Size? size;
  final double? value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLightTheme = ref.watch(appThemeModeProvider) == ThemeMode.light;

    return IONLoadingIndicator(
      type: isLightTheme ? IndicatorType.dark : IndicatorType.light,
      size: size,
      value: value,
    );
  }
}

class IONLoadingIndicator extends HookWidget {
  const IONLoadingIndicator({
    this.type = IndicatorType.light,
    this.size,
    this.value,
    super.key,
  });

  final IndicatorType type;
  final Size? size;
  final double? value;

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      // Addition and division are used because this Lottie animation's empty state is at 0.5
      initialValue: value != null ? (value! + 1) / 2 : 0,
      keys: [value],
    );
    final duration = useRef<Duration?>(null);

    useEffect(
      () {
        if (value == null && duration.value != null) {
          animationController
            ..duration = duration.value
            ..repeat();
        } else {
          animationController.stop();
        }
        return null;
      },
      [value, animationController, duration.value],
    );

    final loader =
        type == IndicatorType.light ? Assets.lottie.whiteLoader : Assets.lottie.darkLoader;
    return SizedBox(
      width: size?.width ?? 20.0.s,
      height: size?.height ?? 20.0.s,
      child: loader.lottie(
        frameRate: const FrameRate(60),
        controller: animationController,
        onLoaded: (composition) {
          duration.value = composition.duration;
        },
      ),
    );
  }
}
