// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_db_cache_notifier.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.r.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user/providers/users_relays_provider.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_entity_provider.r.g.dart';

@riverpod
IonConnectEntity? ionConnectCachedEntity(
  Ref ref, {
  required EventReference eventReference,
}) =>
    ref.watch(
      ionConnectCacheProvider.select(
        cacheSelector(CacheableEntity.cacheKeyBuilder(eventReference: eventReference)),
      ),
    );

@riverpod
Future<IonConnectEntity?> ionConnectNetworkEntity(
  Ref ref, {
  required EventReference eventReference,
  String? search,
  ActionSource? actionSource,
}) async {
  final aSource = actionSource ?? ActionSourceUser(eventReference.masterPubkey);
  if (eventReference is ImmutableEventReference) {
    final requestMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          ids: [eventReference.eventId],
          search: search,
          limit: 1,
        ),
      );
    return ref.read(ionConnectNotifierProvider.notifier).requestEntity(
          requestMessage,
          actionSource: aSource,
          entityEventReference: eventReference,
        );
  } else if (eventReference is ReplaceableEventReference) {
    final requestMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          kinds: [eventReference.kind],
          authors: [eventReference.masterPubkey],
          tags: {
            if (eventReference.dTag.isNotEmpty) '#d': [eventReference.dTag],
          },
          search: search,
          limit: 1,
        ),
      );
    return ref.read(ionConnectNotifierProvider.notifier).requestEntity(
          requestMessage,
          actionSource: aSource,
          entityEventReference: eventReference,
        );
  } else {
    throw UnsupportedEventReference(eventReference);
  }
}

@riverpod
Future<List<IonConnectEntity>> ionConnectNetworkEntities(
  Ref ref, {
  required ActionSource actionSource,
  required List<EventReference> eventReferences,
  String? search,
}) async {
  // Helper method to build filters for replaceable event references
  List<RequestFilter> buildReplaceableRefsFilters(
      List<ReplaceableEventReference> replaceableRefs, String? search) {
    final filters = <RequestFilter>[];

    if (replaceableRefs.isNotEmpty) {
      // Group by kind and dTag
      final grouped = <String, Map<String, List<ReplaceableEventReference>>>{};

      for (final ref in replaceableRefs) {
        final kindKey = ref.kind.toString();
        final dTagKey = ref.dTag;
        grouped.putIfAbsent(kindKey, () => <String, List<ReplaceableEventReference>>{});
        grouped[kindKey]!.putIfAbsent(dTagKey, () => <ReplaceableEventReference>[]);
        grouped[kindKey]![dTagKey]!.add(ref);
      }

      for (final kindEntry in grouped.entries) {
        final kind = int.parse(kindEntry.key);
        for (final dTagEntry in kindEntry.value.entries) {
          final dTag = dTagEntry.key;
          final refs = dTagEntry.value;
          if (dTag.isEmpty) {
            // Combine all masterPubkeys for this kind with empty dTag
            filters.add(
              RequestFilter(
                kinds: [kind],
                authors: refs.map((e) => e.masterPubkey).toList(),
                search: search,
              ),
            );
          } else {
            // Create separate filter for each ref with non-empty dTag
            for (final ref in refs) {
              filters.add(
                RequestFilter(
                  kinds: [ref.kind],
                  authors: [ref.masterPubkey],
                  tags: {
                    '#d': [ref.dTag],
                  },
                  search: search,
                ),
              );
            }
          }
        }
      }
    }

    return filters;
  }

  if (eventReferences.isEmpty) {
    return <IonConnectEntity>[];
  }

  final results = <IonConnectEntity>[];
  final immutableRefs = eventReferences.whereType<ImmutableEventReference>().toList();
  final replaceableRefs = eventReferences.whereType<ReplaceableEventReference>().toList();

  final replaceableRefsFilters = buildReplaceableRefsFilters(replaceableRefs, search);

  final requestMessage = RequestMessage()
    ..filters.addAll(
      [
        if (immutableRefs.isNotEmpty)
          RequestFilter(
            search: search,
            ids: immutableRefs.map((e) => e.eventId).toList(),
          ),
        ...replaceableRefsFilters,
      ],
    );

  final entityStream = ref.read(ionConnectNotifierProvider.notifier).requestEntities(
        requestMessage,
        actionSource: actionSource,
      );

  await for (final entity in entityStream.handleError(
    (Object error) {
      Logger.error('Error fetching entities for $actionSource: $error');
    },
    test: (_) => true,
  )) {
    results.add(entity);
  }

  return results;
}

