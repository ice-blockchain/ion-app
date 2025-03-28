// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/components/avatar_picker/avatar_picker.dart';
import 'package:ion/generated/assets.gen.dart';

class ChannelAvatar extends ConsumerWidget {
  const ChannelAvatar({
    required this.channel,
    required this.editMode,
    super.key,
  });

  static double get pictureSize => 100.0.s;

  double get pictureBorderWidth => 5.0.s;

  final CommunityDefinitionData channel;
  final bool editMode;

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
        PositionedDirectional(
          top: -pictureSize * 0.4,
          child: Container(
            padding: EdgeInsets.all(pictureBorderWidth),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0.s),
            ),
            child: editMode
                ? AvatarPicker(
                    avatarUrl: channel.avatar?.url,
                  )
                : Avatar(
                    size: pictureSize - (channel.avatar?.url == null ? pictureBorderWidth * 2 : 0),
                    fit: BoxFit.fill,
                    imageUrl: channel.avatar?.url,
                    borderRadius: BorderRadius.circular(20.0.s),
                    defaultAvatar: Assets.svg.userPhotoArea.icon(
                      size: pictureSize,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
