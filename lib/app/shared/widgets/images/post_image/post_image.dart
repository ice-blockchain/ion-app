import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/shared/widgets/core/screen_side_offset.dart';
import 'package:ice/app/shared/widgets/tiles/read_time/read_time_tile.dart'; // Make sure this is correctly imported for your project

const double borderRadius = 12.0;

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

  String getAdaptiveImageUrl(double imageWidth) {
    return '$imageUrl?width=${imageWidth.toInt()}';
  }

  BorderRadius getOverlayBorderRadius(Alignment alignment) {
    if (alignment == Alignment.bottomRight || alignment == Alignment.topLeft) {
      return const BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        bottomRight: Radius.circular(borderRadius),
      );
    }
    if (alignment == Alignment.topRight || alignment == Alignment.bottomLeft) {
      return const BorderRadius.only(
        topRight: Radius.circular(borderRadius),
        bottomLeft: Radius.circular(borderRadius),
      );
    }
    return const BorderRadius.all(Radius.circular(borderRadius));
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHorizontal = ScreenSideOffset.offset;
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
              imageUrl: getAdaptiveImageUrl(imageWidth),
              width: imageWidth,
              fit: BoxFit.cover, // Cover the widget's bounds
            ),
            if (minutesToRead != null) ...<Widget>[
              Container(
                // Adjust the overlay margin
                padding:
                    EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 4.0.w),
                // Adjust the overlay padding
                decoration: BoxDecoration(
                  color: context.theme.appColors.tertararyBackground,
                  // Background color
                  border: Border.all(
                    color: context.theme.appColors.onTerararyFill,
                  ),
                  // Border color
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
