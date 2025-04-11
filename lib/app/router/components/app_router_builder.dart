// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/global_notification_bar/global_notification_bar_wrapper.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/debug/views/debug_rotate_gesture.dart';
import 'package:ion/app/features/protect_account/secure_account/views/components/two_fa_signature_wrapper.dart';
import 'package:ion/app/services/ui_event_queue/ui_event_queue_listener.dart';

class AppRouterBuilder extends HookConsumerWidget {
  const AppRouterBuilder({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: context.theme.appColors.secondaryBackground,
      child: GlobalNotificationBarWrapper(
        children: [
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
    );
  }
}
