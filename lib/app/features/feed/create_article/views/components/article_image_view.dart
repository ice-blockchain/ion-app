// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/views/components/feed_network_image/feed_network_image.dart';
import 'package:ion/app/services/media_service/media_service.m.dart';
import 'package:ion/generated/assets.gen.dart';

class ArticleImageView extends ConsumerWidget {
  const ArticleImageView({
    required this.selectedImage,
    required this.onClearImage,
    this.imageUrl,
    super.key,
  });

  final MediaFile? selectedImage;
  final String? imageUrl;
  final VoidCallback onClearImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPubkey = ref.watch(currentPubkeySelectorProvider);

    if (currentPubkey == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        Positioned.fill(
          child: (imageUrl != null)
              ? FeedIONConnectNetworkImage(
                  imageUrl: imageUrl!,
                  authorPubkey: currentPubkey,
                  fit: BoxFit.cover,
                )
              : selectedImage != null
                  ? Image.file(
                      File(selectedImage!.path),
                      fit: BoxFit.cover,
                    )
                  : const SizedBox.shrink(),
        ),
        PositionedDirectional(
          top: 12.0.s,
          end: 12.0.s,
          child: IconButton(
            onPressed: onClearImage,
            icon: Assets.svg.iconFieldClearall.icon(size: 20.0.s),
          ),
        ),
      ],
    );
  }
}
