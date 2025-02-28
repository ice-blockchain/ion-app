// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/stories/hooks/use_page_dismiss.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/user_info_menu.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/full_screen_media_body.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_back_button.dart';
import 'package:ion/generated/assets.gen.dart';

class FullscreenMediaPage extends HookConsumerWidget {
  const FullscreenMediaPage({
    required this.mediaUrl,
    required this.mediaType,
    required this.heroTag,
    required this.eventReference,
    super.key,
  });

  final String mediaUrl;
  final MediaType mediaType;
  final String heroTag;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drag = usePageDismiss(context);

    return Hero(
      tag: heroTag,
      child: Material(
        color: Colors.transparent,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: context.theme.appColors.primaryText,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: GestureDetector(
            onVerticalDragUpdate: drag.onDragUpdate,
            onVerticalDragEnd: drag.onDragEnd,
            child: Transform.translate(
              offset: Offset(0, drag.offset),
              child: Scaffold(
                backgroundColor: context.theme.appColors.primaryText,
                extendBodyBehindAppBar: mediaType != MediaType.image,
                appBar: NavigationAppBar.screen(
                  backgroundColor: Colors.transparent,
                  leading: NavigationBackButton(
                    () => context.pop(),
                    icon: Assets.svg.iconChatBack.icon(
                      size: NavigationAppBar.actionButtonSide,
                      color: context.theme.appColors.onPrimaryAccent,
                    ),
                  ),
                  onBackPress: () => context.pop(),
                  actions: [
                    if (mediaType == MediaType.image)
                      Padding(
                        padding: EdgeInsets.only(right: 6.0.s),
                        child: UserInfoMenu(
                          pubkey: eventReference.pubkey,
                          iconColor: context.theme.appColors.secondaryBackground,
                        ),
                      ),
                  ],
                ),
                body: FullScreenMediaBody(
                  mediaUrl: mediaUrl,
                  mediaType: mediaType,
                  eventReference: eventReference,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
