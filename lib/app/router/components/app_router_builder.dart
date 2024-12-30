// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/app_update_handler/app_update_handler.dart';
import 'package:ion/app/components/global_notification_bar/global_notification_bar.dart';
import 'package:ion/app/components/global_notification_bar/providers/global_notification_provider.c.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/hooks/use_interval.dart';

class AppRouterBuilder extends HookConsumerWidget {
  const AppRouterBuilder({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(globalNotificationProvider);
    final isShowSafeArea = useState(false);

    if (notification.isShow) {
      isShowSafeArea.value = true;
    } else {
      // Delay to hide safe area top to prevent animation glitch
      useInterval(
        delay: GlobalNotificationBar.animationDuration,
        callback: () => isShowSafeArea.value = false,
        oneTime: true,
      );
    }

    return Material(
      color: context.theme.appColors.secondaryBackground,
      child: SafeArea(
        top: isShowSafeArea.value,
        bottom: false,
        child: AppUpdateHandler(
          child: Column(
            children: [
              const GlobalNotificationBar(),
              Expanded(
                child: child ?? const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
