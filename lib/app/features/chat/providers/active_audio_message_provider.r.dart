// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_audio_message_provider.r.g.dart';

@riverpod
class ActiveAudioMessage extends _$ActiveAudioMessage {
  @override
  String? build() => null;

  set activeAudioMessage(String? eventMessageId) => state = eventMessageId;
}
