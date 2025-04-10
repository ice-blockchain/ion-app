// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/chat_message_load_media_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/hooks/use_image_zoom.dart';
import 'package:ion/app/features/video/views/pages/video_page.dart';

class ChatMediaPageView extends HookConsumerWidget {
  const ChatMediaPageView({
    required this.medias,
    required this.entity,
    required this.bottomHeight,
    required this.initialIndex,
    required this.zoomController,
    required this.pageController,
    required this.isZoomed,
    super.key,
  });

  final List<MessageMediaTableData> medias;
  final PrivateDirectMessageData entity;
  final double bottomHeight;
  final int initialIndex;
  final ImageZoomController zoomController;
  final PageController pageController;
  final bool isZoomed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      child: PageView.builder(
        controller: pageController,
        physics: isZoomed ? const NeverScrollableScrollPhysics() : const PageScrollPhysics(),
        itemCount: medias.length,
        itemBuilder: (context, index) {
          final media = medias[index];
          final mediaAttchment = entity.visualMedias.where((e) => e.url == media.remoteUrl).first;

          final retreiveMediaFuture = ref.read(
            chatMessageLoadMediaProvider(
              entity: entity,
              loadThumbnail: false,
              mediaAttachment: mediaAttchment,
            ),
          );

          return FutureBuilder(
            future: retreiveMediaFuture,
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

              return _ImagePreview(
                zoomController: zoomController,
                filePath: snapshot.data!.path,
                bottomHeight: bottomHeight,
              );
            },
          );
        },
      ),
    );
  }
}

class _ImagePreview extends HookConsumerWidget {
  const _ImagePreview({
    required this.filePath,
    required this.bottomHeight,
    required this.zoomController,
  });

  final String filePath;
  final double bottomHeight;
  final ImageZoomController zoomController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            padding: EdgeInsetsDirectional.only(
              top: MediaQuery.paddingOf(context).top,
              bottom: bottomHeight + MediaQuery.paddingOf(context).bottom,
            ),
            child: Image.file(
              File(filePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
