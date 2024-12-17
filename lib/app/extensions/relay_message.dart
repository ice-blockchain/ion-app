// SPDX-License-Identifier: ice License 1.0

import 'package:nostr_dart/nostr_dart.dart';

extension ErrorMessage on RelayMessage {
  bool get indicatesError => this is NoticeMessage || this is ClosedMessage;
}
