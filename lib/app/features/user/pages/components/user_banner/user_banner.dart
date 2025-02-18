// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class UserBanner extends ConsumerWidget {
  const UserBanner({
    required this.pubkey,
    this.bannerFile,
    super.key,
  });

  final String pubkey;

  final MediaFile? bannerFile;

  double get aspectRatio => 4 / 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banner =
        ref.watch(userMetadataProvider(pubkey).select((state) => state.valueOrNull?.data.banner));

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: bannerFile != null
          ? Image.file(File(bannerFile!.path))
          : banner != null
              ? CachedNetworkImage(
                  imageUrl: banner,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorWidget: (context, url, error) => const SizedBox.shrink(),
                )
              : ColoredBox(
                  color: context.theme.appColors.onSecondaryBackground,
                ),
    );
  }
}
