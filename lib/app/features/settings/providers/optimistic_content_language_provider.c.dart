// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/optimistic_ui/operation_manager.dart';
import 'package:ion/app/features/settings/model/content_lang_set.c.dart';
import 'package:ion/app/features/user/model/interest_set.c.dart';
import 'package:ion/app/features/user/providers/user_interests_set_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'optimistic_content_language_provider.c.g.dart';

@riverpod
OptimisticOperationManager<ContentLangSet> optimisticContentLangManager(Ref ref) {
  final ionConnectNotifier = ref.read(ionConnectNotifierProvider.notifier);

  final manager = OptimisticOperationManager<ContentLangSet>(
    syncCallback: (previous, optimistic) async {
      await ionConnectNotifier.sendEntityData<InterestSetEntity>(
        InterestSetData(
          type: InterestSetType.languages,
          hashtags: optimistic.hashtags,
        ),
      );
      return optimistic;
    },
    onError: (_, __) async => false,
  );

  final pubkey = ref.read(currentPubkeySelectorProvider);

  if (pubkey != null) {
    manager.initialize([
      ContentLangSet(
        pubkey: pubkey,
        hashtags: const [],
      ).sorted,
    ]);
  }

  ref.watch(currentUserInterestsSetProvider(InterestSetType.languages)).whenData((entity) {
    if (entity == null) return;
    manager.initialize([
      ContentLangSet(
        pubkey: entity.pubkey,
        hashtags: entity.data.hashtags,
      ).sorted,
    ]);
  });

  ref.onDispose(manager.dispose);

  return manager;
}

@riverpod
Stream<ContentLangSet?> contentLangSet(Ref ref) async* {
  final mgr = ref.watch(optimisticContentLangManagerProvider);

  if (mgr.snapshot.isNotEmpty) {
    yield mgr.snapshot.first;
  }

  yield* mgr.stream.map((list) => list.isEmpty ? null : list.first);
}

@riverpod
class ContentLangSetNotifier extends _$ContentLangSetNotifier {
  @override
  AsyncValue<ContentLangSet> build() {
    final manager = ref.read(optimisticContentLangManagerProvider);
    final initial = manager.snapshot.isNotEmpty
        ? manager.snapshot.first
        : ContentLangSet(pubkey: ref.read(currentPubkeySelectorProvider)!, hashtags: []);
    return AsyncValue.data(initial);
  }

  void toggle(String iso) {
    final pubkey = ref.read(currentPubkeySelectorProvider);
    if (pubkey == null) return;

    final current = ref.read(contentLangSetProvider).maybeWhen(
              data: (value) => value,
              orElse: () => null,
            ) ??
        ContentLangSet(pubkey: pubkey, hashtags: const []);

    final updated = [...current.hashtags];
    updated.contains(iso) ? updated.remove(iso) : updated.add(iso);
    if (updated.isEmpty) return;

    ref.read(optimisticContentLangManagerProvider).perform(
          previous: current,
          optimistic: current.copyWith(hashtags: updated).sorted,
        );
  }
}
