import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class TrendingVideoAuthor extends StatelessWidget {
  const TrendingVideoAuthor({
    required this.imageUrl,
    required this.label,
    super.key,
  });

  final String imageUrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.s),
      child: TextButton(
        onPressed: () {},
        child: Padding(
          padding: EdgeInsets.all(4.0.s),
          child: Row(
            children: [
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
              Flexible(
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
          ),
        ),
      ),
    );
  }
}
