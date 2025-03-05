// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
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
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => const CenteredLoadingIndicator(),
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0.s),
        ColoredBox(
          color: context.theme.appColors.primaryText,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.s),
            child: SafeArea(
              top: false,
              child: CounterItemsFooter(
                eventReference: eventReference,
                color: context.theme.appColors.onPrimaryAccent,
                bottomPadding: 0,
                topPadding: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
