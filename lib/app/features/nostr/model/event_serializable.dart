// SPDX-License-Identifier: ice License 1.0

import 'package:nostr_dart/nostr_dart.dart';

abstract class EventSerializable {
  EventMessage toEventMessage(EventSigner signer, {List<List<String>> tags = const []});
}
