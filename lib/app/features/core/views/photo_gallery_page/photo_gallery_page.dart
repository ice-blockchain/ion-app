// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/chat_medias_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/views/photo_gallery_page/components/components.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/hooks/use_image_zoom.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/providers/image_zoom_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/features/video/views/hooks/use_status_bar_color.dart';
import 'package:ion/app/features/video/views/pages/video_page.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_back_button.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

class PhotoGalleryPage extends HookConsumerWidget {
  const PhotoGalleryPage({
    required this.eventMessageId,
    required this.initialIndex,
    super.key,
  });

  final String eventMessageId;
  final int initialIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = useState(1);
    final eventMessageFuture = useFuture(
      useMemoized(
        () => ref.watch(eventMessageDaoProvider).getById(eventMessageId),
        [eventMessageId],
      ),
    );

    useStatusBarColor();
    final pageController = usePageController(initialPage: initialIndex);

    final zoomController = useImageZoom(ref, withReset: true);
    final currentPage = useState(initialIndex);

    useEffect(
      () {
        void listener() {
          if (pageController.hasClients && pageController.page != null) {
            final newPage = pageController.page!.round();
            if (newPage != currentPage.value) {
              currentPage.value = newPage;
              zoomController.resetZoom?.call();
            }
          }
        }

        pageController.addListener(listener);

        return () {
          if (pageController.hasClients) {
            pageController.removeListener(listener);
          }
        };
      },
      [pageController, zoomController],
    );

    final isZoomed = ref.watch(imageZoomProvider);

    final messageDetailsKey = useRef(GlobalKey());
    final bottomHeight = useState<double>(0);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final context = messageDetailsKey.value.currentContext;
          if (context != null) {
            final box = context.findRenderObject() as RenderBox?;
            if (box != null) {
              bottomHeight.value = box.size.height;
            }
          }
        });
        return null;
      },
      [messageDetailsKey.value.currentContext],
    );

    if (!eventMessageFuture.hasData) {
      return const SizedBox.shrink();
    }
    final eventMessage = eventMessageFuture.data!;
    final entity = PrivateDirectMessageData.fromEventMessage(eventMessage);

    final medias = ref.watch(chatMediasProvider(eventMessageId: eventMessageId)).valueOrNull;

    if (medias == null) {
      return const SizedBox.shrink();
    }

    final senderName =
        ref.watch(userMetadataProvider(eventMessage.masterPubkey)).valueOrNull?.data.displayName ??
            '';

    return Material(
      color: context.theme.appColors.primaryText,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: context.theme.appColors.primaryText,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: context.theme.appColors.primaryText,
          extendBodyBehindAppBar: true,
          appBar: NavigationAppBar.screen(
            backgroundColor: Colors.transparent,
            leading: NavigationBackButton(
              () => context.pop(),
              icon: Assets.svg.iconChatBack.icon(
                size: NavigationAppBar.actionButtonSide,
                color: context.theme.appColors.onPrimaryAccent,
                flipForRtl: true,
              ),
            ),
            onBackPress: () => context.pop(),
            actions: const [
              PhotoGalleryContextMenu(),
            ],
            title: Text(
              '${activeIndex.value}/${medias.length}',
              style: context.theme.appTextThemes.subtitle2.copyWith(
                color: context.theme.appColors.onPrimaryAccent,
              ),
            ),
          ),
          body: Stack(
            children: [
              Align(
                child: PageView.builder(
                  onPageChanged: (index) {
                    activeIndex.value = index + 1;
                  },
                  controller: pageController,
                  physics:
                      isZoomed ? const NeverScrollableScrollPhysics() : const PageScrollPhysics(),
                  itemCount: medias.length,
                  itemBuilder: (context, index) {
                    final media = medias[index];
                    final mediaAttchment =
                        entity.visualMedias.where((e) => e.url == media.remoteUrl).first;
                    // final urlFeature = ref.read(
                    //   chatMessageLoadMediaProvider(
                    //     entity: entity,
                    //     mediaAttachment: mediaAttchment,
                    //     loadThumbnail: false,
                    //   ),
                    // );

                    final urlFeature = ref
                        .read(
                          mediaEncryptionServiceProvider,
                        )
                        .retrieveEncryptedMedia(mediaAttchment);

                    return FutureBuilder(
                      future: urlFeature,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: IONLoadingIndicator(),
                          );
                        }
                        final isVideo = mediaAttchment.mediaType == MediaType.video;

                        if (isVideo) {
                          return VideoPage(
                            key: ValueKey('video_${media.id}'),
                            videoUrl: snapshot.data!.path,
                          );
                        }

                        return ColoredBox(
                          color: Colors.transparent,
                          child: GestureDetector(
                            onDoubleTapDown: zoomController.onDoubleTapDown,
                            onDoubleTap: zoomController.onDoubleTap,
                            child: InteractiveViewer(
                              transformationController: zoomController.transformationController,
                              maxScale: 6.0.s,
                              clipBehavior: Clip.none,
                              onInteractionStart: zoomController.onInteractionStart,
                              onInteractionUpdate: zoomController.onInteractionUpdate,
                              onInteractionEnd: zoomController.onInteractionEnd,
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top,
                                  bottom:
                                      bottomHeight.value + MediaQuery.of(context).padding.bottom,
                                ),
                                child: Image.file(
                                  File(snapshot.data!.path),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom,
                left: 0,
                right: 0,
                child: ScreenSideOffset.small(
                  key: messageDetailsKey.value,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.s),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (eventMessage.content.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 24.0.s),
                            child: Text(
                              eventMessage.content,
                              style: context.theme.appTextThemes.body2.copyWith(
                                color: context.theme.appColors.onPrimaryAccent,
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PhotoGalleryMeta(
                              senderName: senderName,
                              sentAt: eventMessage.createdAt,
                            ),
                            Assets.svg.iconChatReplymessage.icon(
                              size: 20.0.s,
                              color: context.theme.appColors.onPrimaryAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return Scaffold(
    //   backgroundColor: context.theme.appColors.primaryText,
    //   appBar: NavigationAppBar.screen(
    //     backgroundColor: context.theme.appColors.primaryText,
    //     leading: NavigationBackButton(
    //       () {
    //         Navigator.of(context).pop();
    //       },
    //       icon: Assets.svg.iconChatBack.icon(
    //         size: NavigationAppBar.actionButtonSide,
    //         color: context.theme.appColors.onPrimaryAccent,
    //         flipForRtl: true,
    //       ),
    //     ),
    //     title: Text(
    //       '${activeIndex.value}/${medias.length}',
    //       style: context.theme.appTextThemes.subtitle2.copyWith(
    //         color: context.theme.appColors.onPrimaryAccent,
    //       ),
    //     ),
    //     actions: const [
    //       PhotoGalleryContextMenu(),
    //     ],
    //   ),
    //   body: Column(
    //     children: [
    //       Expanded(
    //         child: Center(
    //           child: ImageCarousel(
    //             images: entity.visualMedias,
    //             initialIndex: activeIndex.value,
    //             eventReference: null,
    //           ),
    //         ),
    //       ),
    //       ScreenSideOffset.small(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             PhotoGalleryTitle(message: eventMessage.content),
    //             SizedBox(height: 24.0.s),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 PhotoGalleryMeta(senderName: senderName, sentAt: eventMessage.createdAt),
    //                 Assets.svg.iconChatReplymessage.icon(
    //                   size: 20.0.s,
    //                   color: context.theme.appColors.onPrimaryAccent,
    //                 ),
    //               ],
    //             ),
    //             ScreenBottomOffset(margin: 8.0.s),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
