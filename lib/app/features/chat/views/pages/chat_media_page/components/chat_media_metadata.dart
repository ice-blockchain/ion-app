// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/date.dart';

class ChatMediaMetaData extends HookConsumerWidget {
  const ChatMediaMetaData({
    required this.eventMessage,
    super.key,
  });

  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final senderName =
        ref.watch(userMetadataProvider(eventMessage.masterPubkey)).valueOrNull?.data.displayName;

    final messageData =
        useMemoized(() => ReplaceablePrivateDirectMessageData.fromEventMessage(eventMessage));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          senderName ?? '',
          style: context.theme.appTextThemes.caption2.copyWith(
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
        Text(
          formatMessageTimestamp(messageData.publishedAt.value.toDateTime),
          style: context.theme.appTextThemes.caption2.copyWith(
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
      ],
    );
  }
}
