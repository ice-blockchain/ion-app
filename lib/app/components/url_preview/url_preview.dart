// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/url_preview/providers/url_metadata_provider.c.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';

class UrlPreview extends HookConsumerWidget {
  const UrlPreview({
    required this.url,
    required this.builder,
    super.key,
  });

  final String url;
  final Widget Function(OgpData? meta, String favIconUrl) builder;

  String _resolveFavIconUrl(String baseUrl) {
    return '${Uri.parse(baseUrl).origin}/favicon.ico';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metadataAsync = ref.watch(urlMetadataProvider(url));
    final isLoading = useState(false);

    useEffect(
      () {
        if (!metadataAsync.isLoading) return null;
        isLoading.value = true;
        return null;
      },
      [metadataAsync.isLoading],
    );

    useEffect(
      () {
        if (metadataAsync.hasValue) {
          isLoading.value = false;
        }
        return null;
      },
      [metadataAsync.hasValue],
    );

    if (isLoading.value || metadataAsync.isLoading) {
      return const SizedBox.shrink();
    }

    return builder(metadataAsync.valueOrNull, _resolveFavIconUrl(url));
  }
}
