// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.f.dart';
import 'package:ion/app/features/feed/providers/ion_connect_entity_with_counters_provider.r.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/own_entity_menu.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/user_info_menu.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/video/views/components/video_actions.dart';
import 'package:ion/app/features/video/views/components/video_post_info.dart';
import 'package:ion/app/features/video/views/hooks/use_status_bar_color.dart';
import 'package:ion/app/features/video/views/hooks/use_wake_lock.dart';
import 'package:ion/app/features/video/views/pages/video_page.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_back_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ArticleVideoPage extends HookConsumerWidget {
  const ArticleVideoPage({
    required this.eventReference,
    required this.initialMediaIndex,
    this.framedEventReference,
    super.key,
  });

  final EventReference eventReference;
  final int initialMediaIndex;
  final EventReference? framedEventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useStatusBarColor();
    useWakelock();

    final appColors = context.theme.appColors;
    final primaryTextColor = appColors.primaryText;
    final onPrimaryAccentColor = appColors.onPrimaryAccent;
    final secondaryBackgroundColor = appColors.secondaryBackground;
    final rightPadding = 6.0.s;

    final articleEntity =
        ref.watch(ionConnectEntityWithCountersProvider(eventReference: eventReference));

    if (articleEntity is! ArticleEntity) {
      return const _VideoNotFound();
    }

    final allMedia = articleEntity.data.media.values.toList();
    final videos = allMedia.where((media) => media.mediaType == MediaType.video).toList();

    if (videos.isEmpty || initialMediaIndex >= allMedia.length) {
      return const _VideoNotFound();
    }

    final selectedMedia = allMedia[initialMediaIndex];
    if (selectedMedia.mediaType != MediaType.video) {
      return const _VideoNotFound();
    }

    final isOwnedByCurrentUser =
        ref.watch(isCurrentUserSelectorProvider(eventReference.masterPubkey));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: primaryTextColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        backgroundColor: primaryTextColor,
        appBar: NavigationAppBar.screen(
          backgroundColor: Colors.transparent,
          leading: NavigationBackButton(
            () => context.pop(),
            icon: Assets.svg.iconChatBack.icon(
              size: NavigationAppBar.actionButtonSide,
              color: onPrimaryAccentColor,
              flipForRtl: true,
            ),
          ),
          onBackPress: () => context.pop(),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.only(end: rightPadding),
              child: isOwnedByCurrentUser
                  ? OwnEntityMenu(
                      eventReference: eventReference,
                      iconColor: secondaryBackgroundColor,
                      onDelete: () {
                        if (context.canPop()) {
                          context.pop();
                        }
                      },
                    )
                  : UserInfoMenu(
                      eventReference: eventReference,
                      iconColor: secondaryBackgroundColor,
                    ),
            ),
          ],
        ),
        body: VideoPage(
          videoInfo: VideoPostInfo(videoPost: articleEntity),
          bottomOverlay: VideoActions(eventReference: eventReference),
          videoUrl: selectedMedia.url,
          authorPubkey: eventReference.masterPubkey,
          thumbnailUrl: selectedMedia.thumb,
          blurhash: selectedMedia.blurhash,
          aspectRatio: selectedMedia.aspectRatio,
          framedEventReference: framedEventReference,
          looping: true,
        ),
      ),
    );
  }
}

class _VideoNotFound extends StatelessWidget {
  const _VideoNotFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.i18n.video_not_found),
    );
  }
}
