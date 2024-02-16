import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/utils/image.dart';
import 'package:ice/generated/assets.gen.dart';

class StoryListItem extends StatelessWidget {
  const StoryListItem({
    super.key,
    required this.onPressed,
    required this.imageUrl,
    required this.label,
    this.showPlus = false,
  });

  final VoidCallback onPressed;
  final String imageUrl;
  final String label;
  final bool showPlus;

  static double get width => 65.0.s;
  static double get plusSize => 18.0.s;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(19.5.s),
                child: CachedNetworkImage(
                  width: width,
                  height: width,
                  imageUrl: getAdaptiveImageUrl(imageUrl, width),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: -plusSize / 2,
                child: PlusIcon(
                  size: plusSize,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(4.0.s, 8.0.s, 4.0.s, 0),
            child: Text(
              label,
              style: context.theme.appTextThemes.caption3.copyWith(
                color: context.theme.appColors.primaryText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class PlusIcon extends StatelessWidget {
  PlusIcon({
    super.key,
    double? size,
  }) : size = size ?? 18.0.s;

  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.25.s,
              color: context.theme.appColors.secondaryBackground,
            ),
            color: context.theme.appColors.primaryAccent,
            shape: BoxShape.circle,
          ),
        ),
        ImageIcon(
          size: size,
          color: context.theme.appColors.secondaryBackground,
          AssetImage(Assets.images.icons.iconPlusCreatechannel.path),
        ),
      ],
    );
  }
}
