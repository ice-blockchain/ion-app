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
    final channelData = ref.watch(channelMetadataProvider(uuid));

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          channelData.when(
            data: (channel) => EditChannelForm(channel: channel),
            error: (error, stackTrace) => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
          ),
          const Positioned(
            child: EditChannelHeader(),
          ),
        ],
      ),
    );

    // return channelData.when(
    //   data: (channel) {
    //     return Column(
    //       children: [
    //         Text(channel.name),
    //       ],
    //     );
    //   },
    //   error: (error, stackTrace) {
    //     return const SizedBox.shrink();
    //   },
    //   loading: () {
    //     return const SizedBox.shrink();
    //   },
    // );
  }
}
