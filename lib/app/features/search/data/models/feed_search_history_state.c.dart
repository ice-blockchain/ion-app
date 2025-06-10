// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_search_history_state.c.freezed.dart';

@freezed
class FeedSearchHistoryState with _$FeedSearchHistoryState {
  const factory FeedSearchHistoryState({
    required List<String> pubKeys,
    required List<String> queries,
  }) = _FeedSearchHistoryState;
}
