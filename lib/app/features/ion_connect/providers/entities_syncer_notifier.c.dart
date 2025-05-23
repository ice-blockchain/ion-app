// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entities_syncer_notifier.c.g.dart';

@riverpod
class EntitiesSyncerNotifier extends _$EntitiesSyncerNotifier {
  @override
  String build(String syncPivotKey) => syncPivotKey;

  /// IonConnectEntity version of syncEvents.
  /// Proceed there for more detailed explanation of this method.
  Future<void> syncEntities({
    required List<RequestFilter> requestFilters,
    required void Function(IonConnectEntity entity) saveCallback,
    required Future<DateTime?> Function() maxCreatedAtBuilder,
    required Future<DateTime?> Function(DateTime? since) minCreatedAtBuilder,
    ActionSource actionSource = const ActionSourceCurrentUser(),
    int limit = 100,
    Duration overlap = const Duration(microseconds: 2),
  }) async {
    await _completePreviousSync(
      requestFilters: requestFilters,
      saveCallback: (eventMessage) {
        final entity = _parseToEntity(eventMessage);
        saveCallback(entity);
      },
      minCreatedAtBuilder: minCreatedAtBuilder,
      maxCreatedAtBuilder: maxCreatedAtBuilder,
      actionSource: actionSource,
      limit: limit,
      overlap: overlap,
    );

    await _syncNewEvents(
      requestFilters: requestFilters,
      saveCallback: (eventMessage) {
        final entity = _parseToEntity(eventMessage);
        saveCallback(entity);
      },
      maxCreatedAtBuilder: maxCreatedAtBuilder,
      actionSource: actionSource,
      limit: limit,
      overlap: overlap,
    );
  }

  /// Synchronizes raw event messages in two stages: previous sync completion and new events sync.
  ///
  /// This method ensures no events are missed by overlapping sync ranges and tracking a persistent
  /// pivot timestamp (stored using the provided sync key). The pivot marks the latest successfully
  /// synced event time and is updated after each stage.
  ///
  /// Step-by-step:
  /// 1. Loads the pivot timestamp from local storage.
  /// 2. Tries running a "previous sync completion" in case the synchronization failed the last time,
  /// causing it to fill the messages gap between the saved pivot and the last fetched event during the previous, interrupted sync.
  /// 3. Runs a "new events sync" stage to fetch fresh events created after the last stored event.
  /// 4. Updates the pivot timestamp using the youngest event's createdAt date
  Future<void> syncEvents({
    required List<RequestFilter> requestFilters,
    required void Function(EventMessage eventMessage) saveCallback,
    required Future<DateTime?> Function() maxCreatedAtBuilder,
    required Future<DateTime?> Function(DateTime? since) minCreatedAtBuilder,
    ActionSource actionSource = const ActionSourceCurrentUser(),
    int limit = 100,
    Duration overlap = const Duration(microseconds: 2),
  }) async {
    await _completePreviousSync(
      requestFilters: requestFilters,
      saveCallback: saveCallback,
      minCreatedAtBuilder: minCreatedAtBuilder,
      maxCreatedAtBuilder: maxCreatedAtBuilder,
      actionSource: actionSource,
      limit: limit,
      overlap: overlap,
    );

    await _syncNewEvents(
      requestFilters: requestFilters,
      saveCallback: saveCallback,
      maxCreatedAtBuilder: maxCreatedAtBuilder,
      actionSource: actionSource,
      limit: limit,
      overlap: overlap,
    );
  }

