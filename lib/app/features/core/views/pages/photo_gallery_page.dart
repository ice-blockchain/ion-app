// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item_seperator.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_back_button.dart';
import 'package:ion/app/utils/date.dart';
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
          ),
        ),
        title: Text(
          '${activeIndex.value}/${photoUrls.length}',
          style: context.theme.appTextThemes.subtitle2.copyWith(
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
        actions: const [
          _ContextMenu(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                Center(child: _PhotoCarouselSlider(activeIndex: activeIndex, photoUrls: photoUrls)),
          ),
          ScreenSideOffset.small(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GalleryTitle(message: title),
                SizedBox(height: 24.0.s),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _PhotoMeta(senderName: senderName, sentAt: sentAt),
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

class _PhotoMeta extends StatelessWidget {
  const _PhotoMeta({
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
          formatMessageTimestamp(sentAt),
          style: context.theme.appTextThemes.caption2.copyWith(
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
      ],
    );
  }
}

class _GalleryTitle extends StatelessWidget {
  const _GalleryTitle({
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

class _PhotoCarouselSlider extends HookWidget {
  const _PhotoCarouselSlider({
    required this.activeIndex,
    required this.photoUrls,
  });

  final ValueNotifier<int> activeIndex;
  final List<String> photoUrls;

  @override
  Widget build(BuildContext context) {
    final controller = useRef(CarouselController());

    useEffect(
      () {
        controller.value.addListener(() {
          final offset = controller.value.offset;
          final screenWidth = MediaQuery.sizeOf(context).width;
          final index = (offset / screenWidth).round();
          activeIndex.value = index + 1;
        });

        return controller.value.dispose;
      },
      [],
    );

    return CarouselView(
      controller: controller.value,
      itemExtent: double.infinity,
      backgroundColor: context.theme.appColors.primaryText,
      shape: const RoundedRectangleBorder(),
      padding: EdgeInsets.zero,
      children: List.generate(photoUrls.length, (index) {
        return Hero(
          tag: photoUrls[index],
          child: CachedNetworkImage(
            imageUrl: photoUrls[index],
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      }),
    );
  }
}

class _ContextMenu extends StatelessWidget {
  const _ContextMenu();

  static double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context) {
    return OverlayMenu(
      menuBuilder: (closeMenu) => Column(
        children: [
          OverlayMenuContainer(
            child: IntrinsicWidth(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0.s),
                child: Column(
                  children: [
                    OverlayMenuItem(
                      label: context.i18n.button_share,
                      icon: Assets.svg.iconButtonShare.icon(
                        size: iconSize,
                        color: context.theme.appColors.quaternaryText,
                      ),
                      onPressed: closeMenu,
                    ),
                    const OverlayMenuItemSeperator(),
                    OverlayMenuItem(
                      label: context.i18n.button_save,
                      icon: Assets.svg.iconSecurityDownload
                          .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                      onPressed: closeMenu,
                    ),
                    const OverlayMenuItemSeperator(),
                    OverlayMenuItem(
                      label: context.i18n.button_report,
                      icon: Assets.svg.iconBlockClose3
                          .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                      onPressed: closeMenu,
                    ),
                    const OverlayMenuItemSeperator(),
                    OverlayMenuItem(
                      label: context.i18n.button_delete,
                      labelColor: context.theme.appColors.attentionRed,
                      icon: Assets.svg.iconBlockDelete
                          .icon(size: iconSize, color: context.theme.appColors.attentionRed),
                      onPressed: closeMenu,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      child: Assets.svg.iconMorePopup.icon(
        color: context.theme.appColors.onPrimaryAccent,
      ),
    );
  }
}
