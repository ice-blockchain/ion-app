// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.f.dart';
import 'package:ion/app/features/feed/data/models/feed_interests_interaction.dart';
import 'package:ion/app/features/feed/providers/counters/like_reaction_provider.r.dart';
import 'package:ion/app/features/feed/providers/counters/likes_count_provider.r.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.r.dart';
import 'package:ion/app/features/optimistic_ui/core/operation_manager.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_service.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/like_sync_strategy_provider.r.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/model/post_like.f.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/toggle_like_intent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_like_provider.r.g.dart';

@riverpod
List<PostLike> loadInitialLikesFromCache(Ref ref) {
  final currentPubkey = ref.read(currentPubkeySelectorProvider);
  final reactions = ref
      .read(ionConnectCacheProvider)
      .values
      .map((e) => e.entity)
      .whereType<ReactionEntity>()
      .where((r) => r.data.content == ReactionEntity.likeSymbol)
      .toList();

  final grouped = groupBy<ReactionEntity, EventReference>(
    reactions,
    (r) => r.data.eventReference,
  );

  return grouped.entries.map((entry) {
    final eventRef = entry.key;
    final list = entry.value;
    final count = list.length;
    final likedByMe = currentPubkey != null && list.any((r) => r.pubkey == currentPubkey);
    return PostLike(
      eventReference: eventRef,
      likesCount: count,
      likedByMe: likedByMe,
    );
  }).toList();
}

@riverpod
OptimisticService<PostLike> postLikeService(Ref ref) {
  final manager = ref.watch(postLikeManagerProvider);
  final loadInitialLikes = ref.watch(loadInitialLikesFromCacheProvider);
  final service = OptimisticService<PostLike>(manager: manager)
    ..initialize(loadInitialLikes);

  return service;
}

@riverpod
Stream<PostLike?> postLikeWatch(Ref ref, String id) {
  final service = ref.watch(postLikeServiceProvider);
  return service.watch(id);
}

@Riverpod(keepAlive: true)
OptimisticOperationManager<PostLike> postLikeManager(Ref ref) {
  final strategy = ref.watch(likeSyncStrategyProvider);

  final manager = OptimisticOperationManager<PostLike>(
    syncCallback: strategy.send,
    onError: (_, __) async => true,
  );

  ref.onDispose(manager.dispose);

  return manager;
}

@riverpod
class ToggleLikeNotifier extends _$ToggleLikeNotifier {
  final _processingOperations = <String>{};

  @override
  void build() {}

  Future<void> toggle(EventReference eventReference) async {
    final key = eventReference.toString();

    if (_processingOperations.contains(key)) return;

    _processingOperations.add(key);

    try {
      final service = ref.read(postLikeServiceProvider);
      final id = eventReference.toString();

      var current = ref.read(postLikeWatchProvider(id)).valueOrNull;

      current ??= PostLike(
        eventReference: eventReference,
        likesCount: ref.read(likesCountProvider(eventReference)),
        likedByMe: ref.read(isLikedProvider(eventReference)),
      );

      await service.dispatch(ToggleLikeIntent(), current);

      if (!current.likedByMe) {
        await _updateInterestsOnLike(eventReference);
      }

      await Future<void>.delayed(const Duration(milliseconds: 300));
    } finally {
      _processingOperations.remove(key);
    }
  }

  Future<void> _updateInterestsOnLike(EventReference eventReference) async {
    final entity = await ref.read(ionConnectEntityProvider(eventReference: eventReference).future);

    if (entity == null) throw EntityNotFoundException(eventReference);

    final hasParent = switch (entity) {
      ModifiablePostEntity() => entity.data.parentEvent != null,
      PostEntity() => entity.data.parentEvent != null,
      ArticleEntity() => false,
      _ => throw UnsupportedEntityType(entity)
    };

    final tags = switch (entity) {
      ModifiablePostEntity() => entity.data.relatedHashtags,
      PostEntity() => entity.data.relatedHashtags,
      ArticleEntity() => entity.data.relatedHashtags,
      _ => throw UnsupportedEntityType(entity)
    };

    final interaction =
        hasParent ? FeedInterestInteraction.likeReply : FeedInterestInteraction.likePostOrArticle;
    final interactionCategories = tags?.map((tag) => tag.value).toList() ?? [];

    if (interactionCategories.isNotEmpty) {
      await ref
          .read(feedUserInterestsNotifierProvider.notifier)
          .updateInterests(interaction, interactionCategories);
    }
  }
}
