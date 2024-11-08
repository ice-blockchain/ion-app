// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/url_preview_wrapper/url_preview_wrapper.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';

part 'components/meta_data_preview.dart';

class UrlPreviewMessage extends HookWidget {
  const UrlPreviewMessage({required this.url, required this.isMe, super.key});
  final bool isMe;
  final String url;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();
    return MessageItemWrapper(
      isMe: isMe,
      contentPadding: EdgeInsets.all(8.0.s),
      child: UrlPreviewWrapper(
        url: url,
        builder: (meta, favIconUrl) {
          return Column(
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
              if (meta != null)
                Padding(
                  padding: EdgeInsets.only(top: 8.0.s),
                  child: _MetaDataPreview(
                    meta: meta,
                    favIconUrl: favIconUrl,
                    url: url,
                    isMe: isMe,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
