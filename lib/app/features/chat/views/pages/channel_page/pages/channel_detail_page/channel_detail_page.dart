// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/channel/providers/channel_metadata_provider.c.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/pages/edit_channel_page/components/edit_channel_header.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/pages/edit_channel_page/edit_channel_page.dart';

class ChannelDetailPage extends HookConsumerWidget {
  const ChannelDetailPage({
    required this.uuid,
    super.key,
  });

  final String uuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelData = ref.watch(channelMetadataProvider(uuid)).valueOrNull;

    if (channelData == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: Column(
        children: [
          EditChannelHeader(channel: channelData),
          EditChannelForm(channel: channelData),
        ],
      ),
    );
  }
}
