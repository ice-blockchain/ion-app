// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';
import 'package:ion/app/features/chat/providers/e2ee_group_conversation_management_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/entities/ee2e_conversation_data.c.dart';
import 'package:ion/app/features/core/views/pages/error_modal.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/keyboard/keyboard.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

const String hasPrivacyModalShownKey = 'hasPrivacyModalShownKey';

class MessagesPage extends HookConsumerWidget {
  const MessagesPage(this.conversationData, {super.key});

  final Ee2eConversationEntity conversationData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Should be called if there is no conversation messages yet in DB

    useCallback(() async {
      final ee2eGroupConversationService = ref.read(e2EEGroupConversationManagementProvider.notifier);

      if (conversationData.type == ChatType.chat) {
        await ee2eGroupConversationService.createOneOnOneConversation(conversationData.participants);
      } else if (conversationData.type == ChatType.group && conversationData.imageUrl != null) {
        await ee2eGroupConversationService.createGroup(
          subject: conversationData.name,
          groupImage: MediaFile(
            mimeType: 'image/webp',
            path: conversationData.imageUrl!,
            width: conversationData.imageWidgth,
            height: conversationData.imageHeight,
          ),
          participantsPubkeys: conversationData.participants,
        );
      }
    });

    ref.listen(
      e2EEGroupConversationManagementProvider,
      (previous, next) async {
        if (next is AsyncError) {
          await showSimpleBottomSheet<void>(
            context: context,
            child: ErrorModal(error: next.error),
          );
        }
      },
    );

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
                imageUrl: conversationData.imageUrl,
                imageWidget: conversationData.imageUrl != null && conversationData.type == ChatType.group
                    ? Image.asset(conversationData.imageUrl!)
                    : null,
                name: conversationData.name,
                subtitle: conversationData.type == ChatType.chat
                    ? Text(
                        conversationData.nickname ?? '',
                        style: context.theme.appTextThemes.caption.copyWith(
                          color: context.theme.appColors.quaternaryText,
                        ),
                      )
                    : Row(
                        children: [
                          Assets.svg.iconChannelMembers.icon(size: 10.0.s),
                          SizedBox(width: 4.0.s),
                          Text(
                            conversationData.participants.length.toString(),
                            style: context.theme.appTextThemes.caption.copyWith(
                              color: context.theme.appColors.quaternaryText,
                            ),
                          ),
                        ],
                      ),
              ),
              MessagingEmptyView(
                title: context.i18n.messaging_empty_description,
                asset: Assets.svg.walletChatEmptystate,
                trailing: GestureDetector(
                  onTap: () {
                    ChatLearnMoreModalRoute().push<void>(context);
                  },
                  child: Text(
                    context.i18n.button_learn_more,
                    style: context.theme.appTextThemes.caption.copyWith(
                      color: context.theme.appColors.primaryAccent,
                    ),
                  ),
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
