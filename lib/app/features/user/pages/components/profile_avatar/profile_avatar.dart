// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';

class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({
    required this.pubkey,
    super.key,
  });

  double get pictureSize => 100.0.s;

  double get pictureBorderWidth => 5.0.s;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadataValue = ref.watch(userMetadataProvider(pubkey)).valueOrNull;

    if (userMetadataValue == null) {
      return const SizedBox.shrink();
    }

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
            child: Avatar(
              size: pictureSize - pictureBorderWidth * 2,
              fit: BoxFit.cover,
              imageUrl: userMetadataValue.data.picture,
              borderRadius: BorderRadius.circular(20.0.s),
            ),
          ),
        ),
      ],
    );
  }
}
