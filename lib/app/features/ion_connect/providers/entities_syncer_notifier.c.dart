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

  Future<void> syncEntities({
    required List<RequestFilter> requestFilters,
    required void Function(IonConnectEntity entity) saveCallback,
    required Future<DateTime?> Function() maxCreatedAtBuilder,
    required Future<DateTime?> Function(DateTime? since) minCreatedAtBuilder,
    int limit = 100,
  }) async {
    await _completePreviousSync(
      requestFilters: requestFilters,
      saveCallback: (eventMessage) {
        final entity = _parseToEntity(eventMessage);
        saveCallback(entity);
      },
      minCreatedAtBuilder: minCreatedAtBuilder,
      maxCreatedAtBuilder: maxCreatedAtBuilder,
      limit: limit,
    );

    await _syncNewEvents(
      requestFilters: requestFilters,
      saveCallback: (eventMessage) {
        final entity = _parseToEntity(eventMessage);
        saveCallback(entity);
      },
      maxCreatedAtBuilder: maxCreatedAtBuilder,
      limit: limit,
    );
  }

  Future<void> syncEvents({
    required List<RequestFilter> requestFilters,
    required void Function(EventMessage eventMessage) saveCallback,
    required Future<DateTime?> Function() maxCreatedAtBuilder,
    required Future<DateTime?> Function(DateTime? since) minCreatedAtBuilder,
    ActionSource actionSource = const ActionSourceCurrentUser(),
    int limit = 100,
    Duration overlap = const Duration(seconds: 2),
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
    ActionSource actionSource = const ActionSourceCurrentUser(),
    int limit = 100,
    Duration overlap = const Duration(seconds: 2),
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
    ActionSource actionSource = const ActionSourceCurrentUser(),
    int limit = 100,
    Duration overlap = const Duration(seconds: 2),
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
