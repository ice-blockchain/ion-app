// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/url_preview/url_preview.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/feed_network_image/feed_network_image.dart';
import 'package:ion/app/services/browser/browser.dart';
import 'package:ion/app/utils/url.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';

part 'components/url_metadata_preview.dart';

class UrlPreviewContent extends HookWidget {
  const UrlPreviewContent({
    required this.url,
    this.clickable = true,
    super.key,
  });

  final String url;
  final bool clickable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickable ? () => openUrlInAppBrowser(normalizeUrl(url)) : null,
      behavior: HitTestBehavior.opaque,
      child: UrlPreview(
        key: ValueKey(url),
        url: url,
        builder: (meta, favIconUrl) {
          if (meta == null || meta.title == null || meta.title!.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            decoration: BoxDecoration(
              color: context.theme.appColors.onPrimaryAccent,
              borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
              border: Border.all(
                width: 1.0.s,
                color: context.theme.appColors.onTertiaryFill,
              ),
            ),
            child: _UrlMetadataPreview(
              key: ValueKey('${url}_${meta.hashCode}'),
              meta: meta,
              url: url,
              favIconUrl: favIconUrl,
            ),
          );
        },
      ),
    );
  }
}
