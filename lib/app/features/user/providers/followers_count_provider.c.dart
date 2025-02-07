// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:ion/app/features/user/providers/count_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'followers_count_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<int> followersCount(
  Ref ref, {
  required String pubkey,
  required EventCountResultType type,
}) async {
  final filters = [
    RequestFilter(
      kinds: const [FollowListEntity.kind],
      tags: {
        '#p': [pubkey],
      },
    ),
  ];

  return ref.watch(
    countProvider(
      pubkey: pubkey,
      type: type,
      filters: filters,
    ).future,
  );
}
