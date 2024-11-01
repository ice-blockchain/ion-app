// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/mesage_timestamp.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper.dart';
import 'package:ion/app/services/browser/browser.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';

class UrlMessage extends HookWidget {
  const UrlMessage({required this.url, required this.isMe, super.key});
  final bool isMe;
  final String url;

  @override
  Widget build(BuildContext context) {
    // Using useMemoized hook to fetch metadata only once when the widget builds
    final metadata = useMemoized(() => OgpDataExtract.execute(url));
    final metadataSnapshot = useFuture(metadata);

    if (metadataSnapshot.connectionState == ConnectionState.waiting) {
      return const SizedBox.shrink();
    } else if (metadataSnapshot.hasError || metadataSnapshot.data == null) {
      return const SizedBox.shrink();
    } else {
      // Metadata loaded successfully
      final meta = metadataSnapshot.data!;

      final uri = Uri.parse(url);
      final favIcon = '${uri.scheme}://${uri.host}/favicon.ico';

      bool isMetaAvailable() =>
          meta.image != null ||
          meta.title != null ||
          meta.description != null ||
          meta.siteName != null;

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
              if (isMetaAvailable())
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        width: 2.0.s,
                        margin: EdgeInsets.only(right: 8.0.s, top: 8.0.s),
                        // height: constraints.maxHeight,
                        decoration: BoxDecoration(
                          color: isMe
                              ? context.theme.appColors.onPrimaryAccent
                              : context.theme.appColors.primaryAccent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2.0.s),
                            bottomLeft: Radius.circular(2.0.s),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8.0.s),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0.s),
                                child: CachedNetworkImage(
                                  imageUrl: resolveImageUrl(url, meta.image!),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => const SizedBox.shrink(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0.s),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: favIcon,
                                    width: 16.0.s,
                                    height: 16.0.s,
                                    errorWidget: (context, url, error) => const SizedBox.shrink(),
                                  ),
                                  SizedBox(width: 6.0.s),
                                  Text(
                                    meta.siteName!,
                                    style: context.theme.appTextThemes.body2.copyWith(
                                      color: isMe
                                          ? context.theme.appColors.onPrimaryAccent
                                          : context.theme.appColors.primaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0.s),
                              child: Text(
                                meta.title!,
                                style: context.theme.appTextThemes.body2.copyWith(
                                  color: isMe
                                      ? context.theme.appColors.onPrimaryAccent
                                      : context.theme.appColors.primaryText,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0.s),
                              child: Text(
                                meta.description!,
                                style: context.theme.appTextThemes.body2.copyWith(
                                  color: isMe
                                      ? context.theme.appColors.onPrimaryAccent
                                      : context.theme.appColors.primaryText,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: MessageTimeStamp(isMe: isMe),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }

  String resolveImageUrl(String baseUrl, String imageUrl) {
    // Check if the imageUrl is a relative URL
    if (imageUrl.startsWith('/')) {
      // Convert to absolute URL by adding the base URL
      final baseUri = Uri.parse(baseUrl);
      return Uri.parse(baseUri.origin + imageUrl).toString();
    }
    // If the imageUrl is already an absolute URL, return it as is
    return imageUrl;
  }
}
