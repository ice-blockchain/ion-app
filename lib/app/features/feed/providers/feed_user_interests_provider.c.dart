// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:ui';

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/config/data/models/app_config_cache_strategy.dart';
import 'package:ion/app/features/config/providers/config_repository.c.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.c.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/features/feed/data/models/feed_interests.c.dart';
import 'package:ion/app/features/feed/data/models/feed_interests_interaction.c.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_user_interests_provider.c.g.dart';

@riverpod
class FeedUserInterests extends _$FeedUserInterests {
  @override
  Future<FeedInterests> build(FeedType feedType) {
    ref.listen<AppLifecycleState>(
      appLifecycleProvider,
      (previous, next) async {
        if (next == AppLifecycleState.resumed) {
          state = AsyncData(await _syncState(feedType));
        }
      },
    );
    return _syncState(feedType);
  }

  Future<void> updateInterests(
    FeedInterestInteraction interaction,
    List<String> interactionCategories,
  ) async {
    final interests = await future;
    final updatedInterests = interests.applyInteraction(
      interaction,
      interactionCategories,
    );
    await _saveState(updatedInterests);
    state = AsyncData(updatedInterests);
  }

  Future<FeedInterests> _syncState(FeedType feedType, {bool forceRemote = false}) async {
    final localState = _loadSavedState();
    final remoteState = await _getRemoteState(feedType, force: forceRemote);
    final mergedState = _mergeStates(local: localState, remote: remoteState);
    if (mergedState != localState) {
      await _saveState(mergedState);
    }
    return mergedState;
  }

  Future<void> _saveState(FeedInterests interests) async {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    if (identityKeyName == null) {
      return;
    }
    return ref
        .read(userPreferencesServiceProvider(identityKeyName: identityKeyName))
        .setValue(_persistanceKey, jsonEncode(interests.categories));
  }

  Future<FeedInterests> _getRemoteState(FeedType feedType, {bool force = false}) async {
    final repository = await ref.read(configRepositoryProvider.future);
    final locale = ref.read(appLocaleProvider).languageCode;
    final type = _getConfigTopicsContentType(feedType);

    return repository.getConfig<FeedInterests>(
      'content-topics_${type}_$locale',
      cacheStrategy: AppConfigCacheStrategy.file,
      refreshInterval: force ? Duration.zero : null,
      parser: (data) => FeedInterests.fromJson(jsonDecode(data) as Map<String, dynamic>),
      checkVersion: true,
    );
  }

  String _getConfigTopicsContentType(FeedType feedType) => switch (feedType) {
        FeedType.post => 'posts',
        FeedType.story => 'stories',
        FeedType.video => 'videos',
        FeedType.article => 'articles',
      };

  FeedInterests? _loadSavedState() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

    if (identityKeyName == null) {
      return null;
    }

    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    final savedState = userPreferencesService.getValue<String>(_persistanceKey);

    if (savedState == null) {
      return null;
    }

    try {
      return FeedInterests.fromJson(jsonDecode(savedState) as Map<String, dynamic>);
    } catch (error, stackTrace) {
      Logger.error(
        error,
        stackTrace: stackTrace,
        message: 'Failed to load saved user feed interests',
      );
      return null;
    }
  }

  /// Merges the local and remote [FeedInterests] states.
  ///
  /// - For categories present in both local and remote states, the local weight is preserved.
  /// - New categories found only in the remote state are included with a default weight of 0.
  /// - Categories that exist in the local state but are missing from the remote state are removed.
  FeedInterests _mergeStates({
    required FeedInterests? local,
    required FeedInterests remote,
  }) {
    if (local == null) {
      return remote;
    }

    final mergedCategories = <String, FeedInterestsCategory>{};

    for (final MapEntry(key: remoteKey, value: remoteCategory) in remote.categories.entries) {
      final localCategory = local.categories[remoteKey] ??
          const FeedInterestsCategory(
            weight: 0,
            children: {},
            display: '',
          );

      final mergedSubcategories = <String, FeedInterestsSubcategory>{};

      for (final subEntry in remoteCategory.children.entries) {
        final localSubcategory = localCategory.children[subEntry.key];
        mergedSubcategories[subEntry.key] = FeedInterestsSubcategory(
          weight: localSubcategory?.weight ?? 0,
          display: subEntry.value.display,
          iconUrl: subEntry.value.iconUrl,
        );
      }

      mergedCategories[remoteKey] = FeedInterestsCategory(
        display: remoteCategory.display,
        weight: localCategory.weight,
        children: mergedSubcategories,
        iconUrl: remoteCategory.iconUrl,
      );
    }

    return FeedInterests(categories: mergedCategories, version: remote.version);
  }

  String get _persistanceKey => 'feed_user_interests_${feedType.name}';
}

@riverpod
class FeedUserInterestsNotifier extends _$FeedUserInterestsNotifier {
  @override
  void build() {}

  Future<void> updateInterests(
    FeedInterestInteraction interaction,
    List<String> interactionCategories,
  ) async {
    await Future.wait([
      for (final feedType in FeedType.values)
        ref
            .read(feedUserInterestsProvider(feedType).notifier)
            .updateInterests(interaction, interactionCategories),
    ]);
  }

  Future<void> forceRemoteSync() async {
    await Future.wait([
      for (final feedType in FeedType.values)
        ref.read(feedUserInterestsProvider(feedType).notifier)._syncState(
              feedType,
              forceRemote: true,
            ),
    ]);
  }
}
