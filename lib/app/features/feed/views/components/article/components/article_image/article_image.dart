// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/core/views/components/ion_connect_network_image.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_image/read_time_tile.dart';
import 'package:ion/app/features/feed/views/components/article/constants.dart';

class ArticleImage extends StatelessWidget {
  const ArticleImage({
    required this.authorPubkey,
    this.imageUrl,
    this.minutesToRead,
    this.minutesToReadAlignment = AlignmentDirectional.bottomEnd,
    super.key,
  });

  final String authorPubkey;

  final String? imageUrl;

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
            child: imageUrl != null
                ? IonConnectNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.fill,
                    authorPubkey: authorPubkey,
                  )
                : const ColoredBox(color: Colors.grey),
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
