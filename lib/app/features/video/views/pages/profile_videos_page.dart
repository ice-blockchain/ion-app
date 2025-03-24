// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/tab_entity_type.dart';
import 'package:ion/app/features/user/providers/tab_data_source_provider.c.dart';
import 'package:ion/app/features/video/views/pages/videos_vertical_scroll_page.dart';

class ProfileVideosPage extends HookConsumerWidget {
  const ProfileVideosPage({
    required this.pubkey,
    required this.tabEntityType,
    required this.eventReference,
    this.initialMediaIndex = 0,
    super.key,
  });

  final String pubkey;
  final TabEntityType tabEntityType;
  final EventReference eventReference;
  final int initialMediaIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(tabDataSourceProvider(type: tabEntityType, pubkey: pubkey));

    return VideosVerticalScrollPage(
      eventReference: eventReference,
      initialMediaIndex: initialMediaIndex,
      getVideosData: () => ref.watch(entitiesPagedDataProvider(dataSource)),
      onLoadMore: () => ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities(),
    );
  }
}
