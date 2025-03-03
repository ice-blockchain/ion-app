// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message_service.c.dart';
import 'package:ion/app/features/core/views/pages/error_modal.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ShareSendButton extends HookConsumerWidget {
  const ShareSendButton({
    required this.eventReference,
    required this.pubkeys,
    super.key,
  });

  final EventReference eventReference;
  final List<String> pubkeys;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState(false);
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: 16.0.s,
          left: 44.0.s,
          right: 44.0.s,
        ),
        child: Button(
          disabled: loading.value,
          mainAxisSize: MainAxisSize.max,
          minimumSize: Size(56.0.s, 56.0.s),
          trailingIcon: loading.value
              ? const IONLoadingIndicator()
              : Assets.svg.iconButtonNext.icon(color: context.theme.appColors.onPrimaryAccent),
          label: Text(
            context.i18n.feed_send,
          ),
          onPressed: () async {
            loading.value = true;
            try {
              final service = await ref.read(sendChatMessageServiceProvider.future);
              await Future.wait(
                pubkeys.map(
                  (pubkey) => service.send(
                    receiverPubkey: pubkey,
                    content: eventReference.encode(),
                  ),
                ),
              );
              if (context.mounted) {
                context.pop();
              }
            } catch (error) {
              showErrorModal(error);
            } finally {
              loading.value = false;
            }
          },
        ),
      ),
    );
  }
}
