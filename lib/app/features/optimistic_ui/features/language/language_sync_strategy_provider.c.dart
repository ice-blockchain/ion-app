// SPDX-License-Identifier: ICE License 1.0
import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/optimistic_ui/core/operation_manager.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_service.dart';
import 'package:ion/app/features/optimistic_ui/features/language/language_sync_strategy.dart';
import 'package:ion/app/features/settings/model/content_lang_set.c.dart';
import 'package:ion/app/features/user/model/interest_set.c.dart';
import 'package:ion/app/features/user/providers/user_interests_set_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'language_sync_strategy_provider.c.g.dart';

@riverpod
LanguageSyncStrategy languageSyncStrategy(Ref ref) {
  final notifier = ref.read(ionConnectNotifierProvider.notifier);
  return LanguageSyncStrategy(sendInterestSet: notifier.sendEntityData);
}

@Riverpod(keepAlive: true)
OptimisticOperationManager<ContentLangSet> contentLanguageManager(Ref ref) {
  final strategy = ref.watch(languageSyncStrategyProvider);

  final manager = OptimisticOperationManager<ContentLangSet>(
    syncCallback: strategy.send,
    onError: (_, err) async => err is TimeoutException,
  );

  ref.onDispose(manager.dispose);
  return manager;
}

@riverpod
OptimisticService<ContentLangSet> contentLanguageService(Ref ref) {
  final manager = ref.watch(contentLanguageManagerProvider);
  final service = OptimisticService<ContentLangSet>(manager: manager);

  if (manager.snapshot.isEmpty) {
    service.initialize([_initialLangSet(ref)]);
  }

  ref.watch(currentUserInterestsSetProvider(InterestSetType.languages)).whenData((entity) {
    final pubkey = ref.read(currentPubkeySelectorProvider);
    if (entity == null || pubkey == null) return;

    final updated = ContentLangSet(
      pubkey: pubkey,
      hashtags: entity.data.hashtags,
    ).sorted;

    service.initialize([updated]);
  });

  return service;
}

@riverpod
Stream<ContentLangSet?> contentLanguageWatch(Ref ref) {
  final service = ref.watch(contentLanguageServiceProvider);
  final pubkey = ref.watch(currentPubkeySelectorProvider);

  return pubkey == null ? Stream.value(null) : service.watch(pubkey);
}

ContentLangSet _initialLangSet(Ref ref) {
  final pubkey = ref.read(currentPubkeySelectorProvider)!;
  final entity = ref.read(currentUserInterestsSetProvider(InterestSetType.languages)).value;

  final currentAppLangIso = ref.read(localePreferredLanguageProvider).isoCode;

  final initial = entity?.data.hashtags;

  return ContentLangSet(
    pubkey: pubkey,
    hashtags: (initial == null || initial.isEmpty) ? [currentAppLangIso] : initial,
  ).sorted;
}
