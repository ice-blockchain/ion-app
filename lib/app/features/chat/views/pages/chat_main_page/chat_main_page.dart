// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/community_join_requests_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/community_messages_subscriber_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/e2ee_messages_subscriber.c.dart';
import 'package:ion/app/features/chat/providers/conversations_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_skeleton/recent_chat_skeleton.dart';
import 'package:ion/app/features/chat/recent_chats/views/pages/recent_chats_empty_page/recent_chats_empty_page.dart';
import 'package:ion/app/features/chat/recent_chats/views/pages/recent_chats_timeline_page/recent_chats_timeline_page.dart';
import 'package:ion/app/features/chat/views/pages/chat_main_page/components/chat_main_appbar/chat_main_appbar.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/features/ion_connect/providers/upload_device_keypair_notifier.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class ChatMainPage extends HookConsumerWidget {
  const ChatMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnInit(() {
      ref
        ..read(communityJoinRequestsProvider)
        ..watch(e2eeMessagesSubscriberProvider)
        ..read(communityMessagesSubscriberProvider);
    });

    final conversations = ref.watch(conversationsProvider);

    return Scaffold(
      appBar: const ChatMainAppBar(),
      body: ScreenSideOffset.small(
        child: conversations.when(
          data: (data) {
            if (data.isEmpty) {
              return const RecentChatsEmptyPage();
            }
            return RecentChatsTimelinePage(conversations: data);
          },
          error: (error, stackTrace) => const SizedBox(),
          loading: () => const RecentChatSkeleton(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
          if (identityKeyName == null) {
            return;
          }

          try {
            await guardMultiplePasskeysDialog(
              context,
              (verifyIdentity) async {
                await ref.read(uploadDeviceKeypairNotifierProvider.notifier).uploadDeviceKeypair(
                      identityKeyName: identityKeyName,
                      onVerifyIdentityForCreateKey: verifyIdentity,
                      onVerifyIdentityForDerive: verifyIdentity,
                    );
              },
              identityKeyName: identityKeyName,
              onError: (error) {
                print('Error during verification: $error');
              },
            );

            print('Device keypair upload completed successfully!');
          } catch (error) {
            print('Failed to upload device keypair: $error');
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
