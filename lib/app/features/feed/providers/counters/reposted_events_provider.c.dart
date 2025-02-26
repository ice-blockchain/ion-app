// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/counters/reposted_events_notifier.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reposted_events_provider.c.g.dart';

@Riverpod(keepAlive: true)
Stream<Map<EventReference, EventReference>> repostedEvents(Ref ref) async* {
  yield ref.watch(repostedEventsNotifierProvider);

  ref.listen(repostedEventsNotifierProvider, (previous, next) {});
}

@riverpod
bool isReposted(Ref ref, EventReference eventReference) {
  return ref.watch(repostReferenceProvider(eventReference)) != null;
}

@riverpod
EventReference? repostReference(Ref ref, EventReference eventReference) {
  final repostedMap = ref.watch(repostedEventsProvider).valueOrNull;
  return repostedMap?[eventReference];
}
