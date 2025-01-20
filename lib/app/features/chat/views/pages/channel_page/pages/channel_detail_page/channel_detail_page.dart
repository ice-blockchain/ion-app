// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/channel/providers/channel_metadata_provider.c.dart';
import 'package:ion/app/features/chat/channel/views/components/channel_form.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/pages/channel_detail_page/components/channel_summary.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/pages/edit_channel_page/components/edit_channel_header.dart';

class ChannelDetailPage extends HookConsumerWidget {
  const ChannelDetailPage({
    required this.uuid,
    super.key,
  });

  final String uuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channel = ref.watch(channelMetadataProvider(uuid)).valueOrNull;

    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider).requireValue;

    final hasAccessToEdit = useMemoized(
      () =>
          (channel?.data.admins.contains(currentUserPubkey) ?? false) ||
          (channel?.data.owner == currentUserPubkey),
      [channel, currentUserPubkey],
    );

    if (channel == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: ScreenTopOffset(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ChannelSummary(channel: channel.data, hasAccessToEdit: hasAccessToEdit),
                  if (hasAccessToEdit)
                    ChannelForm(
                      channel: channel.data,
                      onSuccess: (_) {
                        ref.invalidate(channelMetadataProvider(uuid));
                        // context.pop();
                      },
                    ),
                ],
              ),
            ),
            ChannelDetailAppBar(channel: channel.data),
          ],
        ),
      ),
    );
  }
}
