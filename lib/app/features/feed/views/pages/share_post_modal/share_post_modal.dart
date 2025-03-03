// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message_service.c.dart';
import 'package:ion/app/features/feed/views/components/share_modal_base/share_modal_base.dart';
import 'package:ion/app/features/feed/views/pages/share_post_modal/components/share_options.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

class SharePostModal extends ConsumerWidget {
  const SharePostModal({required this.eventReference, super.key});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShareModalBase(
      title: context.i18n.feed_share_via,
      buttons: const ShareOptions(),
      onShare: (pubkeys) async {
        final service = await ref.read(sendChatMessageServiceProvider.future);
        await Future.wait(
          pubkeys.map(
            (pubkey) => service.send(receiverPubkey: pubkey, content: eventReference.encode()),
          ),
        );
        if (context.mounted) {
          context.pop();
        }
      },
    );
  }
}
