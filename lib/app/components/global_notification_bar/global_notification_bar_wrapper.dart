// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/global_notification_bar/global_notification_bar.dart';
import 'package:ion/app/components/global_notification_bar/providers/global_notification_notifier_provider.c.dart';
import 'package:ion/app/hooks/use_interval.dart';

class GlobalNotificationBarWrapper extends HookConsumerWidget {
  const GlobalNotificationBarWrapper({
    required this.children,
    required this.setUpListeners,
    super.key,
  });

  final List<Widget> children;
  final void Function(WidgetRef ref) setUpListeners;

  static const animationDuration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(globalNotificationNotifierProvider);
    final isShowSafeArea = useState(false);

    if (notification != null) {
      isShowSafeArea.value = true;
    } else {
      // Delay to hide safe area top to prevent animation glitch
      useInterval(
        delay: GlobalNotificationBar.animationDuration,
        callback: () => isShowSafeArea.value = false,
        oneTime: true,
      );
    }

    setUpListeners(ref);

    return SafeArea(
      top: isShowSafeArea.value,
      bottom: false,
      child: Column(
        children: [
          const GlobalNotificationBar(),
          ...children,
        ],
      ),
    );
  }
}
