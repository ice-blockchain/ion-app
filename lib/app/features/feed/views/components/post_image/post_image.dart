import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/components/read_time_tile/read_time_tile.dart';
import 'package:ice/app/utils/image.dart';

double borderRadius = UiSize.medium;

class PostImage extends StatelessWidget {
  const PostImage({
    required this.imageUrl,
    super.key,
    this.minutesToRead,
    this.minutesToReadAlignment,
  });

  final String imageUrl;
  final int? minutesToRead;
  final Alignment? minutesToReadAlignment;

  BorderRadius getOverlayBorderRadius(Alignment alignment) {
    if (alignment == Alignment.bottomRight || alignment == Alignment.topLeft) {
      return BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        bottomRight: Radius.circular(borderRadius),
      );
    }
    if (alignment == Alignment.topRight || alignment == Alignment.bottomLeft) {
      return BorderRadius.only(
        topRight: Radius.circular(borderRadius),
        bottomLeft: Radius.circular(borderRadius),
      );
    }
    return BorderRadius.all(Radius.circular(borderRadius));
  }

  @override
  Widget build(BuildContext context) {
    final paddingHorizontal = ScreenSideOffset.defaultSmallMargin;
    final imageWidth =
        MediaQuery.of(context).size.width - paddingHorizontal * 2;

    final alignment = minutesToReadAlignment ?? Alignment.bottomRight;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          alignment: alignment,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: getAdaptiveImageUrl(imageUrl, imageWidth),
              width: imageWidth,
              fit: BoxFit.cover,
            ),
            if (minutesToRead != null) ...<Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: UiSize.small,
                  vertical: UiSize.xSmall,
                ),
                decoration: BoxDecoration(
                  color: context.theme.appColors.tertararyBackground,
                  border: Border.all(
                    color: context.theme.appColors.onTerararyFill,
                  ),
                  borderRadius: getOverlayBorderRadius(alignment),
                ),
                child: ReadTimeTile(
                  minutesToRead: minutesToRead!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
