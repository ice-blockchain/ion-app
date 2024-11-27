// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/model/channel_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channels_provider.g.dart';

@Riverpod(keepAlive: true)
class Channels extends _$Channels {
  @override
  Map<String, ChannelData> build() {
    final result = <String, ChannelData>{};
    return Map<String, ChannelData>.unmodifiable(result);
  }

  void setChannel(String id, ChannelData data) {
    final newState = Map<String, ChannelData>.from(state);
    newState[id] = data;
    state = Map<String, ChannelData>.unmodifiable(newState);
  }
}
