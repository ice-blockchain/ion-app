// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/features/feed/data/models/delete/delete_service.dart';
import 'package:ion/app/features/feed/data/models/delete/entity_delete_service.dart';
import 'package:ion/app/features/feed/data/models/delete/story_delete_service.dart';
import 'package:ion/generated/assets.gen.dart';

enum DeleteConfirmationType {
  story(StoryDeleteService()),
  video(EntityDeleteService()),
  post(EntityDeleteService()),
  article(EntityDeleteService());

  const DeleteConfirmationType(this.service);

  final DeleteService<AsyncValue<void>> service;

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
      DeleteConfirmationType.story => Assets.svg.actionCreatepostDeleterole,
      DeleteConfirmationType.video => Assets.svg.actionCreatepostDeletevideo,
      DeleteConfirmationType.post => Assets.svg.actionCreatepostDeletepost,
      DeleteConfirmationType.article => Assets.svg.actionCreatepostDeletearticle,
    };
  }
}
