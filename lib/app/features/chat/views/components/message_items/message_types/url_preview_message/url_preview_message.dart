// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/image/ion_network_image.dart';
import 'package:ion/app/components/url_preview/url_preview.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/message_author.c.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_author/message_author.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/utils/url.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';

part 'components/meta_data_preview.dart';

class UrlPreviewMessage extends HookWidget {
  const UrlPreviewMessage({
    required this.url,
    required this.isMe,
    required this.createdAt,
    required this.eventMessage,
    this.author,
    this.reactions,
    this.isLastMessageFromAuthor = true,
    super.key,
  });

  final bool isMe;
  final String url;
  final DateTime createdAt;
  final MessageAuthor? author;
  final EventMessage eventMessage;
  final bool isLastMessageFromAuthor;
  final List<MessageReactionGroup>? reactions;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();
    return MessageItemWrapper(
      isMe: isMe,
      messageEvent: eventMessage,
      isLastMessageFromAuthor: isLastMessageFromAuthor,
      contentPadding: EdgeInsets.all(8.0.s),
      child: UrlPreview(
        url: url,
        builder: (meta, favIconUrl) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MessageAuthorNameWidget(author: author),
              Text(
                url,
                style: context.theme.appTextThemes.body2.copyWith(
                  color: isMe
                      ? context.theme.appColors.onPrimaryAccent
                      : context.theme.appColors.primaryAccent,
                ),
              ),
              if (meta != null)
                Padding(
                  padding: EdgeInsets.only(top: 8.0.s),
                  child: _MetaDataPreview(
                    meta: meta,
                    favIconUrl: favIconUrl,
                    url: url,
                    isMe: isMe,
                  ),
                ),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //MessageReactions(reactions: reactions),
                  Spacer(),
                  //TODO: add metadata
                  // MessageMetaData(isMe: isMe, createdAt: createdAt),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
