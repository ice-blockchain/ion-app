// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/channel/views/components/channel_detail_app_bar.dart';
import 'package:ion/app/features/chat/community/channel/views/components/channel_form.dart';
import 'package:ion/app/features/chat/community/channel/views/pages/channel_detail_page/components/channel_summary.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/update_community_provider.c.dart';

class EditChannelPage extends HookConsumerWidget {
  const EditChannelPage({
    required this.uuid,
    super.key,
  });

  final String uuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channel = ref.watch(communityMetadataProvider(uuid)).valueOrNull;

    if (channel == null) {
      return const SizedBox.shrink();
    }

    final updateCommunityNotifier = ref.watch(updateCommunityNotifierProvider);

    ref
      ..listenSuccess(updateCommunityNotifierProvider, (data) {
        context.pop();
      })
      ..displayErrors(updateCommunityNotifierProvider);

    return Scaffold(
      body: ScreenTopOffset(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ScreenSideOffset.large(
                    child: Column(
                      children: <Widget>[
                        ChannelSummary(
                          channel: channel,
                          basicMode: true,
                        ),
                      ],
                    ),
                  ),
                  ChannelForm(
                    isLoading: updateCommunityNotifier.isLoading,
                    onSubmit: (name, description, channelType) {
                      ref.read(updateCommunityNotifierProvider.notifier).updateCommunity(
                            channel.data,
                            name,
                            description,
                            channelType,
                          );
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
