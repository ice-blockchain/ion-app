// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';

class UrlPreview extends HookWidget {
  const UrlPreview({
    required this.url,
    required this.builder,
    super.key,
  });

  static final Map<String, OgpData?> _metadataCache = {};

  final String url;
  final Widget Function(OgpData? meta, String favIconUrl) builder;

  String _resolveFavIconUrl(String baseUrl) {
    return '${Uri.parse(baseUrl).origin}/favicon.ico';
  }

  @override
  Widget build(BuildContext context) {
    final metadata = useState<OgpData?>(_metadataCache[url]);
    final isLoading = useState(false);

    useEffect(
      () {
        if (metadata.value != null) return null;

        Future<void> loadMetadata() async {
          if (_metadataCache.containsKey(url)) {
            metadata.value = _metadataCache[url];
            return;
          }

          isLoading.value = true;
          try {
            final result = await OgpDataExtract.execute(url);
            _metadataCache[url] = result;
            metadata.value = result;
          } catch (e) {
            _metadataCache[url] = null;
            metadata.value = null;
          } finally {
            isLoading.value = false;
          }
        }

        loadMetadata();
        return null;
      },
      [url],
    );

    if (isLoading.value) {
      return const SizedBox.shrink();
    }

    return builder(metadata.value, _resolveFavIconUrl(url));
  }
}
