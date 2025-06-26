// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/message_author.f.dart';

class MessageAuthorNameWidget extends StatelessWidget {
  const MessageAuthorNameWidget({this.author, super.key});

  final MessageAuthor? author;

  @override
  Widget build(BuildContext context) {
    return author != null && !author!.isCurrentUser
        ? Padding(
            padding: EdgeInsetsDirectional.only(bottom: 8.0.s),
            child: Text(
              author!.name,
              style: context.theme.appTextThemes.subtitle3.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
