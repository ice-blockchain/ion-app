// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/delta.dart';
import 'package:ion/app/features/feed/create_article/providers/create_article_provider.c.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/providers/counters/replies_count_provider.c.dart';
import 'package:ion/app/features/feed/providers/counters/reposted_events_notifier.c.dart';
import 'package:ion/app/features/feed/providers/counters/reposts_count_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_posts_provider.c.dart';
import 'package:ion/app/features/feed/providers/user_posts_data_source_provider.c.dart';
import 'package:ion/app/features/feed/providers/user_videos_data_source_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/action_source.c.dart';
import 'package:ion/app/features/ion_connect/data/models/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/data/models/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/data/models/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_delete_file_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_events_metadata_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/markdown/quill.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_entity_provider.c.g.dart';

@riverpod
class DeleteEntityController extends _$DeleteEntityController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> deleteByReference(
    EventReference eventReference, {
    FutureOr<void> Function()? onDelete,
  }) async {
    state = const AsyncValue.loading();
    try {
      final entity =
          await ref.read(ionConnectEntityProvider(eventReference: eventReference).future);
      if (entity == null) {
        throw EntityNotFoundException(eventReference);
      }
      await _deleteEntity(entity);
      await onDelete?.call();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      Logger.error(error, stackTrace: stackTrace, message: 'Error deleting entity $eventReference');
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteEntity(
    IonConnectEntity entity, {
    FutureOr<void> Function()? onDelete,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _deleteEntity(entity);
      await onDelete?.call();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      Logger.error(error, stackTrace: stackTrace, message: 'Error deleting entity $entity');
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> _deleteEntity(IonConnectEntity entity) async {
    switch (entity) {
      case GenericRepostEntity() || RepostEntity() || PostEntity():
        {
          await _deleteFromServer(ref, entity);
          if (entity is PostEntity) _deleteMedia(ref, entity.data);
          _deleteFromDataSources(ref, entity);
          _deleteFromCache(ref, entity);
          _deleteFromCounters(ref, entity);
          _deleteFromProviders(ref, entity);
        }
      case ModifiablePostEntity():
        {
          _deleteFromCounters(ref, entity);
          await ref
              .read(createPostNotifierProvider(CreatePostOption.softDelete).notifier)
              .softDelete(eventReference: entity.toEventReference());
          _deleteFromDataSources(ref, entity);
        }
      case ArticleEntity():
        {
          await ref
              .read(createArticleProvider(CreateArticleOption.softDelete).notifier)
              .softDelete(eventReference: entity.toEventReference());
        }
      case ReactionEntity():
        {
          await _deleteFromServer(ref, entity);
        }
      default:
        {
          throw DeleteEntityUnsupportedTypeException();
        }
    }
  }
}

Future<void> _deleteFromServer(Ref ref, IonConnectEntity entity) async {
  final entityKind = switch (entity) {
    ReactionEntity() => ReactionEntity.kind,
    PostEntity() => PostEntity.kind,
    RepostEntity() => RepostEntity.kind,
    GenericRepostEntity() => GenericRepostEntity.kind,
    _ => throw DeleteEntityUnsupportedTypeException(),
  };

  final pubkeysToPublish = switch (entity) {
    ReactionEntity() => [entity.data.eventReference.pubkey],
    PostEntity() => parseAndConvertDelta(
        entity.data.richText?.content,
        entity.data.content,
      ).extractPubkeys(),
    RepostEntity() => [entity.data.eventReference.pubkey],
    GenericRepostEntity() => [entity.data.eventReference.pubkey],
    _ => <String>[],
  };

  final deletionRequest = DeletionRequest(
    events: [
      EventToDelete(
        eventReference: ImmutableEventReference(
          pubkey: entity.masterPubkey,
          eventId: entity.id,
          kind: entityKind,
        ),
      ),
    ],
  );

  final ionNotifier = ref.read(ionConnectNotifierProvider.notifier);

  final deletionEvent = await ionNotifier.sign(deletionRequest);

  final userEventsMetadataBuilder = await ref.read(userEventsMetadataBuilderProvider.future);

  await Future.wait([
    ionNotifier.sendEvent(deletionEvent, cache: false),
    for (final pubkey in pubkeysToPublish)
      ionNotifier.sendEvent(
        deletionEvent,
        actionSource: ActionSourceUser(pubkey),
        metadataBuilders: [userEventsMetadataBuilder],
        cache: false,
      ),
  ]);
}

void _deleteFromDataSources(Ref ref, IonConnectEntity entity) {
  final notifiers = <PagedNotifier>[
    ref.read(
      entitiesPagedDataProvider(ref.read(userVideosDataSourceProvider(entity.masterPubkey)))
          .notifier,
    ),
    ref.read(
      entitiesPagedDataProvider(ref.read(userPostsDataSourceProvider(entity.masterPubkey)))
          .notifier,
    ),
    ref.read(feedPostsProvider.notifier),
    ref.read(feedStoriesProvider.notifier),
  ];

  for (final notifier in notifiers) {
    notifier.deleteEntity(entity);
  }
}

void _deleteFromCache(Ref ref, IonConnectEntity entity) {
  if (entity is CacheableEntity) {
    ref.read(ionConnectCacheProvider.notifier).remove(entity.cacheKey);
  }
}

void _deleteFromCounters(Ref ref, IonConnectEntity entity) {
  switch (entity) {
    case RepostEntity():
      ref.read(repostsCountProvider(entity.data.eventReference).notifier).removeOne();
    case GenericRepostEntity():
      ref.read(repostsCountProvider(entity.data.eventReference).notifier).removeOne();
    case ModifiablePostEntity():
      if (entity.data.parentEvent != null) {
        ref
            .read(repliesCountProvider(entity.data.parentEvent!.eventReference).notifier)
            .removeOne();
      } else if (entity.data.quotedEvent != null) {
        ref
            .read(repostsCountProvider(entity.data.quotedEvent!.eventReference).notifier)
            .removeOne(isQuote: true);
      }
    default:
      break;
  }
}

void _deleteFromProviders(Ref ref, IonConnectEntity entity) {
  final eventReference = switch (entity) {
    RepostEntity() => entity.data.eventReference,
    GenericRepostEntity() => entity.data.eventReference,
    _ => null,
  };

  if (eventReference != null) {
    ref.read(repostedEventsNotifierProvider.notifier).removeRepost(eventReference);
  }
}

void _deleteMedia(Ref ref, EntityDataWithMediaContent entity) {
  final media = entity.media.values;
  final fileHashes = media.map((e) => e.originalFileHash).toList();
  ref.read(ionConnectDeleteFileNotifierProvider.notifier).deleteMultiple(fileHashes);
}
