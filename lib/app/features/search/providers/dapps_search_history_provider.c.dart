// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/search/data/models/dapps_search_history_state.c.dart';
import 'package:ion/app/services/providers/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dapps_search_history_provider.c.g.dart';

@riverpod
class DAppsSearchHistory extends _$DAppsSearchHistory {
  static const String _dAppsIdsStoreKey = 'DAppsSearchHistory:dAppsIdsKeys';
  static const String _queriesStoreKey = 'DAppsSearchHistory:queries';

  @override
  DAppsSearchHistoryState build() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));

    final storedAppsIds = userPreferencesService.getValue<List<int>>(_dAppsIdsStoreKey) ?? [];
    final storedQueries = userPreferencesService.getValue<List<String>>(_queriesStoreKey) ?? [];

    return DAppsSearchHistoryState(ids: storedAppsIds, queries: storedQueries);
  }

  Future<void> addDAppIdToTheHistory(int id) async {
    if (!state.ids.contains(id)) {
      final newDAppsIds = [id, ...state.ids];

      final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
      final userPreferencesService =
          ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName));
      await userPreferencesService.setValue<List<int>>(_dAppsIdsStoreKey, newDAppsIds);

      state = state.copyWith(ids: newDAppsIds);
    }
  }

  Future<void> addQueryToTheHistory(String query) async {
    if (!state.queries.contains(query)) {
      final newQueries = [query, ...state.queries];

      final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
      final userPreferencesService =
          ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName));
      await userPreferencesService.setValue<List<String>>(_queriesStoreKey, newQueries);

      state = state.copyWith(queries: newQueries);
    }
  }

  Future<void> clear() async {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService =
        ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    await Future.wait([
      userPreferencesService.remove(_dAppsIdsStoreKey),
      userPreferencesService.remove(_queriesStoreKey),
    ]);
    state = const DAppsSearchHistoryState(queries: [], ids: []);
  }
}
