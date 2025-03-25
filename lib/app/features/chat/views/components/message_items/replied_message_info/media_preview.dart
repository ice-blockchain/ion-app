import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

class MediaPreview extends HookConsumerWidget {
  const MediaPreview({required this.media, super.key});

  final MediaAttachment media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final originalImageOrThumbnail = useFuture(
      useMemoized(
        () async {
          final mediaType = MediaType.fromMimeType(media.mimeType);
          if (mediaType == MediaType.image) {
            return ref.read(mediaEncryptionServiceProvider).retrieveEncryptedMedia(media);
          } else {
            final thumbnail = media.thumb;

            if (thumbnail == null) {
              throw MediaThumbnailNotFoundException();
            }

            final mediaAttachment =
                MediaAttachment.fromJson(jsonDecode(thumbnail) as Map<String, dynamic>);
            final encryptedThumbnail = await ref
                .read(mediaEncryptionServiceProvider)
                .retrieveEncryptedMedia(mediaAttachment);

            return encryptedThumbnail;
          }
        },
        [media],
      ),
    );

    return _PhotoContent(
      isThumbnail: media.thumb != null,
      mediaPath: originalImageOrThumbnail.data?.path,
    );
  }
}

class _PhotoContent extends StatelessWidget {
  const _PhotoContent({
    required this.mediaPath,
    required this.isThumbnail,
  });

  final String? mediaPath;
  final bool isThumbnail;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 30.0.s,
        maxHeight: 30.0.s,
      ),
      child: mediaPath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0.s),
              child: Stack(
                children: [
                  Image.file(
                    File(mediaPath!),
                    fit: BoxFit.cover,
                    height: 30.0.s,
                  ),
                  if (isThumbnail)
                    Align(
                      child: Container(
                        padding: EdgeInsets.all(6.0.s),
                        decoration: BoxDecoration(
                          color: context.theme.appColors.backgroundSheet.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12.0.s),
                        ),
                        child: Assets.svg.iconVideoPlay.icon(size: 16.0.s),
                      ),
                    ),
                ],
              ),
            )
          : const CenteredLoadingIndicator(),
    );
  }
}
