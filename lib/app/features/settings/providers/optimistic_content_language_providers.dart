// SPDX-License-Identifier: ice License 1.0

// Optimistic UI providers for Content‑Language settings.

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/optimistic_ui/operation_manager.dart';
import 'package:ion/app/features/settings/model/content_lang_set.dart';
import 'package:ion/app/features/user/model/interest_set.c.dart';
import 'package:ion/app/features/user/providers/user_interests_set_provider.c.dart';

/// Provides a singleton [OptimisticOperationManager] that synchronises content
/// language changes with the backend while offering an immediate feedback in
/// the UI.
final optimisticContentLangManagerProvider =
    Provider.autoDispose<OptimisticOperationManager<ContentLangSet>>((ref) {
  final api = ref.read(ionConnectNotifierProvider.notifier);

  // Attempt to obtain existing snack messenger if present.  We keep the import
  // optional to prevent hard dependency in case the helper is moved / renamed.

  final manager = OptimisticOperationManager<ContentLangSet>(
    syncCallback: (previous, optimistic) async {
      // Convert to InterestSetData expected by the backend and send.
      final data = InterestSetData(
        type: InterestSetType.languages,
        hashtags: optimistic.hashtags,
      );

      await api.sendEntityData<InterestSetEntity>(data);

      // Backend echoes same state on success – just return optimistic.
      return optimistic;
    },
    onError: (message, error) async {
      // Log to console (the UI will rollback automatically).
      // ignore: avoid_print
      print('Optimistic content‑language sync failed: $message, error: $error');
      return false; // rollback
    },
  );

  // Initialise with current value when it becomes available from the regular
  // (non‑optimistic) provider that listens to network/cache.
  ref
    ..listen<AsyncValue<InterestSetEntity?>>(
      currentUserInterestsSetProvider(InterestSetType.languages),
      (prev, next) {
        next.whenData((entity) {
          if (entity == null) return;

          final initial = ContentLangSet(
            pubkey: entity.pubkey,
            hashtags: entity.data.hashtags,
          );

          manager.initialize([initial]);
        });
      },
    )
    ..onDispose(manager.dispose);
  return manager;
});

/// Stream of current [ContentLangSet] enriched with optimistic updates.
final contentLangSetStreamProvider = StreamProvider.autoDispose<ContentLangSet?>((ref) {
  final manager = ref.watch(optimisticContentLangManagerProvider);
  return manager.stream.map((list) => list.isEmpty ? null : list.first);
});

/// Simple wrapper that exposes mutation methods for the UI layer.
class ContentLangSetController {
  ContentLangSetController(this._ref);

  final Ref _ref;

  /// Toggle given [langIsoCode] in the optimistic language set.
  void toggle(String langIsoCode) {
    final currentPubkey = _ref.read(currentPubkeySelectorProvider);
    if (currentPubkey == null) return;

    final currentSet = _ref.read(contentLangSetStreamProvider).asData?.value ??
        ContentLangSet(pubkey: currentPubkey, hashtags: const []);

    final updated = List<String>.from(currentSet.hashtags);
    if (updated.contains(langIsoCode)) {
      updated.remove(langIsoCode);
    } else {
      updated.add(langIsoCode);
    }

    // Business rule: keep at least one language selected.
    if (updated.isEmpty) return;

    final newSet = ContentLangSet(pubkey: currentSet.pubkey, hashtags: updated);

    _ref
        .read(optimisticContentLangManagerProvider)
        .perform(previous: currentSet, optimistic: newSet);
  }
}

final contentLangSetControllerProvider = Provider.autoDispose<ContentLangSetController>(
  ContentLangSetController.new,
);
