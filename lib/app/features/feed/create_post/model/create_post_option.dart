// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';

enum CreatePostOption {
  reply,
  quote,
  plain;

  String getTitle(BuildContext context) {
    return switch (this) {
      CreatePostOption.reply => context.i18n.post_reply,
      CreatePostOption.quote => context.i18n.feed_write_comment,
      CreatePostOption.plain => context.i18n.create_post_modal_title,
    };
  }

  String getPlaceholder(BuildContext context) {
    return switch (this) {
      CreatePostOption.reply => context.i18n.post_reply_hint,
      CreatePostOption.quote => context.i18n.feed_comment_hint,
      CreatePostOption.plain => context.i18n.create_post_modal_placeholder,
    };
  }
}
