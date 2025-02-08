// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/channel/hooks/use_can_post_to_channel.dart';
import 'package:ion/app/features/chat/community/channel/views/pages/channel_page/components/empty_state_copy_link.dart';
import 'package:ion/app/features/chat/community/providers/community_join_requests_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/join_community_provider.c.dart';
import 'package:ion/app/features/chat/community/view/components/community_member_count_tile.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/providers/conversation_messages_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ChannelPage extends HookConsumerWidget {
  const ChannelPage({
    required this.uuid,
    super.key,
  });

  final String uuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channel = ref.watch(communityMetadataProvider(uuid)).valueOrNull;
    final communities = ref.watch(communityJoinRequestsProvider).valueOrNull;
    final currentPubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;

    final isJoined = useMemoized(
        () => communities?.accepted.any((community) => community.data.uuid == uuid) ?? false, [
      communities,
      uuid,
    ]);

    final messages = ref.watch(conversationMessagesProvider(uuid));

    final canPost = useCanPostToChannel(channel: channel, currentPubkey: currentPubkey);

    if (channel == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: SafeArea(
        minimum: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
        ),
        bottom: false,
        child: Column(
          children: [
            MessagingHeader(
              onTap: () => ChannelDetailRoute(uuid: uuid).push<void>(context),
              imageWidget:
                  channel.data.avatar?.url != null ? Image.network(channel.data.avatar!.url) : null,
              name: channel.data.name,
              subtitle: CommunityMemberCountTile(
                community: channel,
              ),
            ),
            Expanded(
              child: messages.when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return MessagingEmptyView(
                      title: context.i18n.common_invitation_link,
                      asset: Assets.svg.iconChatEmptystate,
                      trailing: EmptyStateCopyLink(link: channel.data.defaultInvitationLink),
                      leading: Column(
                        children: [
                          SizedBox(height: 12.0.s),
                          Text(
                            context.i18n.channel_created_message,
                            style: context.theme.appTextThemes.caption2.copyWith(
                              color: context.theme.appColors.tertararyText,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: messages.entries.length,
                      itemBuilder: (context, index) {
                        final date = messages.entries.toList()[index].key;
                        final messagesForDate = messages.entries.toList()[index].value;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0.s),
                              child: ChatDateHeaderText(date: date),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: messagesForDate.length,
                              separatorBuilder: (context, index) => SizedBox(height: 8.0.s),
                              itemBuilder: (context, msgIndex) {
                                final message = messagesForDate[msgIndex];

                                final post = ModifiablePostEntity.fromEventMessage(message);

                                return PostBody(
                                  entity: post,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                error: (error, stack) {
                  return const SizedBox.shrink();
                },
                loading: () {
                  return const SizedBox.shrink();
                },
              ),
            ),
            if (communities != null)
              if (isJoined)
                if (canPost)
                  MessagingBottomBar(
                    onSubmitted: (content) async {
                      await ref
                          .read(createPostNotifierProvider(CreatePostOption.community).notifier)
                          .create(
                            content: content ?? '',
                            communtiyId: uuid,
                            whoCanReply: WhoCanReplySettingsOption.everyone,
                          );
                    },
                  )
                else
                  ScreenSideOffset.large(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0.s),
                      child: Button(
                        mainAxisSize: MainAxisSize.max,
                        onPressed: () {},
                        label: Text(context.i18n.button_unmute),
                      ),
                    ),
                  )
              else
                ScreenSideOffset.large(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0.s),
                    child: Button(
                      mainAxisSize: MainAxisSize.max,
                      onPressed: () {
                        ref.read(joinCommunityNotifierProvider.notifier).joinCommunity(uuid);
                      },
                      label: Text(context.i18n.channel_join),
                      leadingIcon: Assets.svg.iconMenuLogout.icon(
                        color: context.theme.appColors.onPrimaryAccent,
                        size: 24.0.s,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
