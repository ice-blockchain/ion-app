// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/post_repost_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reposted_events_provider.r.g.dart';

@riverpod
bool isReposted(Ref ref, EventReference eventReference) {
  final optimisticState = ref
      .watch(
        postRepostWatchProvider(eventReference.toString()),
      )
      .valueOrNull;

  if (optimisticState != null) {
    return optimisticState.repostedByMe;
  }

  final cached = ref.watch(findRepostInCacheProvider(eventReference));
  return cached != null;
}
