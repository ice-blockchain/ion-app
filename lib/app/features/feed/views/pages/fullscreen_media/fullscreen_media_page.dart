// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/stories/hooks/use_page_dismiss.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/full_screen_media_body.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/fullscreen_media_context_menu.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_back_button.dart';
import 'package:ion/generated/assets.gen.dart';

class FullscreenMediaPage extends HookConsumerWidget {
  const FullscreenMediaPage({
    required this.mediaUrl,
    required this.mediaType,
    required this.eventReference,
    super.key,
  });

  final String mediaUrl;
  final MediaType mediaType;
  final EventReference eventReference;

  static String heroTagForMedia(String url) => 'fullscreen-media-$url';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drag = usePageDismiss(context);

    return Hero(
      tag: heroTagForMedia(mediaUrl),
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
                resizeToAvoidBottomInset: false,
                backgroundColor: context.theme.appColors.primaryText,
                extendBodyBehindAppBar: true,
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
                      FullscreenMediaContextMenu(pubkey: eventReference.pubkey),
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
