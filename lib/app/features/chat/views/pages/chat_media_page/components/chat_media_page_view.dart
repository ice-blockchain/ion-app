// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/chat_message_load_media_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/hooks/use_image_zoom.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
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
  final PrivateDirectMessageEntity entity;
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
          return _ChatMediaItem(
            media: medias[index],
            mediaAttachment:
                entity.data.visualMedias.firstWhere((e) => e.url == medias[index].remoteUrl),
            entity: entity,
            zoomController: zoomController,
            bottomHeight: bottomHeight,
          );
        },
      ),
    );
  }
}

class _ChatMediaItem extends HookConsumerWidget {
  const _ChatMediaItem({
    required this.media,
    required this.mediaAttachment,
    required this.entity,
    required this.zoomController,
    required this.bottomHeight,
  });

  final MessageMediaTableData media;
  final MediaAttachment mediaAttachment;
  final PrivateDirectMessageEntity entity;
  final ImageZoomController zoomController;
  final double bottomHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileFuture = useFuture(
      useMemoized(
        () {
          return ref.read(
            chatMessageLoadMediaProvider(
              entity: entity,
              loadThumbnail: false,
              mediaAttachment: mediaAttachment,
            ),
          );
        },
        [media.id],
      ),
    );

    if (!fileFuture.hasData) {
      return const Center(child: IONLoadingIndicator());
    }

    final path = fileFuture.data!.path;
    final isVideo = mediaAttachment.mediaType == MediaType.video;

    if (isVideo) {
      return VideoPage(
        key: ValueKey('video_${media.id}'),
        videoUrl: path,
        authorPubkey: entity.masterPubkey,
      );
    }

    return _ImagePreview(
      filePath: path,
      bottomHeight: bottomHeight,
      zoomController: zoomController,
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