  Future<void> _completePreviousSync({
    required List<RequestFilter> requestFilters,
    required void Function(EventMessage eventMessage) saveCallback,
    required Future<DateTime?> Function(DateTime? since) minCreatedAtBuilder,
    required Future<DateTime?> Function() maxCreatedAtBuilder,
    required ActionSource actionSource,
    required int limit,
    required Duration overlap,
  }) async {
    final pivotDateString = ref.read(localStorageProvider).getString(state);
    final pivotDate = pivotDateString != null ? DateTime.tryParse(pivotDateString) : null;

    final minCreatedAt = await minCreatedAtBuilder(pivotDate);
    if (minCreatedAt == null) {
      // No events to sync before, save new pivot
      final maxCreatedAt = await maxCreatedAtBuilder();
      if (maxCreatedAt != null) {
        await ref.read(localStorageProvider).setString(state, maxCreatedAt.toIso8601String());
      }
      return;
    }

    final untilDateOverlapped = minCreatedAt.add(overlap);
    final pivotDateOverlapped = pivotDate?.subtract(overlap);

    final requestMessage = RequestMessage();
    for (final filter in requestFilters) {
      requestMessage.addFilter(
        filter.copyWith(
          until: () => untilDateOverlapped,
          since: () => pivotDateOverlapped,
          limit: () => limit,
        ),
      );
    }

    await _fetchEvents(
      requestMessage: requestMessage,
      saveCallback: saveCallback,
      sinceDate: pivotDate,
      limit: limit,
      actionSource: actionSource,
    );

    // Sync complete, save new pivot date
    final maxCreatedAt = await maxCreatedAtBuilder();
    if (maxCreatedAt != null) {
      await ref.read(localStorageProvider).setString(state, maxCreatedAt.toIso8601String());
    }
  }

  Future<void> _syncNewEvents({
    required List<RequestFilter> requestFilters,
    required void Function(EventMessage eventMessage) saveCallback,
    required Future<DateTime?> Function() maxCreatedAtBuilder,
    required ActionSource actionSource,
    required int limit,
    required Duration overlap,
  }) async {
    final pivotDateString = ref.read(localStorageProvider).getString(state);
    final pivotDate = pivotDateString != null ? DateTime.tryParse(pivotDateString) : null;

    final sinceDate = pivotDate;
    final sinceDateOverlapped = sinceDate?.subtract(overlap);

    final untilDateOverlapped = DateTime.now().add(overlap);

    final requestMessage = RequestMessage();
    for (final filter in requestFilters) {
      requestMessage.addFilter(
        filter.copyWith(
          until: () => untilDateOverlapped,
          since: () => sinceDateOverlapped,
          limit: () => limit,
        ),
      );
    }

    await _fetchEvents(
      requestMessage: requestMessage,
      saveCallback: saveCallback,
      sinceDate: sinceDate,
      limit: limit,
      actionSource: actionSource,
    );

    // Sync complete, save new pivot date
    final maxCreatedAt = await maxCreatedAtBuilder();
    if (maxCreatedAt != null) {
      await ref.read(localStorageProvider).setString(state, maxCreatedAt.toIso8601String());
    }
  }

  Future<void> _fetchEvents({
    required RequestMessage requestMessage,
    required void Function(EventMessage eventMessage) saveCallback,
    required DateTime? sinceDate,
    required int limit,
    required ActionSource actionSource,
  }) async {
    final eventsStream = ref.read(ionConnectNotifierProvider.notifier).requestEvents(
          requestMessage,
          actionSource: actionSource,
        );

    DateTime? lastEventTime;
    var count = 0;
    await for (final event in eventsStream) {
      lastEventTime = event.createdAt;
      if (sinceDate == null || (lastEventTime.isAfter(sinceDate))) {
        count++;
        saveCallback(event);
      }
    }

    if (lastEventTime == null || count < limit) {
      // No more events to sync, return
      return;
    }

    final newRequestMessage = RequestMessage();
    for (final filter in requestMessage.filters) {
      newRequestMessage.addFilter(
        filter.copyWith(
          until: () => lastEventTime,
        ),
      );
    }

    return _fetchEvents(
      requestMessage: newRequestMessage,
      saveCallback: saveCallback,
      sinceDate: sinceDate,
      limit: limit,
      actionSource: actionSource,
    );
  }

  IonConnectEntity _parseToEntity(EventMessage event) {
    final parser = ref.read(eventParserProvider);
    return parser.parse(event);
  }
}
