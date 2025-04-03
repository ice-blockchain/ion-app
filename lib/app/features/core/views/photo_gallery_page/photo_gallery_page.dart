// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/views/photo_gallery_page/components/components.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_back_button.dart';
import 'package:ion/generated/assets.gen.dart';

class PhotoGalleryPage extends HookWidget {
  const PhotoGalleryPage({
    required this.photoUrls,
    required this.title,
    required this.senderName,
    required this.sentAt,
    super.key,
  });

  final List<String> photoUrls;
  final String title;
  final String senderName;
  final DateTime sentAt;

  @override
  Widget build(BuildContext context) {
    final activeIndex = useState(1);

    return Scaffold(
      backgroundColor: context.theme.appColors.primaryText,
      appBar: NavigationAppBar.screen(
        backgroundColor: context.theme.appColors.primaryText,
        leading: NavigationBackButton(
          () {
            Navigator.of(context).pop();
          },
          icon: Assets.svg.iconChatBack.icon(
            size: NavigationAppBar.actionButtonSide,
            color: context.theme.appColors.onPrimaryAccent,
            flipForRtl: true,
          ),
        ),
        title: Text(
          '${activeIndex.value}/${photoUrls.length}',
          style: context.theme.appTextThemes.subtitle2.copyWith(
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
        actions: const [
          PhotoGalleryContextMenu(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                Center(child: PhotoGalleryCarousel(activeIndex: activeIndex, photoUrls: photoUrls)),
          ),
          ScreenSideOffset.small(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PhotoGalleryTitle(message: title),
                SizedBox(height: 24.0.s),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PhotoGalleryMeta(senderName: senderName, sentAt: sentAt),
                    Assets.svg.iconChatReplymessage.icon(
                      size: 20.0.s,
                      color: context.theme.appColors.onPrimaryAccent,
                    ),
                  ],
                ),
                ScreenBottomOffset(margin: 8.0.s),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
