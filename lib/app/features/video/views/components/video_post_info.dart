// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/user_info_menu.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/video/views/components/video_post_text.dart';

class VideoPostInfo extends StatelessWidget {
  const VideoPostInfo({
    required this.videoPost,
    super.key,
  });

  final ModifiablePostEntity videoPost;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 6.0.s, left: 16.0.s, right: 16.0.s),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [0.0, 0.55, 1.0],
              colors: [
                context.theme.appColors.primaryText.withValues(alpha: 1),
                context.theme.appColors.primaryText.withValues(alpha: 0.71),
                context.theme.appColors.primaryText.withValues(alpha: 0),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO: fix route issue, route to another route tree
              UserInfo(
                pubkey: videoPost.masterPubkey,
                createdAt: videoPost.data.publishedAt.value,
                trailing: Padding(
                  padding: EdgeInsets.only(right: 6.0.s),
                  child: UserInfoMenu(
                    pubkey: videoPost.masterPubkey,
                    iconColor: context.theme.appColors.secondaryBackground,
                  ),
                ),
                textStyle: TextStyle(
                  color: context.theme.appColors.secondaryBackground,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10.0.s,
                  bottom: 14.0.s,
                ),
                child: VideoTextPost(entity: videoPost),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
