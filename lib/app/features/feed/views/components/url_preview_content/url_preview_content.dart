// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/url_preview/url_preview.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';

part 'components/url_metadata_preview.dart';

class UrlPreviewContent extends HookWidget {
  const UrlPreviewContent({
    required this.url,
    super.key,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    if (Validators.isInvalidUrl(url)) {
      return const SizedBox.shrink();
    }

    final normalizedUrl = useMemoized(() => Validators.normalizeUrl(url));

    return UrlPreview(
      url: normalizedUrl,
      builder: (meta, favIconUrl) {
        if (meta == null) {
          return const SizedBox.shrink();
        }

        return Container(
          decoration: BoxDecoration(
            color: context.theme.appColors.onPrimaryAccent,
            borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
            border: Border.all(
              width: 1.0.s,
              color: context.theme.appColors.onTerararyFill,
            ),
          ),
          child: _UrlMetadataPreview(
            meta: meta,
            favIconUrl: favIconUrl,
            url: normalizedUrl,
          ),
        );
      },
    );
  }
}
