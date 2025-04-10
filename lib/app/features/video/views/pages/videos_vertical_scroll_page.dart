// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/feed_posts_provider.c.dart';
import 'package:ion/app/features/feed/providers/ion_connect_entity_with_counters_provider.c.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/user_info_menu.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/video/views/components/video_actions.dart';
import 'package:ion/app/features/video/views/components/video_post_info.dart';
import 'package:ion/app/features/video/views/hooks/use_status_bar_color.dart';
import 'package:ion/app/features/video/views/hooks/use_wake_lock.dart';
import 'package:ion/app/features/video/views/pages/video_page.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_back_button.dart';
import 'package:ion/generated/assets.gen.dart';

class _FlattenedVideo {
  _FlattenedVideo({required this.entity, required this.media});

  final ModifiablePostEntity entity;
  final MediaAttachment media;
}

class VideosVerticalScrollPage extends HookConsumerWidget {
  const VideosVerticalScrollPage({
    required this.eventReference,
    required this.getVideosData,
    required this.onLoadMore,
    this.initialMediaIndex = 0,
    this.framedEventReference,
    super.key,
  });

  final EventReference eventReference;
  final int initialMediaIndex;
  final EntitiesPagedDataState? Function() getVideosData;
  final void Function() onLoadMore;
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
    final animationDuration = 300.ms;

    final ionConnectEntity =
        ref.watch(ionConnectEntityWithCountersProvider(eventReference: eventReference));
    if (ionConnectEntity is! ModifiablePostEntity) {
      return Center(
        child: Text(context.i18n.video_not_found),
      );
    }

    final videosData = getVideosData();
    final filteredVideos = videosData?.data.items?.where((item) {
          final videoPost = ref.read(isVideoPostProvider(item));
          final videoRepost = ref.read(isVideoRepostProvider(item));
          return videoPost || videoRepost;
        }).toList() ??
        [];

    final entities = filteredVideos.isEmpty ? [ionConnectEntity] : filteredVideos;

    final List<_FlattenedVideo> flattenedVideos = useMemoized(
      () {
        final result = <_FlattenedVideo>[];
        for (final entity in entities) {
          if (entity is ModifiablePostEntity) {
            for (final media in entity.data.videos) {
              result.add(_FlattenedVideo(entity: entity, media: media));
            }
          } else {
            final reposted = ref.read(getRepostedEntityProvider(entity));
            if (reposted is ModifiablePostEntity) {
              for (final media in reposted.data.videos) {
                result.add(_FlattenedVideo(entity: reposted, media: media));
              }
            }
          }
        }
        return result;
      },
      [entities],
    );

    final initialPage =
        flattenedVideos.indexWhere((video) => video.entity.id == ionConnectEntity.id) +
            initialMediaIndex;

    final userPageController = usePageController(initialPage: initialPage);

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
              child: UserInfoMenu(
                eventReference: eventReference,
                iconColor: secondaryBackgroundColor,
              ),
            ),
          ],
        ),
        body: PageView.builder(
          controller: userPageController,
          itemCount: flattenedVideos.length,
          scrollDirection: Axis.vertical,
          onPageChanged: (index) => _loadMore(ref, index, flattenedVideos.length),
          itemBuilder: (_, index) => VideoPage(
            videoInfo: VideoPostInfo(videoPost: flattenedVideos[index].entity),
            bottomOverlay: VideoActions(eventReference: eventReference),
            videoUrl: flattenedVideos[index].media.url,
            framedEventReference: index == initialPage ? framedEventReference : null,
            onVideoEnded: () {
              if (index < flattenedVideos.length - 1) {
                userPageController.nextPage(
                  duration: animationDuration,
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _loadMore(WidgetRef ref, int index, int totalItems) {
    const threshold = 2;
    if (totalItems > threshold && index >= totalItems - threshold) {
      onLoadMore();
    }
  }
}
