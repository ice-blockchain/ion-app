// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/providers/mock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_provider.g.dart';

@Riverpod()
class Conversations extends _$Conversations {
  @override
  Future<List<RecentChatDataModel>> build() {
    return Future.delayed(const Duration(seconds: 2), () {
      return mockConversationData;
    });
  }
}
