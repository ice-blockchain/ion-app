// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/messages/views/components/message_metadata/message_metadata.dart';
import 'package:ion/app/services/browser/browser.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';

part 'components/meta_data_preview.dart';

class UrlPreviewMessage extends HookWidget {
  const UrlPreviewMessage({required this.url, required this.isMe, super.key});
  final bool isMe;
  final String url;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();
    final metadata = useMemoized(() => OgpDataExtract.execute(url));
    final metadataSnapshot = useFuture(metadata);

    if (metadataSnapshot.connectionState == ConnectionState.waiting) {
      return const SizedBox.shrink();
    } else if (metadataSnapshot.hasError || metadataSnapshot.data == null) {
      return const SizedBox.shrink();
    }

    final meta = metadataSnapshot.data!;

    return GestureDetector(
      onTap: () => openUrlInAppBrowser(url),
      child: MessageItemWrapper(
        isMe: isMe,
        contentPadding: EdgeInsets.all(8.0.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              url,
              style: context.theme.appTextThemes.body2.copyWith(
                color: isMe
                    ? context.theme.appColors.onPrimaryAccent
                    : context.theme.appColors.primaryAccent,
              ),
            ),
            if (hasMetaData(meta))
              Padding(
                padding: EdgeInsets.only(top: 8.0.s),
                child: _MetaDataPreview(
                  meta: meta,
                  url: url,
                  isMe: isMe,
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool hasMetaData(OgpData meta) {
    return meta.image != null ||
        meta.title != null ||
        meta.description != null ||
        meta.siteName != null;
  }
}
