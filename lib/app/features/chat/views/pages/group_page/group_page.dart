// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/features/chat/providers/group_messages_provider.dart';
import 'package:ion/app/features/chat/providers/groups_provider.dart';
import 'package:ion/app/features/chat/views/components/messages_list.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/components/empty_state_copy_link.dart';
import 'package:ion/app/services/keyboard/keyboard.dart';
import 'package:ion/generated/assets.gen.dart';

class GroupPage extends ConsumerWidget {
  const GroupPage({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupsProvider.select((groups) => groups[pubkey]));
    if (group == null) {
      return const SizedBox.shrink();
    }

    final messages = ref.watch(groupMessagesProvider).emptyOrValue;

    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Scaffold(
        backgroundColor: context.theme.appColors.secondaryBackground,
        body: SafeArea(
          minimum: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
          ),
          bottom: false,
          child: Column(
            children: [
              MessagingHeader(
                onTap: () {},
                imageUrl: group.imageUrl,
                name: group.name,
                subtitle: Text(
                  context.i18n.members_count(group.members.length),
                  style: context.theme.appTextThemes.caption2.copyWith(
                    color: context.theme.appColors.quaternaryText,
                  ),
                ),
              ),
              if (messages.isEmpty)
                _EmptyState(link: group.link)
              else
                Expanded(
                  child: ChatMessagesList(
                    messages,
                    displayAuthorsIncomingMessages: true,
                  ),
                ),
              const MessagingBottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.link});

  final String link;

  @override
  Widget build(BuildContext context) {
    return MessagingEmptyView(
      title: context.i18n.common_invitation_link,
      asset: Assets.svg.iconChatEmptystate,
      trailing: EmptyStateCopyLink(link: link),
      leading: Column(
        children: [
          const ChatDateHeaderText(),
          Text(
            context.i18n.group_created_message,
            style: context.theme.appTextThemes.caption2.copyWith(
              color: context.theme.appColors.tertararyText,
            ),
          ),
        ],
      ),
    );
  }
}
