// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/feed_trending_videos_data_source_provider.c.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/user_info_menu.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/video/views/hooks/use_status_bar_color.dart';
import 'package:ion/app/features/video/views/pages/video_page.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_back_button.dart';
import 'package:ion/generated/assets.gen.dart';

class VideosPage extends HookConsumerWidget {
  const VideosPage(this.eventReference, {super.key});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useStatusBarColor();

    final appColors = context.theme.appColors;
    final primaryTextColor = appColors.primaryText;
    final onPrimaryAccentColor = appColors.onPrimaryAccent;
    final secondaryBackgroundColor = appColors.secondaryBackground;
    final rightPadding = 6.0.s;
    final animationDuration = 300.ms;

    final ionConnectEntity =
        ref.watch(ionConnectEntityProvider(eventReference: eventReference)).valueOrNull;
    if (ionConnectEntity is! ModifiablePostEntity) {
      return Center(
        child: Text(context.i18n.video_not_found),
      );
    }

    final dataSource = ref.watch(feedTrendingVideosDataSourceProvider);
    final videosData = ref.watch(entitiesPagedDataProvider(dataSource));
    final trendingVideos =
        videosData?.data.items?.whereType<ModifiablePostEntity>().toList() ?? [];

    final videos = trendingVideos.isEmpty ? [ionConnectEntity] : trendingVideos;

    final initialPage = trendingVideos.indexWhere((video) => video.id == ionConnectEntity.id);
    final startPage = initialPage >= 0 ? initialPage : 0;

    final userPageController = usePageController(initialPage: startPage);

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
            ),
          ),
          onBackPress: () => context.pop(),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: rightPadding),
              child: UserInfoMenu(
                pubkey: eventReference.pubkey,
                iconColor: secondaryBackgroundColor,
              ),
            ),
          ],
        ),
        body: PageView.builder(
          controller: userPageController,
          itemCount: videos.length,
          scrollDirection: Axis.vertical,
          onPageChanged: (index) => _loadMore(ref, index, videos.length),
          itemBuilder: (_, index) => VideoPage(
            eventReference: videos[index].toEventReference(),
            video: videos[index],
            onVideoEnded: () {
              if (index < videos.length - 1) {
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
      ref
          .read(
            entitiesPagedDataProvider(
              ref.read(feedTrendingVideosDataSourceProvider),
            ).notifier,
          )
          .fetchEntities();
    }
  }
}
