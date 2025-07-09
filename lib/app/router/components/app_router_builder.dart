// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/global_notification_bar/global_notification_bar_wrapper.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/mute_provider.r.dart';
import 'package:ion/app/features/core/providers/volume_stream_provider.r.dart';
import 'package:ion/app/features/debug/views/debug_rotate_gesture.dart';
import 'package:ion/app/features/feed/global_notifications/helpers/feed_global_notifications_helper.dart';
import 'package:ion/app/features/protect_account/secure_account/views/components/two_fa_signature_wrapper.dart';
import 'package:ion/app/services/ui_event_queue/ui_event_queue_listener.dart';

class AppRouterBuilder extends HookConsumerWidget {
  const AppRouterBuilder({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previousVolume = useRef<double>(0);

    ref.listen(volumeStreamProvider, (previous, next) {
      next.whenData((volume) {
        final currentMuteState = ref.read(globalMuteNotifierProvider);
        final prevVol = previousVolume.value;

        // If video is muted and volume increased - unmute
        if (currentMuteState && volume > prevVol && volume > 0.0) {
          ref.read(globalMuteNotifierProvider.notifier).toggle();
        }

        // If device is in silent mode (volume is 0) - mute video
        if (volume == 0.0 && !currentMuteState) {
          ref.read(globalMuteNotifierProvider.notifier).toggle();
        }

        previousVolume.value = volume;
      });
    });

    return Material(
      color: context.theme.appColors.secondaryBackground,
      child: GlobalNotificationBarWrapper(
        setUpListeners: setupFeedGlobalNotificationsListeners,
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
