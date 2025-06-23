import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'missing_events_fetcher.c.g.dart';

class MissingEventsFetcher {
  MissingEventsFetcher({
    required this.ionConnectNotifier,
  });
  final IonConnectNotifier ionConnectNotifier;

  Future<int> fetchMissingEvents({
    required int latestEventTimestamp,
    required RequestFilter filter,
    required void Function(EventMessage event) onEvent,
  }) async {
    print('FETCHING EVENTS: latestEventTimestamp: $latestEventTimestamp');
    int? tmpLastCreatedAt;
    while (true) {
      final (maxCreatedAt, stopFetching) = await _fetchPreviousEvents(
        regularSince: tmpLastCreatedAt ?? latestEventTimestamp,
        filter: filter,
        onEvent: onEvent,
      );
      if (stopFetching) {
        break;
      }
      tmpLastCreatedAt = maxCreatedAt;
    }
    return tmpLastCreatedAt ?? latestEventTimestamp;
  }

  Future<(int maxCreatedAt, bool stopFetching)> _fetchPreviousEvents({
    required RequestFilter filter,
    required void Function(EventMessage event) onEvent,
    int? regularSince,
    int? regularUntil,
    int? previousMaxCreatedAt,
    List<String> previousRegularIds = const [],
    int page = 1,
  }) async {
    try {
      final requestMessage = RequestMessage(
        filters: [
          filter.copyWith(
            since: () => regularSince?.toMicroseconds,
            until: () => regularUntil?.toMicroseconds,
            limit: () => 100,
          ),
        ],
      );

      print('FETCHING EVENTS: filter: ${requestMessage.filters}');

      var maxCreatedAt = previousMaxCreatedAt ?? 0;
      int? minCreatedAt;
      final regularIds = <String>[];
      await for (final event in ionConnectNotifier.requestEvents(requestMessage)) {
        print(
          'FETCHING EVENTS: event: ${event.id} ${event.createdAt} date: ${DateTime.fromMicrosecondsSinceEpoch(event.createdAt)}',
        );
        final eventCreatedAt = event.createdAt.toMicroseconds;

        if (minCreatedAt == null || eventCreatedAt < minCreatedAt) {
          minCreatedAt = eventCreatedAt;
        }
        if (eventCreatedAt > maxCreatedAt) {
          maxCreatedAt = eventCreatedAt;
        }

        regularIds.add(event.id);
        if (!previousRegularIds.contains(event.id)) {
          onEvent(event);
        }
      }

      final nonDuplicateEventIds = regularIds.whereNot((id) => previousRegularIds.contains(id));

      if (nonDuplicateEventIds.isEmpty) {
        return (maxCreatedAt, page <= 2);
      }

      return _fetchPreviousEvents(
        regularSince: regularSince,
        regularUntil: minCreatedAt,
        previousMaxCreatedAt: maxCreatedAt,
        previousRegularIds: [...previousRegularIds, ...nonDuplicateEventIds],
        page: page + 1,
        filter: filter,
        onEvent: onEvent,
      );
    } catch (e) {
      throw FetchMissingEventsException(e);
    }
  }
}

@riverpod
MissingEventsFetcher missingEventsFetcher(Ref ref) {
  final ionConnectNotifier = ref.watch(ionConnectNotifierProvider.notifier);
  return MissingEventsFetcher(
    ionConnectNotifier: ionConnectNotifier,
  );
}
