import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/user/model/user_data.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/utils/image.dart';

class BackgroundPicture extends HookConsumerWidget {
  const BackgroundPicture({
    super.key,
  });

  double get aspectRatio => 375 / 276;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserData userData = ref.watch(userDataNotifierProvider);
    final double imageWidth = MediaQuery.of(context).size.width;
    final double imageHeight = imageWidth / aspectRatio;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0.s),
      child: CachedNetworkImage(
        imageUrl: getAdaptiveImageUrl(userData.profilePicture, imageWidth),
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
