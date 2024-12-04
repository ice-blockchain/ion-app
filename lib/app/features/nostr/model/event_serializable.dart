// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:nostr_dart/nostr_dart.dart';

abstract class EventSerializable {
  FutureOr<EventMessage> toEventMessage(EventSigner signer, {List<List<String>> tags = const []});
}
