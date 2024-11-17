// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/replies_data_source_provider.dart';
import 'package:ion/app/features/feed/views/components/entities_list/entities_list.dart';
import 'package:ion/app/features/feed/views/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';

class ReplyList extends ConsumerWidget {
  const ReplyList({required this.eventReference, super.key});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(repliesDataSourceProvider(eventReference: eventReference));
    final entities = ref.watch(entitiesPagedDataProvider(dataSource));

    if (entities == null) {
      return const EntitiesListSkeleton();
    }

    return EntitiesList(
      entities: entities.data.items.toList(),
      separator: FeedListSeparator(height: 1.0.s),
    );
  }
}
