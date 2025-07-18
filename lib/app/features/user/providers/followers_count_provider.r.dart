// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_request_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.f.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/user/model/follow_list.f.dart';
import 'package:ion/app/features/user/providers/count_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'followers_count_provider.r.g.dart';

@riverpod
FutureOr<int?> followersCount(
  Ref ref,
  String pubkey,
) async {
  final filters = [
    RequestFilter(
      kinds: const [FollowListEntity.kind],
      tags: {
        '#p': [pubkey],
      },
    ),
  ];

  return await ref.watch(
    countProvider(
      actionSource: ActionSourceUser(pubkey),
      requestData: EventCountRequestData(filters: filters),
      key: pubkey,
      type: EventCountResultType.followers,
    ).future,
  ) as FutureOr<int?>;
}
