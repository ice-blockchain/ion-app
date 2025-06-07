// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_search_history_state.c.freezed.dart';

@freezed
class ChatSearchHistoryState with _$ChatSearchHistoryState {
  const factory ChatSearchHistoryState({
    required List<String> pubKeys,
    required List<String> queries,
  }) = _ChatSearchHistoryState;
}
