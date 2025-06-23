// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/config/data/models/app_config_cache_strategy.dart';
import 'package:ion/app/features/config/providers/config_repository.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_pubkeys_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> servicePubkeys(Ref ref) async {
  final repo = await ref.watch(configRepositoryProvider.future);
  final result = await repo.getConfig<List<String>>(
    'service_pubkeys',
    cacheStrategy: AppConfigCacheStrategy.localStorage,
    parser: (data) => (jsonDecode(data) as List<dynamic>).cast<String>(),
    checkVersion: true,
  );
  return result;
}
