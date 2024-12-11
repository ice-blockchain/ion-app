// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/global_notification_bar/models/global_notification_data.c.dart';

typedef GlobalNotificationState = ({
  bool isShow,
  GlobalNotificationData? data,
});

final globalNotificationProvider =
    StateNotifierProvider<GlobalNotificationNotifier, GlobalNotificationState?>(
  (ref) => GlobalNotificationNotifier(),
);

class GlobalNotificationNotifier extends StateNotifier<GlobalNotificationState?> {
  GlobalNotificationNotifier() : super(null);

  Timer? _timer;

  void show(GlobalNotificationData data) {
    state = (isShow: true, data: data);

    _timer?.cancel();

    if (data is! GlobalNotificationLoading) {
      _timer = Timer(const Duration(seconds: 3), () {
        state = (isShow: false, data: data);
      });
    }
  }

  void hide() {
    _timer?.cancel();
    state = (isShow: false, data: state?.data);
  }
}
