import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({
    super.key,
    required this.asset,
    required this.title,
    this.imageSize,
  });

  final AssetGenImage asset;
  final String title;
  final double? imageSize;

  @override
  Widget build(BuildContext context) {
    final double size = imageSize ?? 48.0.s;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          asset.image(width: size, height: size),
          SizedBox(height: 8.0.s),
          Text(
            title,
            style: context.theme.appTextThemes.caption2.copyWith(
              color: context.theme.appColors.tertararyText,
            ),
          ),
        ],
      ),
    );
  }
}
