// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';
import 'package:ion/app/services/share/share.dart';
import 'package:ion/app/utils/filesize.dart';
import 'package:ion/generated/assets.gen.dart';

class DocumentMessage extends HookConsumerWidget {
  const DocumentMessage({
    required this.eventMessage,
    super.key,
  });

  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));
    final entity = PrivateDirectMessageEntity.fromEventMessage(eventMessage);

    final filePath = useState<String>('');
    final fileSizeInFormat = useState<String?>(null);

    useOnInit(
      () {
        ref
            .read(mediaEncryptionServiceProvider)
            .retrieveEncryptedMedia(entity.data.media.values.first)
            .then(
          (encryptedMedia) {
            if (context.mounted) {
              filePath.value = encryptedMedia.path;
              fileSizeInFormat.value = formattedFileSize(filePath.value);
            }
          },
        );
      },
      [],
    );

    return MessageItemWrapper(
      isMe: isMe,
      messageEvent: eventMessage,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 12.0.s,
      ),
      child: GestureDetector(
        onTap: () {
          shareFile(filePath.value, subject: entity.data.content);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _DocumentIcon(
                        isLoading: filePath.value.isEmpty,
                      ),
                      SizedBox(
                        width: 12.0.s,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              entity.data.content,
                              style: context.theme.appTextThemes.body2.copyWith(
                                color: isMe
                                    ? context.theme.appColors.onPrimaryAccent
                                    : context.theme.appColors.primaryText,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              fileSizeInFormat.value ?? '',
                              style: context.theme.appTextThemes.caption2.copyWith(
                                color: isMe
                                    ? context.theme.appColors.onPrimaryAccent
                                    : context.theme.appColors.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  MessageReactions(
                    isMe: isMe,
                    eventMessage: eventMessage,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            MessageMetaData(
              eventMessage: eventMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentIcon extends StatelessWidget {
  const _DocumentIcon({
    required this.isLoading,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.tertararyBackground,
        borderRadius: BorderRadius.circular(12.0.s),
        border: Border.all(
          color: context.theme.appColors.onTerararyFill,
          width: 1.0.s,
        ),
      ),
      child: isLoading
          ? const IONLoadingIndicator(
              type: IndicatorType.dark,
            )
          : Assets.svg.iconFeedAddfile.icon(
              size: 20.0.s,
              color: context.theme.appColors.primaryAccent,
            ),
    );
  }
}
