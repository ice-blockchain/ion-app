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
List<IonConnectEntity> ionConnectCachedEntities(
  Ref ref, {
  required List<EventReference> eventReferences,
}) =>
    eventReferences
        .map(
          (eventReference) => ref.watch(
            ionConnectCacheProvider.select(
              cacheSelector(CacheableEntity.cacheKeyBuilder(eventReference: eventReference)),
            ),
          ),
        )
        .nonNulls
        .toList();

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
  if (eventReferences.isEmpty) {
    return <IonConnectEntity>[];
  }

  final immutableRefs = eventReferences.whereType<ImmutableEventReference>().toList();
  final replaceableRefs = eventReferences.whereType<ReplaceableEventReference>().toList();

  final results = <IonConnectEntity>[];

  if (immutableRefs.isNotEmpty) {
    final requestMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          search: search,
          ids: immutableRefs.map((e) => e.eventId).toList(),
        ),
      );
    final entitiesStream = ref.read(ionConnectNotifierProvider.notifier).requestEntities(
          requestMessage,
          actionSource: actionSource,
        );
    final entities = await entitiesStream.toList();
    results.addAll(entities);
  }

  if (replaceableRefs.isNotEmpty) {
    final filters = replaceableRefs
        .map(
          (replaceableEventRef) => RequestFilter(
            kinds: [replaceableEventRef.kind],
            authors: [replaceableEventRef.masterPubkey],
            tags: {
              if (replaceableEventRef.dTag.isNotEmpty) '#d': [replaceableEventRef.dTag],
            },
            search: search,
          ),
        )
        .toList();

    final requestMessage = RequestMessage()..filters.addAll(filters);

    final entityStream = ref.read(ionConnectNotifierProvider.notifier).requestEntities(
          requestMessage,
          actionSource: actionSource,
        );
    final entityList = <IonConnectEntity>[];
    await for (final entity in entityStream.handleError(
      (Object error) {
        Logger.error('Error fetching entities for $actionSource: $error');
      },
      test: (_) => true,
    )) {
      entityList.add(entity);
    }

    results.addAll(entityList);
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
Future<List<IonConnectEntity>> ionConnectEntities(
  Ref ref, {
  required List<EventReference> eventReferences,
  String? search,
  bool cache = true,
  bool network = true,
}) async {
  final cachedResults = <IonConnectEntity>[];
  final networkResults = <IonConnectEntity>[];

  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    throw const CurrentUserNotFoundException();
  }
  if (cache) {
    cachedResults.addAll(
      ref.watch(ionConnectCachedEntitiesProvider(eventReferences: eventReferences)),
    );
  }
  if (network) {
    final notCachedEvents = eventReferences.toSet().difference(cachedResults.toSet());

    final relaysMap = await ref.watch(usersRelaysProvider.notifier).fetch(
          strategy: UsersRelaysStrategy.mostUsers,
          masterPubkeys: notCachedEvents.map((e) => e.masterPubkey).toList(),
        );

    final eventReferencesMap = relaysMap.map(
      (url, masterPubkeys) => MapEntry(
        url,
        notCachedEvents.where((e) => masterPubkeys.contains(e.masterPubkey)).toList(),
      ),
    );

    for (final url in eventReferencesMap.keys) {
      final eventReferences = eventReferencesMap[url] ?? [];
      if (eventReferences.isEmpty) continue;

      final result = await ref.watch(
        ionConnectNetworkEntitiesProvider(
          search: search,
          eventReferences: eventReferences,
          actionSource: ActionSource.relayUrl(url),
        ).future,
      );

      networkResults.addAll(result);
    }
  }
  return [...cachedResults, ...networkResults];
}
