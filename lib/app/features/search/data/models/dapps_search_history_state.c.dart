// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dapps_search_history_state.c.freezed.dart';

@freezed
class DAppsSearchHistoryState with _$DAppsSearchHistoryState {
  const factory DAppsSearchHistoryState({
    required List<int> ids,
    required List<String> queries,
  }) = _DAppsSearchHistoryState;
}
