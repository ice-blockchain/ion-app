// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/providers/feed_videos_data_source_provider.c.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.c.dart';
import 'package:ion/app/features/video/views/hooks/use_status_bar_color.dart';
import 'package:ion/app/features/video/views/pages/video_page.dart';

class VideosPage extends HookConsumerWidget {
  const VideosPage(this.eventReference, {super.key});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useStatusBarColor();

    final dataSource = ref.watch(feedVideosDataSourceProvider(eventReference: eventReference));
    final videosData = ref.watch(entitiesPagedDataProvider(dataSource));

    final nostrEntity = ref.watch(nostrEntityProvider(eventReference: eventReference)).valueOrNull;
    if (nostrEntity is! PostEntity) {
      return Center(
        child: Text(context.i18n.video_not_found),
      );
    }

    final videosItems = videosData?.data.items?.whereType<PostEntity>().toList() ?? [];
    final videos = [nostrEntity, ...videosItems];

    final userPageController = usePageController();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: context.theme.appColors.primaryText,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: context.theme.appColors.primaryText,
        body: PageView.builder(
          controller: userPageController,
          itemCount: videos.length,
          scrollDirection: Axis.vertical,
          onPageChanged: (index) => _loadMore(ref, index, videos.length),
          itemBuilder: (_, index) => VideoPage(
            video: videos[index],
            onVideoEnded: () => userPageController.nextPage(
              duration: 300.ms,
              curve: Curves.easeInOut,
            ),
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
              ref.read(feedVideosDataSourceProvider(eventReference: eventReference)),
            ).notifier,
          )
          .fetchEntities();
    }
  }
}
