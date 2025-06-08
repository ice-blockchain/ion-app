// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/channel/models/channel_detail_tab.dart';
import 'package:ion/app/features/chat/community/channel/views/components/channel_detail_app_bar.dart';
import 'package:ion/app/features/chat/community/channel/views/pages/channel_detail_page/components/channel_detail_tabs_header.dart';
import 'package:ion/app/features/chat/community/channel/views/pages/channel_detail_page/components/channel_summary.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/user/data/models/user_content_type.dart';

class ChannelDetailPage extends HookConsumerWidget {
  const ChannelDetailPage({
    required this.uuid,
    super.key,
  });

  final String uuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final channel = ref.watch(communityMetadataProvider(uuid)).valueOrNull;

    if (channel == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: ScreenTopOffset(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            DefaultTabController(
              length: UserContentType.values.length,
              child: NestedScrollView(
                controller: scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: ColoredBox(
                        color: context.theme.appColors.secondaryBackground,
                        child: ScreenSideOffset.small(
                          child: ChannelSummary(
                            channel: channel,
                          ),
                        ),
                      ),
                    ),
                    PinnedHeaderSliver(
                      child: ColoredBox(
                        color: context.theme.appColors.secondaryBackground,
                        child: SizedBox(height: 20.0.s),
                      ),
                    ),
                    PinnedHeaderSliver(
                      child: ColoredBox(
                        color: context.theme.appColors.secondaryBackground,
                        child: const ChannelDetailTabsHeader(),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: ChannelDetailTab.values
                      .map(
                        (type) => Container(),
                      )
                      .toList(),
                ),
              ),
            ),
            ChannelDetailAppBar(channel: channel.data),
          ],
        ),
      ),
    );
  }
}