@riverpod
Future<IonConnectEntity?> ionConnectDbEntity(
  Ref ref, {
  required EventReference eventReference,
}) async {
  return ref.read(ionConnectDbCacheProvider.notifier).get(eventReference);
}

@riverpod
Future<IonConnectEntity?> ionConnectEntity(
  Ref ref, {
  required EventReference eventReference,
  bool network = true,
  bool cache = true,
  String? search,
}) async {
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    throw const CurrentUserNotFoundException();
  }
  if (cache) {
    final entity = ref.watch(ionConnectCachedEntityProvider(eventReference: eventReference));
    if (entity != null) {
      return entity;
    }
  }
  if (network) {
    return ref.watch(
      ionConnectNetworkEntityProvider(eventReference: eventReference, search: search).future,
    );
  }
  return null;
}

@riverpod
IonConnectEntity? ionConnectSyncEntity(
  Ref ref, {
  required EventReference eventReference,
  bool network = true,
  bool cache = true,
  bool db = false,
  String? search,
}) {
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    throw const CurrentUserNotFoundException();
  }
  if (cache) {
    final entity = ref.watch(ionConnectCachedEntityProvider(eventReference: eventReference));
    if (entity != null) {
      return entity;
    }
  }

  if (db) {
    final entityState = ref.watch(ionConnectDbEntityProvider(eventReference: eventReference));
    if (entityState.isLoading) {
      return null;
    }
    final entity = entityState.valueOrNull;
    if (entity != null) {
      return entity;
    }
  }
  if (network) {
    return ref
        .watch(ionConnectNetworkEntityProvider(eventReference: eventReference, search: search))
        .valueOrNull;
  }
  return null;
}

@riverpod
class IonConnectEntitiesManager extends _$IonConnectEntitiesManager {
  @override
  FutureOr<void> build() {}

  Future<List<IonConnectEntity>> fetch({
    required List<EventReference> eventReferences,
    String? search,
    bool cache = true,
    bool network = true,
  }) async {
    final cachedResults = <IonConnectEntity>[];
    final networkResults = <IonConnectEntity>[];

    final currentUser = ref.read(currentIdentityKeyNameSelectorProvider);
    if (currentUser == null) {
      throw const CurrentUserNotFoundException();
    }

    if (cache) {
      cachedResults.addAll(
        eventReferences
            .map(
              (eventReference) => ref.read(
                ionConnectCacheProvider.select(
                  cacheSelector(CacheableEntity.cacheKeyBuilder(eventReference: eventReference)),
                ),
              ),
            )
            .nonNulls
            .toList(),
      );
    }

    if (network) {
      final notCachedEvents = eventReferences
          .toSet()
          .difference(cachedResults.map((e) => e.toEventReference()).toSet())
          .toList();

      final relaysMap = await ref.read(usersRelaysProvider.notifier).fetch(
            strategy: UsersRelaysStrategy.mostUsers,
            masterPubkeys: notCachedEvents.map((e) => e.masterPubkey).toSet().toList(),
          );

      final eventReferencesMap = relaysMap.map(
        (url, masterPubkeys) => MapEntry(
          url,
          notCachedEvents.where((e) => masterPubkeys.contains(e.masterPubkey)).toList(),
        ),
      );

      final futures = <Future<List<IonConnectEntity>>>[];

      for (final url in eventReferencesMap.keys) {
        final eventReferences = eventReferencesMap[url] ?? [];
        if (eventReferences.isEmpty) continue;

        final future = ref.read(
          ionConnectNetworkEntitiesProvider(
            search: search,
            eventReferences: eventReferences,
            actionSource: ActionSource.relayUrl(url),
          ).future,
        );
        futures.add(future);
      }

      final results = await Future.wait(
        futures.map(
          (future) => future
            ..catchError((Object e, StackTrace stack) {
              Logger.error('Error fetching network entities: $e, stackTrace: $stack');
              return <IonConnectEntity>[];
            }),
        ),
      );

      for (final result in results) {
        networkResults.addAll(result);
      }
    }

    Logger.log(
        'Cached results: ${cachedResults.whereType<UserMetadataEntity>().length}, Network results: ${networkResults.whereType<UserMetadataEntity>().length}');

    return [...cachedResults, ...networkResults];
  }
}
