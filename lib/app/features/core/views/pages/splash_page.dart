import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/splash_provider.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AnimationController animationController = useAnimationController();

    useEffect(
      () {
        void listener(AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            ref.read(splashProvider.notifier).animationCompleted = true;
          }
        }

        animationController.addStatusListener(listener);

        return () => animationController.removeStatusListener(listener);
      },
      <Object?>[animationController],
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.blueGrey,
        child: Center(
          // <-- Wrap Lottie animation with a Container
          child: LottieBuilder.asset(
            'assets/lottie/splash-logo.json',
            controller: animationController,
            width: double.infinity,
            fit: BoxFit.fitWidth,
            onLoaded: (LottieComposition composition) {
              animationController
                ..duration = composition.duration
                ..forward();
            },
          ),
        ),
      ),
    );
  }
}
