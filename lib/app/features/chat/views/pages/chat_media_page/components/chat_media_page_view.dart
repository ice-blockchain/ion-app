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
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/video/views/pages/video_page.dart';
import 'package:ion/app/services/file_cache/ion_file_cache_manager.c.dart';
import 'package:ion/app/utils/url.dart';

class ChatMediaPageView extends HookConsumerWidget {
  const ChatMediaPageView({
    required this.medias,
    required this.eventReference,
    required this.initialIndex,
    required this.zoomController,
    required this.pageController,
    required this.isZoomed,
    super.key,
  });

  final List<MediaAttachment> medias;
  final EventReference eventReference;
  final int initialIndex;
  final ImageZoomController zoomController;
  final PageController pageController;
  final bool isZoomed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entityFeature = useFuture(
      useMemoized(
        () async {
          final entity = await ref.watch(eventMessageDaoProvider).getByReference(eventReference);
          return ReplaceablePrivateDirectMessageEntity.fromEventMessage(entity);
        },
        [eventReference],
      ),
    );

    if (!entityFeature.hasData) {
      return const Center(child: IONLoadingIndicator());
    }

    return Align(
      child: PageView.builder(
        controller: pageController,
        physics: isZoomed ? const NeverScrollableScrollPhysics() : const PageScrollPhysics(),
        itemCount: medias.length,
        itemBuilder: (context, index) {
          return _ChatMediaItem(
            media: medias[index],
            zoomController: zoomController,
            entity: entityFeature.data!,
          );
        },
      ),
    );
  }
}

class _ChatMediaItem extends HookConsumerWidget {
  const _ChatMediaItem({
    required this.media,
    required this.zoomController,
    required this.entity,
  });

  final MediaAttachment media;
  final ImageZoomController zoomController;
  final ReplaceablePrivateDirectMessageEntity entity;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileFuture = useFuture<String?>(
      useMemoized(
        () async {
          final isRemoteUrl = isNetworkUrl(media.url);

          if (!isRemoteUrl) {
            return media.url;
          }

          final data = await ref.read(fileCacheServiceProvider).getFileFromCache(media.url);

          if (data == null) {
            final data = await ref.read(
              chatMessageLoadMediaProvider(
                entity: entity,
                mediaAttachment: media,
                loadThumbnail: false,
              ),
            );

            return data?.path;
          }

          return data.file.path;
        },
        [media.url],
      ),
    );

    if (!fileFuture.hasData) {
      return const Center(child: IONLoadingIndicator());
    }

    final path = fileFuture.data!;

    if (media.mediaType == MediaType.video) {
      return VideoPage(
        key: ValueKey('video_${media.url}'),
        videoUrl: path,
        authorPubkey: entity.masterPubkey,
      );
    }

    return _ImagePreview(
      filePath: path,
      zoomController: zoomController,
    );
  }
}

class _ImagePreview extends HookConsumerWidget {
  const _ImagePreview({
    required this.filePath,
    required this.zoomController,
  });

  final String filePath;
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
              bottom: MediaQuery.paddingOf(context).bottom,
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
