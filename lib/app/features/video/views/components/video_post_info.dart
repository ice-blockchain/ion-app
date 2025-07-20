// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/mute_provider.r.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/video/views/components/video_button.dart';
import 'package:ion/app/features/video/views/components/video_post_text.dart';
import 'package:ion/generated/assets.gen.dart';

class VideoPostInfo extends StatelessWidget {
  const VideoPostInfo({
    required this.videoPost,
    super.key,
  });

  final IonConnectEntity videoPost;

  @override
  Widget build(BuildContext context) {
    final publishedAt = switch (videoPost) {
      final ModifiablePostEntity post => post.data.publishedAt.value,
      _ => videoPost.createdAt,
    };

    return Column(
      children: [
        Container(
          padding: EdgeInsetsDirectional.only(top: 6.0.s, start: 16.0.s, end: 16.0.s),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.5497, 0.9],
              colors: [
                Colors.black.withValues(alpha: 0),
                Colors.black.withValues(alpha: 0.71),
                Colors.black.withValues(alpha: 1),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfo(
                pubkey: videoPost.masterPubkey,
                createdAt: publishedAt,
                trailing: Consumer(
                  builder: (context, ref, child) {
                    final isMuted = ref.watch(globalMuteNotifierProvider);
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
                        await ref.read(globalMuteNotifierProvider.notifier).toggle();
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
