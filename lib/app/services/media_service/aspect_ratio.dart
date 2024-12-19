// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaAspectRatio {
  const MediaAspectRatio._(this.aspectRatio);

  factory MediaAspectRatio.fromMediaFile(MediaFile file) {
    final aspectRatio =
        file.height != null && file.width != null ? file.width! / file.height! : null;
    return MediaAspectRatio._(aspectRatio);
  }

  factory MediaAspectRatio.fromAssetEntity(AssetEntity entity) {
    return MediaAspectRatio._(entity.width / entity.height);
  }

  factory MediaAspectRatio.fromMediaAttachment(MediaAttachment mediaAttachment) {
    return MediaAspectRatio._(mediaAttachment.aspectRatio);
  }

  final double? aspectRatio;
}

class MediaAspectRatioResult {
  const MediaAspectRatioResult(this.aspectRatio);

  final double aspectRatio;

  bool get isHorizontal => aspectRatio >= 1;

  bool get isVertical => aspectRatio < 1;
}

const minVerticalMediaAspectRatio = 0.85;
const maxHorizontalMediaAspectRatio = 1.63;

/// Calculates the aspect ratio for a list of media items.
///
/// The aspect ratio is calculated by finding an average of the
/// dominant category (horizontal or vertical).
MediaAspectRatioResult attachedMediaAspectRatio(Iterable<MediaAspectRatio> ratioProviders) {
  if (ratioProviders.isEmpty) {
    return const MediaAspectRatioResult(0);
  }

  final horizontalRatios = <double>[];
  final verticalRatios = <double>[];

  for (final MediaAspectRatio(:aspectRatio) in ratioProviders) {
    if (aspectRatio == null) {
      horizontalRatios.add(maxHorizontalMediaAspectRatio);
    } else if (aspectRatio >= 1) {
      horizontalRatios.add(min(maxHorizontalMediaAspectRatio, aspectRatio));
    } else if (aspectRatio < 1) {
      verticalRatios.add(max(minVerticalMediaAspectRatio, aspectRatio));
    }
  }

  final ratios =
      horizontalRatios.length > verticalRatios.length ? horizontalRatios : verticalRatios;

  final resultRatio = ratios.reduce((a, b) => a + b) / ratios.length;

  return MediaAspectRatioResult(resultRatio);
}
