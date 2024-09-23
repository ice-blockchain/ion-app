import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';

class BackgroundPicture extends ConsumerWidget {
  const BackgroundPicture({
    super.key,
  });

  double get aspectRatio => 375 / 276;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdSelectorProvider);
    final banner = ref.watch(userDataProvider(currentUserId)).valueOrNull?.banner;

    final imageWidth = MediaQuery.of(context).size.width;
    final imageHeight = imageWidth / aspectRatio;

    if (banner == null) {
      return SizedBox.shrink();
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
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
