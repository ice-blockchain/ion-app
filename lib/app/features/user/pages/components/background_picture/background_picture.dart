// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';

class BackgroundPicture extends ConsumerWidget {
  const BackgroundPicture({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  double get aspectRatio => 375 / 276;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banner = ref.watch(userMetadataProvider(pubkey)).valueOrNull?.banner;

    final imageWidth = MediaQuery.of(context).size.width;
    final imageHeight = imageWidth / aspectRatio;

    if (banner == null) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30.0.s),
        bottomRight: Radius.circular(30.0.s),
      ),
      child: CachedNetworkImage(
        imageUrl: banner,
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorWidget: (context, url, error) => const SizedBox.shrink(),
      ),
    );
  }
}
