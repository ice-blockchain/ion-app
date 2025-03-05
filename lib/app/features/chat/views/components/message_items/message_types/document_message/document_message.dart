// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entites/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:mime/mime.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
    final fileSize = useState<String>('');
    final fileData = useFuture(
      useMemoized(
        () async {
          final encryptedMedia = await ref
              .read(mediaEncryptionServiceProvider)
              .retreiveEncryptedMedia(entity.data.media.values.toList());

          return encryptedMedia.first.path;
        },
        [],
      ),
    );

    useEffect(
      () {
        if (fileData.data != null) {
          filePath.value = fileData.data!;
          fileSize.value =
              '${(File(filePath.value).lengthSync() / (1024 * 1024)).toStringAsFixed(1)} MB';
        }
        return null;
      },
      [fileData.data],
    );

    return MessageItemWrapper(
      isMe: isMe,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 12.0.s,
      ),
      child: VisibilityDetector(
        key: ValueKey(eventMessage.id),
        onVisibilityChanged: (info) {},
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
                      _DownloadButton(
                        onPressed: () {
                          Share.shareXFiles(
                            [
                              XFile.fromData(
                                File(filePath.value).readAsBytesSync(),
                                mimeType: lookupMimeType(entity.data.content),
                                name: entity.data.content,
                              ),
                            ],
                            subject: entity.data.content,
                          );
                        },
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
                              fileSize.value,
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

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8.0.s),
        decoration: BoxDecoration(
          color: context.theme.appColors.tertararyBackground,
          borderRadius: BorderRadius.circular(12.0.s),
          border: Border.all(
            color: context.theme.appColors.onTerararyFill,
            width: 1.0.s,
          ),
        ),
        child: Assets.svg.iconSecurityDownload.icon(
          size: 20.0.s,
          color: context.theme.appColors.primaryAccent,
        ),
      ),
    );
  }
}
