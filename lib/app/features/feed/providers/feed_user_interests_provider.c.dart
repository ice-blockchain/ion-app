import 'dart:convert';
import 'dart:ui';

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/config/data/models/app_config_cache_strategy.dart';
import 'package:ion/app/features/config/providers/config_repository.c.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
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
  Future<FeedInterests?> build(FeedType feedType) {
    listenSelf((_, next) => _saveState(next.valueOrNull));
    ref.listen<AppLifecycleState>(
      appLifecycleProvider,
      (previous, next) async {
        if (next == AppLifecycleState.resumed) {
          state = AsyncData(await _syncState());
        }
      },
    );
    return _syncState();
  }

  Future<void> updateInterests(
    FeedInterestInteraction interaction,
    List<String> interactionCategories,
  ) async {
    //TODO:what if call a method from notifier without using provider?
    final interests = await _syncState();
    final updatedInterests = interests.applyInteraction(
      interaction,
      interactionCategories,
    );
    state = AsyncData(updatedInterests);
  }

  Future<FeedInterests> _syncState() async {
    final localState = state.valueOrNull ?? _loadSavedState();
    final remoteState = await _getRemoteState();
    return _mergeStates(local: localState, remote: remoteState);
  }

  void _saveState(FeedInterests? nextState) {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    if (identityKeyName == null || nextState == null) {
      return;
    }
    ref
        .read(userPreferencesServiceProvider(identityKeyName: identityKeyName))
        .setValue(_persistanceKey, jsonEncode(nextState.toJson()));
  }

  Future<FeedInterests> _getRemoteState() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return FeedInterests.fromJson({
      'sports': {
        'weight': 4,
        'children': {
          'football': {'weight': 1},
          'tennis': {'weight': 2},
          'swimming': {'weight': 3},
        },
      },
      'gaming': {
        'weight': 10,
        'children': {
          'moba': {'weight': 1},
          'fps': {'weight': 2},
          'rpg': {'weight': 3},
        },
      },
      'crypto': {
        'weight': 3,
        'children': {
          'defi': {'weight': 1},
          'stablecoins': {'weight': 2},
          'nfts': {'weight': 3},
        },
      },
    });

    // final repository = await ref.read(configRepositoryProvider.future);
    // final env = ref.read(envProvider.notifier);
    // final cacheDuration = env.get<Duration>(EnvVariable.GENERIC_CONFIG_CACHE_DURATION);
    // return repository.getConfig<FeedInterests>(
    //   'TODO', //TODO: set url
    //   cacheStrategy: AppConfigCacheStrategy.file,
    //   refreshInterval: cacheDuration.inMilliseconds,
    //   parser: (data) => FeedInterests.fromJson(jsonDecode(data) as Map<String, dynamic>),
    //   checkVersion: true,
    // );
  }

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
      final localCategory =
          local.categories[remoteKey] ?? const FeedInterestsCategory(weight: 0, children: {});

      final mergedSubcategories = <String, FeedInterestsSubcategory>{};

      for (final subEntry in remoteCategory.children.entries) {
        mergedSubcategories[subEntry.key] =
            localCategory.children[subEntry.key] ?? const FeedInterestsSubcategory(weight: 0);
      }

      mergedCategories[remoteKey] = FeedInterestsCategory(
        weight: localCategory.weight,
        children: mergedSubcategories,
      );
    }

    return FeedInterests(categories: mergedCategories);
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
}
