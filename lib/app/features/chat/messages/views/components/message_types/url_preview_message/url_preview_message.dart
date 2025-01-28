// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/url_preview/url_preview.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/features/chat/messages/views/components/message_author/message_author.dart';
import 'package:ion/app/features/chat/messages/views/components/message_reactions/message_reactions.dart';
import 'package:ion/app/features/chat/model/message_author.c.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.c.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';

part 'components/meta_data_preview.dart';

class UrlPreviewMessage extends HookWidget {
  const UrlPreviewMessage({
    required this.url,
    required this.isMe,
    required this.createdAt,
    this.author,
    this.reactions,
    this.isLastMessageFromAuthor = true,
    super.key,
  });

  final bool isMe;
  final String url;
  final DateTime createdAt;
  final MessageAuthor? author;
  final bool isLastMessageFromAuthor;
  final List<MessageReactionGroup>? reactions;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();
    return MessageItemWrapper(
      isMe: isMe,
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
                  color: isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryAccent,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MessageReactions(reactions: reactions),
                  const Spacer(),
                  MessageMetaData(isMe: isMe, createdAt: createdAt),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
