// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';

abstract class PersistentSubscriptionEncryptedEventMessageHandler {
  bool canHandle({
    required IonConnectGiftWrapEntity entity,
  });
  Future<void> handle(EventMessage rumor);
}
