// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'draft_message_provider.r.g.dart';

@Riverpod(keepAlive: true)
class DraftMessage extends _$DraftMessage {
  @override
  String? build(String conversationId) => null;

  set draftMessage(String draftMessage) => state = draftMessage;

  void clear() => state = null;
}
