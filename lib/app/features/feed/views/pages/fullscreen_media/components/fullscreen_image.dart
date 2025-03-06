// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

class FullscreenImage extends StatelessWidget {
  const FullscreenImage({
    required this.imageUrl,
    required this.eventReference,
    super.key,
  });

  final String imageUrl;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: MediaQuery.sizeOf(context).width,
          fit: BoxFit.fitWidth,
          placeholder: (context, url) => const CenteredLoadingIndicator(),
        ),
      ),
    );
  }
}
