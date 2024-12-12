// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class AspectRatioProvider {
  const AspectRatioProvider._(this.aspectRatio);

  factory AspectRatioProvider.fromMediaFile(MediaFile file) {
    final aspectRatio =
        file.height != null && file.width != null ? file.width! / file.height! : null;
    return AspectRatioProvider._(aspectRatio);
  }

  factory AspectRatioProvider.fromMediaAttachment(MediaAttachment mediaAttachment) {
    return AspectRatioProvider._(mediaAttachment.aspectRatio);
  }

  final double? aspectRatio;
}

/// Calculates the aspect ratio for a list of media items.
///
/// The aspect ratio is calculated by finding an average of the
/// dominant category (horizontal or vertical).
double calculatePostImageAspectRatio({required Iterable<AspectRatioProvider> ratioProviders}) {
  const minVerticalMediaAspectRatio = 0.85;
  const maxHorizontalMediaAspectRatio = 1.63;

  if (ratioProviders.isEmpty) {
    return 0;
  }

  final horizontalRatios = <double>[];
  final verticalRatios = <double>[];

  for (final AspectRatioProvider(:aspectRatio) in ratioProviders) {
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

  return ratios.reduce((a, b) => a + b) / ratios.length;
}
