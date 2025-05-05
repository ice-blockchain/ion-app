// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/global_notification_bar/providers/global_notification_notifier_provider.c.dart';

class GlobalNotificationBar extends HookConsumerWidget {
  const GlobalNotificationBar({super.key});

  static const animationDuration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(globalNotificationNotifierProvider);

    final controller = useAnimationController(
      duration: animationDuration,
    );

    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    _controlAnimation(
      isShow: notification != null,
      animation: animation,
      controller: controller,
    );

    if (notification == null) {
      return const SizedBox.shrink();
    }

    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: 1,
      child: notification.buildWidget(context),
    );
  }

  void _controlAnimation({
    required bool isShow,
    required CurvedAnimation animation,
    required AnimationController controller,
  }) {
    if (isShow && animation.status != AnimationStatus.completed) {
      controller.forward();
    } else if (!isShow && animation.status != AnimationStatus.dismissed) {
      controller.animateBack(0, duration: animationDuration);
    }
  }
}
