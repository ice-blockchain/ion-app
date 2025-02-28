// SPDX-License-Identifier: ice License 1.0

// ignore_for_file: constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    final value = dotenv.get(variable.name);

    return switch (T) {
      bool => (value.toLowerCase() == 'true') as T,
      int => int.parse(value) as T,
      double => double.parse(value) as T,
      String => value as T,
      _ => throw Exception('Unsupported type $T'),
    };
  }
}
