// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/entities/community_definition_data.c.dart';
import 'package:ion/app/features/components/avatar_picker/avatar_picker.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';

class ChannelAvatar extends ConsumerWidget {
  const ChannelAvatar({
    required this.channel,
    this.showAvatarPicker = false,
    super.key,
  });

  static double get pictureSize => 100.0.s;

  double get pictureBorderWidth => 5.0.s;

  final CommunityDefinitionData channel;
  final bool showAvatarPicker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ScreenSideOffset.small(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: (pictureSize * 0.6) + 11.0.s,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -pictureSize * 0.4,
          child: Container(
            padding: EdgeInsets.all(pictureBorderWidth),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0.s),
            ),
            child: showAvatarPicker
                ? AvatarPicker(
                    avatarWidget: _ChannelAvatar(avatar: channel.avatar),
                  )
                : Avatar(
                    size: pictureSize - pictureBorderWidth * 2,
                    fit: BoxFit.cover,
                    imageWidget: _ChannelAvatar(avatar: channel.avatar),
                    borderRadius: BorderRadius.circular(20.0.s),
                  ),
          ),
        ),
      ],
    );
  }
}

class _ChannelAvatar extends StatelessWidget {
  const _ChannelAvatar({
    required this.avatar,
  });

  final MediaAttachment? avatar;

  @override
  Widget build(BuildContext context) {
    if (avatar == null) {
      return const SizedBox.shrink();
    }

    return CachedNetworkImage(imageUrl: avatar!.url);
  }
}
