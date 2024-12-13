// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/global_notification_bar/global_notification_bar.dart';
import 'package:ion/app/components/global_notification_bar/providers/global_notification_provider.c.dart';

class AppRouterBuilder extends HookConsumerWidget {
  const AppRouterBuilder({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(globalNotificationProvider);
    final isShowSafeArea = useState(false);

    useEffect(
      () {
        if (notification.isShow) {
          isShowSafeArea.value = true;
        } else {
          // Delay to hide safe area top to prevent animation glitch
          Future.delayed(GlobalNotificationBar.animationDuration, () {
            isShowSafeArea.value = false;
          });
        }

        return null;
      },
      [notification.isShow],
    );

    return Scaffold(
      body: SafeArea(
        top: isShowSafeArea.value,
        bottom: false,
        child: Column(
          children: [
            const GlobalNotificationBar(),
            Expanded(
              child: child ?? const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
