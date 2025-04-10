// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/app_update_handler/hooks/use_app_update.dart';
import 'package:ion/app/components/global_notification_bar/global_notification_bar.dart';
import 'package:ion/app/components/global_notification_bar/providers/global_notification_provider.c.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/debug/views/debug_rotate_gesture.dart';
import 'package:ion/app/features/protect_account/secure_account/views/components/two_fa_signature_wrapper.dart';
import 'package:ion/app/hooks/use_interval.dart';
import 'package:ion/app/services/ui_event_queue/ui_event_queue_listener.dart';

class AppRouterBuilder extends HookConsumerWidget {
  const AppRouterBuilder({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(globalNotificationProvider);
    final isShowSafeArea = useState(false);
    useAppUpdate(ref);

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
        child: Column(
          children: [
            const GlobalNotificationBar(),
            const UiEventQueueListener(),
            Expanded(
              child: DebugRotateGesture(
                child: TwoFaSignatureWrapper(
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
