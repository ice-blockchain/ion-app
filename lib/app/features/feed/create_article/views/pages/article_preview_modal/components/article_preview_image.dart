// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/components/ion_connect_network_image/ion_connect_network_image.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_image/read_time_tile.dart';
import 'package:ion/app/features/feed/views/components/article/constants.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class ArticlePreviewImage extends StatelessWidget {
  const ArticlePreviewImage({
    this.mediaFile,
    this.imageUrl,
    this.authorPubkey,
    this.minutesToRead,
    this.minutesToReadAlignment = AlignmentDirectional.bottomEnd,
    super.key,
  });

  final MediaFile? mediaFile;
  final String? imageUrl;
  final String? authorPubkey;
  final int? minutesToRead;
  final AlignmentDirectional minutesToReadAlignment;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0.s),
      child: Stack(
        alignment: minutesToReadAlignment,
        children: [
          AspectRatio(
            aspectRatio: ArticleConstants.headerImageAspectRation,
            child: (imageUrl != null && authorPubkey != null)
                ? IonConnectNetworkImage(
                    imageUrl: imageUrl!,
                    authorPubkey: authorPubkey!,
                    fit: BoxFit.cover,
                  )
                : (mediaFile != null)
                    ? Image.file(
                        File(mediaFile!.path),
                        fit: BoxFit.cover,
                      )
                    : const SizedBox.shrink(),
          ),
          if (minutesToRead != null)
            ReadTimeTile(
              alignment: minutesToReadAlignment,
              minutesToRead: minutesToRead!,
              borderRadius: 12.0.s,
            ),
        ],
      ),
    );
  }
}
