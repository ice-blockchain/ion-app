// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_replies_data_source_provider.g.dart';

@riverpod
List<EntitiesDataSource>? postRepliesDataSource(
  Ref ref, {
  required String postId,
  required String pubkey,
}) {
  final dataSources = [
    EntitiesDataSource(
      actionSource: ActionSourceUser(pubkey),
      entityFilter: (entity) => entity is PostEntity,
      requestFilters: [
        RequestFilter(
          kinds: const [PostEntity.kind],
          e: [postId],
          limit: 10,
        ),
      ],
    ),
  ];

  return dataSources;
}
