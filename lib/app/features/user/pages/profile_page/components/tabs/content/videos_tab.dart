// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content/tab_entities_list.dart';
import 'package:ion/app/features/user/providers/user_videos_data_source_provider.c.dart';

class VideosTab extends ConsumerWidget {
  const VideosTab({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(userVideosDataSourceProvider(pubkey));
    return TabEntitiesList(dataSource: dataSource);
  }
}
