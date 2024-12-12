// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/components/global_notification_bar/models/global_notification_data.dart';

part 'global_notification_state.c.freezed.dart';

@freezed
class GlobalNotificationState with _$GlobalNotificationState {
  const factory GlobalNotificationState({
    @Default(false) bool isShow,
    GlobalNotificationData? data,
  }) = _GlobalNotificationState;
}
