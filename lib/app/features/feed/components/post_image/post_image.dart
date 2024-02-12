import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/components/read_time_tile/read_time_tile.dart';
import 'package:ice/utils/Image_utils.dart';

double borderRadius = 12.0.w;

class PostImage extends StatelessWidget {
  const PostImage({
    super.key,
    required this.imageUrl,
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
    final double paddingHorizontal = ScreenSideOffset.defaultSmallMargin;
    final double imageWidth =
        MediaQuery.of(context).size.width - paddingHorizontal * 2;

    final Alignment alignment = minutesToReadAlignment ?? Alignment.bottomRight;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          alignment: alignment,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: ImageUtils.getAdaptiveImageUrl(imageUrl, imageWidth),
              width: imageWidth,
              fit: BoxFit.cover,
            ),
            if (minutesToRead != null) ...<Widget>[
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 4.0.w),
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
