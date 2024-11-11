// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/services/browser/browser.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';

class UrlPreview extends HookWidget {
  const UrlPreview({
    required this.url,
    required this.builder,
    super.key,
  });

  final String url;
  final Widget Function(OgpData? meta, String favIconUrl) builder;

  @override
  Widget build(BuildContext context) {
    final metadata = useMemoized(() => OgpDataExtract.execute(url));
    final metadataSnapshot = useFuture(metadata);

    if (metadataSnapshot.data == null || !_hasFullMetaData(metadataSnapshot.data!)) {
      return builder(null, _resolveFavIconUrl(url));
    }

    final meta = metadataSnapshot.data!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => openUrlInAppBrowser(url),
      child: builder(
        meta,
        _resolveFavIconUrl(url),
      ),
    );
  }
}

bool _hasFullMetaData(OgpData meta) {
  return meta.image != null ||
      meta.title != null ||
      meta.description != null ||
      meta.siteName != null;
}

String _resolveFavIconUrl(String baseUrl) {
  return '${Uri.parse(baseUrl).origin}/favicon.ico';
}
