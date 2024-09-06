import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/splash_provider.dart';
import 'package:ice/app/hooks/use_on_init.dart';

class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});

  static const Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _setSystemChrome();

    useOnInit(() {
      ref.read(splashProvider.notifier).animationCompleted = true;
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
