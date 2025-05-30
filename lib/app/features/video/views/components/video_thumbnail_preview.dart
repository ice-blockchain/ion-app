// SPDX-License-Identifier: ice License 1.0

import 'package:blurhash_ffi/blurhash_ffi.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/features/components/ion_connect_network_image/ion_connect_network_image.dart';

class VideoThumbnailPreview extends ConsumerWidget {
  const VideoThumbnailPreview({
    required this.thumbnailUrl,
    this.blurhash,
    this.authorPubkey,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String? thumbnailUrl;
  final String? blurhash;
  final String? authorPubkey;
  final BoxFit fit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (blurhash != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          BlurhashFfi(
            hash: blurhash!,
            imageFit: fit,
          ),
          if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
            IonConnectNetworkImage(
              imageUrl: thumbnailUrl!,
              authorPubkey: authorPubkey ?? '',
              fit: fit,
            ),
        ],
      );
    }

    // If no blurhash, show thumbnail directly
    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty) {
      return IonConnectNetworkImage(
        imageUrl: thumbnailUrl!,
        authorPubkey: authorPubkey ?? '',
        fit: fit,
      );
    }

    return const CenteredLoadingIndicator();
  }
}
