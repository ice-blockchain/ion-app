// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
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
    required Future<DateTime?> Function(DateTime? pivotDate) lastEventDateBuilder,
    required DateTime? newPivotDate,
    int limit = 100,
  }) async {
    final pivotDateString = ref.read(localStorageProvider).getString(state);
    final pivotDate = pivotDateString != null ? DateTime.tryParse(pivotDateString) : null;

    final lastEventDate = await lastEventDateBuilder(pivotDate);

    // If there is no pivot, fetch since the youngest event date
    final sinceDate = pivotDate ?? lastEventDate;
    final sinceDateOverlapped = sinceDate?.subtract(const Duration(seconds: 2));

    // If there is no pivot means no sync was done before, so fetch until now
    final untilDate =
        (pivotDate != null ? lastEventDate : DateTime.now())?.add(const Duration(seconds: 2));

    // If pivot is null means new sync is starting, save the last event date as pivot
    if (pivotDate == null && lastEventDate != null) {
      await ref.read(localStorageProvider).setString(state, lastEventDate.toIso8601String());
    }

    final requestMessage = RequestMessage();
    for (final filter in requestFilters) {
      requestMessage.addFilter(
        filter.copyWith(
          until: () => untilDate,
          since: () => sinceDateOverlapped,
          limit: () => limit,
        ),
      );
    }

    return _fetchEntities(
      requestMessage: requestMessage,
      saveCallback: saveCallback,
      sinceDate: sinceDate,
      newPivotDate: newPivotDate,
    );
  }

  Future<void> _fetchEntities({
    required RequestMessage requestMessage,
    required void Function(IonConnectEntity entity) saveCallback,
    required DateTime? sinceDate,
    required DateTime? newPivotDate,
  }) async {
    final entitiesStream = ref.read(ionConnectNotifierProvider.notifier).requestEntities(
          requestMessage,
        );

    DateTime? lastEventTime;
    await for (final entity in entitiesStream) {
      lastEventTime = entity.createdAt;
      if (sinceDate == null || (lastEventTime.isAfter(sinceDate))) {
        saveCallback(entity);
      } else {
        // If the entity is older than the pivot, sync is over, delete the pivot
        await ref.read(localStorageProvider).remove(state);
        return;
      }
    }

    if (lastEventTime == null) {
      // Fetched all events, sync is over, delete the pivot
      await ref.read(localStorageProvider).remove(state);
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

    return _fetchEntities(
      requestMessage: newRequestMessage,
      saveCallback: saveCallback,
      sinceDate: sinceDate,
      newPivotDate: newPivotDate,
    );
  }
}
