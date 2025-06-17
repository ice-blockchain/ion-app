// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum DeleteConfirmationType {
  story,
  video,
  post,
  article;

  String getTitle(BuildContext context) {
    return switch (this) {
      DeleteConfirmationType.story => context.i18n.delete_story_title,
      DeleteConfirmationType.video => context.i18n.delete_video_title,
      DeleteConfirmationType.post => context.i18n.delete_post_title,
      DeleteConfirmationType.article => context.i18n.delete_article_title,
    };
  }

  String getDesc(BuildContext context) {
    return switch (this) {
      DeleteConfirmationType.story => context.i18n.delete_story_desc,
      DeleteConfirmationType.video => context.i18n.delete_video_desc,
      DeleteConfirmationType.post => context.i18n.delete_post_desc,
      DeleteConfirmationType.article => context.i18n.delete_article_desc,
    };
  }

  String get iconAsset {
    return switch (this) {
      DeleteConfirmationType.story => Assets.svgactionCreatepostDeleterole,
      DeleteConfirmationType.video => Assets.svgactionCreatepostDeletevideo,
      DeleteConfirmationType.post => Assets.svgactionCreatepostDeletepost,
      DeleteConfirmationType.article => Assets.svgactionCreatepostDeletearticle,
    };
  }
}
