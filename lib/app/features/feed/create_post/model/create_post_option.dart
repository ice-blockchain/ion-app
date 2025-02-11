// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';

enum CreatePostOption {
  reply,
  quote,
  plain,
  story,
  video,
  modify,
  community,
  delete;

  String getTitle(BuildContext context) {
    return switch (this) {
      CreatePostOption.reply => context.i18n.button_reply,
      CreatePostOption.quote => context.i18n.feed_quote,
      CreatePostOption.plain => context.i18n.create_post_modal_title,
      CreatePostOption.video => context.i18n.create_video_new_video,
      CreatePostOption.modify => context.i18n.button_edit,
      _ => throw ArgumentError()
    };
  }

  String getPlaceholder(BuildContext context) {
    return switch (this) {
      CreatePostOption.reply => context.i18n.post_reply_hint,
      CreatePostOption.quote => context.i18n.feed_comment_hint,
      CreatePostOption.plain => context.i18n.create_post_modal_placeholder,
      CreatePostOption.video => context.i18n.create_video_input_placeholder,
      CreatePostOption.modify => '',
      _ => throw ArgumentError()
    };
  }
}
