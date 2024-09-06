import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/splash_provider.dart';
import 'package:ice/app/hooks/use_on_init.dart';

class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});

  static const Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(duration: Duration.zero);

    _setSystemChrome();

    useOnInit(() {
      animationController.forward().whenComplete(
            () => ref.read(splashProvider.notifier).animationCompleted = true,
          );
    });

    return const ColoredBox(
      color: backgroundColor,
      child: SizedBox.expand(),
    );
  }

  void _setSystemChrome() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: backgroundColor,
      ),
    );
  }
}
