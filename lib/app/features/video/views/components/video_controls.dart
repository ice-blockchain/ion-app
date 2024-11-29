// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/mute_provider.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/video/views/components/video_button.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/generated/assets.gen.dart';

class VideoControls extends HookConsumerWidget {
  const VideoControls({
    required this.videoPath,
    super.key,
  });

  final String videoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.watch(
      videoControllerProvider(
        videoPath,
        autoPlay: true,
      ),
    );

    final isMuted = ref.watch(globalMuteProvider);

    useOnInit(
      () => playerController.setVolume(isMuted ? 0 : 1),
      [isMuted],
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0.s),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          VideoButton(
            icon: isMuted
                ? Assets.svg.iconChannelMute.icon(
                    color: context.theme.appColors.secondaryBackground,
                    size: 20.0.s,
                  )
                : Assets.svg.iconChannelUnmute.icon(
                    color: context.theme.appColors.secondaryBackground,
                    size: 20.0.s,
                  ),
            onPressed: () => ref.read(globalMuteProvider.notifier).toggle(),
          ),
          SizedBox(width: 10.0.s),
          VideoButton(
            icon: Assets.svg.iconPicinpic.icon(
              color: context.theme.appColors.secondaryBackground,
              size: 20.0.s,
            ),
            onPressed: () {
              // TODO: add impl for pic in pic
            },
          ),
        ],
      ),
    );
  }
}
