// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/notifications/data/model/ion_notification.c.dart';

abstract class IonNotificationRepository<N extends IonNotification> {
  Future<List<N>> getNotifications();
}
