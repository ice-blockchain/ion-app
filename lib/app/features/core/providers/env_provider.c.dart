// SPDX-License-Identifier: ice License 1.0

// ignore_for_file: constant_identifier_names

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'env_provider.c.g.dart';

enum EnvVariable {
  ION_ANDROID_APP_ID,
  ION_IOS_APP_ID,
  ION_ORIGIN,
  SHOW_DEBUG_INFO,
  BANUBA_TOKEN,
  STORY_EXPIRATION_HOURS,
  VERSIONS_CONFIG_REFETCH_INTERVAL,
  EDIT_POST_ALLOWED_MINUTES,
  COMMUNITY_CREATION_CACHE_MINUTES,
  COMMUNITY_MEMBERS_COUNT_CACHE_MINUTES,
  GIFT_WRAP_EXPIRATION_HOURS,
  ICLOUD_CONTAINER_ID,
}

@Riverpod(keepAlive: true)
class Env extends _$Env {
  @override
  void build() {}

  /// Gets a typed environment variable value.
  /// Throws if the variable is not found or cannot be converted to type [T].
  T get<T>(EnvVariable variable) {
    return switch (variable) {
      EnvVariable.ION_ANDROID_APP_ID => const String.fromEnvironment('ION_ANDROID_APP_ID') as T,
      EnvVariable.ION_IOS_APP_ID => const String.fromEnvironment('ION_IOS_APP_ID') as T,
      EnvVariable.ION_ORIGIN => const String.fromEnvironment('ION_ORIGIN') as T,
      EnvVariable.SHOW_DEBUG_INFO => const bool.fromEnvironment('SHOW_DEBUG_INFO') as T,
      EnvVariable.BANUBA_TOKEN => const String.fromEnvironment('BANUBA_TOKEN') as T,
      EnvVariable.STORY_EXPIRATION_HOURS =>
        const int.fromEnvironment('STORY_EXPIRATION_HOURS') as T,
      EnvVariable.VERSIONS_CONFIG_REFETCH_INTERVAL =>
        const int.fromEnvironment('VERSIONS_CONFIG_REFETCH_INTERVAL') as T,
      EnvVariable.EDIT_POST_ALLOWED_MINUTES =>
        const int.fromEnvironment('EDIT_POST_ALLOWED_MINUTES') as T,
      EnvVariable.COMMUNITY_CREATION_CACHE_MINUTES =>
        const int.fromEnvironment('COMMUNITY_CREATION_CACHE_MINUTES') as T,
      EnvVariable.COMMUNITY_MEMBERS_COUNT_CACHE_MINUTES =>
        const int.fromEnvironment('COMMUNITY_MEMBERS_COUNT_CACHE_MINUTES') as T,
      EnvVariable.GIFT_WRAP_EXPIRATION_HOURS =>
        const int.fromEnvironment('GIFT_WRAP_EXPIRATION_HOURS') as T,
      EnvVariable.ICLOUD_CONTAINER_ID => const String.fromEnvironment('ICLOUD_CONTAINER_ID') as T,
    };
  }
}
