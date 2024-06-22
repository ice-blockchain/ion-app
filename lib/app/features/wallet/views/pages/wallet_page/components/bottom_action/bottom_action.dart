import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/generated/assets.gen.dart';

class BottomAction extends StatelessWidget {
  const BottomAction({
    required this.onTap,
    required this.asset,
    required this.title,
    super.key,
  });

  final VoidCallback onTap;
  final AssetGenImage asset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: UiSize.medium,
        top: UiSize.small,
      ),
      child: Button(
        leadingIcon: asset.icon(),
        onPressed: onTap,
        label: Text(title),
        mainAxisSize: MainAxisSize.max,
        type: ButtonType.secondary,
      ),
    );
  }
}
