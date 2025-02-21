// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/stories/hooks/use_page_dismiss.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/fullscreen_image.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/fullscreen_video.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drag = usePageDismiss(context);

    return Hero(
      tag: 'fullscreen-media-$mediaUrl',
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
                appBar: NavigationAppBar(
                  backgroundColor: context.theme.appColors.primaryText,
                  useScreenTopOffset: true,
                  onBackPress: () => context.pop(),
                  actions: [
                    if (mediaType == MediaType.image)
                      IconButton(
                        onPressed: () {},
                        icon: Assets.svg.iconMorePopup.icon(
                          color: context.theme.appColors.onPrimaryAccent,
                        ),
                      ),
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: mediaType == MediaType.video
                                  ? FullscreenVideo(videoUrl: mediaUrl)
                                  : FullscreenImage(imageUrl: mediaUrl),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: context.theme.appColors.primaryText,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0.s,
                        vertical: 8.0.s,
                      ),
                      child: SafeArea(
                        child: CounterItemsFooter(
                          eventReference: eventReference,
                          color: context.theme.appColors.onPrimaryAccent,
                          bottomPadding: 0,
                          topPadding: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
