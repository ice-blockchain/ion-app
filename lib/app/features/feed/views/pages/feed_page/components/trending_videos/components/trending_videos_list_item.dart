import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/mock.dart';
import 'package:ice/app/utils/num.dart';
import 'package:ice/generated/assets.gen.dart';

class TrendingVideoListItem extends StatelessWidget {
  const TrendingVideoListItem({
    required this.video,
    required this.itemSize,
  });

  final TrendingVideo video;
  final Size itemSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: itemSize.width,
        height: itemSize.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0.s),
          image: DecorationImage(
            image: CachedNetworkImageProvider(video.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 40.0.s,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _LikesButton(likes: video.likes, onPressed: () {}),
                  _MenuButton(onPressed: () {}),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0.s),
              child: _Author(
                imageUrl: video.authorImageUrl,
                label: video.authorName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LikesButton extends StatelessWidget {
  const _LikesButton({
    required this.likes,
    required this.onPressed,
  });

  final int likes;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12.0.s),
      ),
      onPressed: onPressed,
      child: Row(
        children: <Widget>[
          ImageIcon(
            AssetImage(Assets.images.icons.iconVideoLikeOn.path),
            size: 14.0.s,
            color: context.theme.appColors.secondaryBackground,
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.0.s),
            child: Text(
              formatDoubleCompact(likes),
              style: context.theme.appTextThemes.caption3.copyWith(
                color: context.theme.appColors.secondaryBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.0.s,
      child: IconButton(
        onPressed: onPressed,
        icon: ImageIcon(
          AssetImage(Assets.images.icons.iconMorePopup.path),
          size: 16.0.s,
          color: context.theme.appColors.secondaryBackground,
        ),
      ),
    );
  }
}

class _Author extends StatelessWidget {
  const _Author({
    required this.imageUrl,
    required this.label,
  });

  final String imageUrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 20.0.s,
          height: 20.0.s,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(imageUrl),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: context.theme.appColors.secondaryBackground,
              width: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 4.0.s),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: context.theme.appTextThemes.caption3.copyWith(
                color: context.theme.appColors.secondaryBackground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
