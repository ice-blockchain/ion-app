import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/utils/image.dart';
import 'package:ice/generated/assets.gen.dart';

class Avatar extends StatelessWidget {
  Avatar({
    required this.size,
    super.key,
    this.imageUrl,
    this.iceBadge = false,
    this.imageWidget,
    BorderRadiusGeometry? borderRadius,
    BoxFit? fit,
  })  : borderRadius = borderRadius ?? BorderRadius.circular(10.0.s),
        fit = fit ?? BoxFit.fitWidth,
        assert(
          imageUrl == null || imageWidget == null,
          'Either imageUrl or imageWidget must be null',
        );

  final double size;
  final BorderRadiusGeometry borderRadius;
  final BoxFit fit;
  final String? imageUrl;
  final bool iceBadge;
  final Widget? imageWidget;

  @override
  Widget build(BuildContext context) {
    if (imageWidget != null) {
      return _ImageWidgetWithBadge(
        imageWidget: imageWidget!,
        iceBadge: iceBadge,
        size: size,
      );
    } else if (imageUrl != null) {
      return _NetworkImage(
        imageUrl: imageUrl!,
        size: size,
        borderRadius: borderRadius,
        fit: fit,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _ImageWidgetWithBadge extends StatelessWidget {
  const _ImageWidgetWithBadge({
    required this.imageWidget,
    required this.iceBadge,
    required this.size,
  });

  final Widget imageWidget;
  final bool iceBadge;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        imageWidget,
        if (iceBadge) _IceBadge(size: size),
      ],
    );
  }
}

class _IceBadge extends StatelessWidget {
  const _IceBadge({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -2.0.s,
      right: -2.0.s,
      child: Column(
        children: [
          Container(
            width: 12.0.s,
            height: 12.0.s,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.5.s),
              border: Border.all(
                width: 1.0.s,
                color: context.theme.appColors.secondaryBackground,
              ),
              color: context.theme.appColors.darkBlue,
            ),
            child: Center(
              child: Assets.images.icons.iconIcelogoSecuredby.icon(
                color: context.theme.appColors.secondaryBackground,
                size: 10.0.s,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkImage extends StatelessWidget {
  const _NetworkImage({
    required this.imageUrl,
    required this.size,
    required this.borderRadius,
    required this.fit,
  });

  final String imageUrl;
  final double size;
  final BorderRadiusGeometry borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: getAdaptiveImageUrl(imageUrl, size * 2),
        width: size,
        height: size,
        fit: fit,
      ),
    );
  }
}
