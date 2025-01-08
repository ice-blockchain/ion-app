// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/ion_connect/ion_connect.dart';

abstract class EventSerializable {
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  });
}
