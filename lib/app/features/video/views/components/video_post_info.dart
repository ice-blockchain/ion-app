// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/feed/views/components/user_info_menu/user_info_menu.dart';
import 'package:ion/app/features/video/views/components/video_post_text.dart';
import 'package:ion/app/utils/post_text.dart';

class VideoPostInfo extends ConsumerWidget {
  const VideoPostInfo({
    required this.videoPost,
    super.key,
  });

  final PostEntity videoPost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                context.theme.appColors.primaryText.withOpacity(1),
                context.theme.appColors.primaryText.withOpacity(0.71),
                context.theme.appColors.primaryText.withOpacity(0),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO: fix route issue, route to another route tree
              UserInfo(
                pubkey: videoPost.pubkey,
                trailing: UserInfoMenu(
                  pubkey: videoPost.pubkey,
                  iconColor: context.theme.appColors.secondaryBackground,
                ),
                textStyle: TextStyle(
                  color: context.theme.appColors.secondaryBackground,
                ),
              ),
              SizedBox(
                height: 10.0.s,
              ),
              VideoTextPost(
                text: extractPostText(videoPost.data.content),
              ),
            ],
          ),
        ),
        Container(
          height: 48.0.s,
          color: context.theme.appColors.primaryText,
        ),
      ],
    );
  }
}
