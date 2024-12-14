// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/components/global_notification_bar/models/global_notification_data.dart';
import 'package:ion/app/components/global_notification_bar/providers/global_notification_state.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_notification_provider.c.g.dart';

@riverpod
class GlobalNotification extends _$GlobalNotification {
  @override
  GlobalNotificationState build() => const GlobalNotificationState();

  Timer? _timer;

  void show(GlobalNotificationData data) {
    // Prevent bottom sheet from jumping when showing notification
    Future.delayed(const Duration(milliseconds: 500), () {
      state = state.copyWith(isShow: true, data: data);
    });

    _timer?.cancel();

    if (data.status != NotificationStatus.loading) {
      _timer = Timer(const Duration(seconds: 3), () {
        state = state.copyWith(isShow: false);
      });
    }
  }

  void hide() {
    _timer?.cancel();
    state = state.copyWith(isShow: false);
  }
}
