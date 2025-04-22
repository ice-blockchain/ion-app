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
  final api = ref.read(ionConnectNotifierProvider.notifier);

  final manager = OptimisticOperationManager<ContentLangSet>(
    syncCallback: (previous, optimistic) async {
      final data = InterestSetData(
        type: InterestSetType.languages,
        hashtags: optimistic.hashtags,
      );

      await api.sendEntityData<InterestSetEntity>(data);
      return optimistic;
    },
    onError: (_, __) async => false, // rollback silently
  );

  ref
    ..listen<AsyncValue<InterestSetEntity?>>(
      currentUserInterestsSetProvider(InterestSetType.languages),
      (prev, next) {
        next.whenData((entity) {
          if (entity == null) return;

          manager.initialize([
            ContentLangSet(
              pubkey: entity.pubkey,
              hashtags: entity.data.hashtags,
            ).sorted,
          ]);
        });
      },
    )
    ..onDispose(manager.dispose);
  return manager;
}

/// Stream provider – always emits the latest content language set including optimistic changes.
@riverpod
Stream<ContentLangSet?> contentLangSet(Ref ref) {
  final mgr = ref.watch(optimisticContentLangManagerProvider);
  return mgr.stream.map((list) => list.isEmpty ? null : list.first);
}

@riverpod
class ContentLangSetNotifier extends _$ContentLangSetNotifier {
  @override
  void build() {}

  void toggle(String langIso) {
    final pubkey = ref.read(currentPubkeySelectorProvider);
    if (pubkey == null) return;

    final current = ref.read(contentLangSetProvider).valueOrNull ??
        ContentLangSet(pubkey: pubkey, hashtags: const []);

    final updated = List<String>.from(current.hashtags);
    updated.contains(langIso) ? updated.remove(langIso) : updated.add(langIso);

    if (updated.isEmpty) return;

    ref.read(optimisticContentLangManagerProvider).perform(
          previous: current,
          optimistic: ContentLangSet(pubkey: current.pubkey, hashtags: updated).sorted,
        );
  }
}
