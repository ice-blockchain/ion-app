// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/notifications/data/model/notifications_type.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

part 'ion_connect_notification.c.freezed.dart';

@freezed
class IonConnectNotification with _$IonConnectNotification {
  const factory IonConnectNotification({
    required NotificationsType type,
    required List<String> pubkeys,
    required DateTime timestamp,
    EventReference? eventReference,
  }) = _IonConnectNotification;
}
