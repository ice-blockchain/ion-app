// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_back_button.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';

class PhotoMessagePreviewPage extends HookWidget {
  const PhotoMessagePreviewPage({
    required this.photoUrls,
    required this.message,
    required this.senderName,
    required this.sentAt,
    super.key,
  });

  final List<String> photoUrls;
  final String message;
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
          ),
        ),
        title: Text(
          '${activeIndex.value}/${photoUrls.length}',
          style: context.theme.appTextThemes.subtitle2.copyWith(
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
        actions: [
          IconButton(
            icon: Assets.svg.iconMorePopup.icon(
              size: NavigationAppBar.actionButtonSide,
              color: context.theme.appColors.onPrimaryAccent,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _ImageCarouselSlider(activeIndex: activeIndex, photoUrls: photoUrls),
          ),
          ScreenSideOffset.small(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.0.s),
                _MessageBody(message: message),
                SizedBox(height: 24.0.s),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MessageMeta(senderName: senderName, sentAt: sentAt),
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

class _MessageMeta extends StatelessWidget {
  const _MessageMeta({
    required this.senderName,
    required this.sentAt,
  });

  final String senderName;
  final DateTime sentAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          senderName,
          style: context.theme.appTextThemes.caption2.copyWith(
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
        Text(
          // sentAt.format(context),
          formatMessageTimestamp(sentAt),
          style: context.theme.appTextThemes.caption2.copyWith(
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
      ],
    );
  }
}

class _MessageBody extends StatelessWidget {
  const _MessageBody({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.onPrimaryAccent,
      ),
    );
  }
}

class _ImageCarouselSlider extends StatelessWidget {
  const _ImageCarouselSlider({
    required this.activeIndex,
    required this.photoUrls,
  });

  final ValueNotifier<int> activeIndex;
  final List<String> photoUrls;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: double.infinity,
        enableInfiniteScroll: false,
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          activeIndex.value = index + 1;
        },
      ),
      items: photoUrls.map((photoUrl) {
        return Hero(
          tag: photoUrl,
          child: CachedNetworkImage(
            imageUrl: photoUrl,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      }).toList(),
    );
  }
}
