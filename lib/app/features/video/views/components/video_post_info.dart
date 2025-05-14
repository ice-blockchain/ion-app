// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/mute_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/video/views/components/video_button.dart';
import 'package:ion/app/features/video/views/components/video_post_text.dart';
import 'package:ion/generated/assets.gen.dart';

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
          padding: EdgeInsetsDirectional.only(top: 6.0.s, start: 16.0.s, end: 16.0.s),
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
              UserInfo(
                pubkey: videoPost.masterPubkey,
                createdAt: videoPost.data.publishedAt.value,
                trailing: Consumer(
                  builder: (context, ref, child) {
                    final isMuted = ref.watch(globalMuteProvider);
                    return VideoButton(
                      icon: isMuted
                          ? Assets.svg.iconChannelMute.icon(
                              color: context.theme.appColors.secondaryBackground,
                              size: 20.0.s,
                            )
                          : Assets.svg.iconChannelUnmute.icon(
                              color: context.theme.appColors.secondaryBackground,
                              size: 20.0.s,
                            ),
                      onPressed: () async {
                        await ref.read(globalMuteProvider.notifier).toggle();
                      },
                    );
                  },
                ),
                textStyle: TextStyle(
                  color: context.theme.appColors.secondaryBackground,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(
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
