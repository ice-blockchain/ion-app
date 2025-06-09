import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_syncer_provider.c.g.dart';

@riverpod
class EventSyncer extends _$EventSyncer {
  @override
  String build(String syncPivotKey) {
    return syncPivotKey;
  }

  Future<int?> syncEvents({
    required List<RequestFilter> requestFilters,
    required void Function(EventMessage eventMessage) saveCallback,
    required int? sinceDateMicroseconds,
    ActionSource actionSource = const ActionSourceCurrentUser(),
    int limit = 100,
    Duration? overlap,
  }) async {
    if (sinceDateMicroseconds != null && overlap != null) {
      sinceDateMicroseconds = sinceDateMicroseconds - overlap.inMicroseconds;
    }

    final since = await _fetchEvents(
      requestFilters,
      actionSource,
      saveCallback,
      limit,
      sinceDateMicroseconds,
      null,
    );

    return since;
  }

  Future<int?> _fetchEvents(
    List<RequestFilter> requestFilters,
    ActionSource actionSource,
    void Function(EventMessage eventMessage) saveCallback,
    int limit,
    int? since,
    int? until,
  ) async {
    final requestMessage = RequestMessage();
    for (final filter in requestFilters) {
      requestMessage.addFilter(
        filter.copyWith(
          since: () => since,
          until: () => until,
          limit: () => limit,
        ),
      );
    }

    final eventsStream = ref.read(ionConnectNotifierProvider.notifier).requestEvents(
          requestMessage,
          actionSource: actionSource,
        );

    int? newestDate;
    int? oldestDate;
    var count = 0;

    await for (final event in eventsStream) {
      print(
        '--- event: ${event.createdAt} ${event.createdAt.toDateTime.toIso8601String()} ${event.id}',
      );
      newestDate = event.createdAt;
      oldestDate ??= event.createdAt;
      count++;
      saveCallback(event);
    }

    print('--- count: $count $state');
    if (count < limit) {
      return oldestDate;
    }

    return _fetchEvents(requestFilters, actionSource, saveCallback, limit, since, newestDate);
  }
}
