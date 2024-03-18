import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

class BottomAction extends StatelessWidget {
  const BottomAction({
    super.key,
    required this.onTap,
    required this.asset,
    required this.title,
  });

  final VoidCallback onTap;
  final AssetGenImage asset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16.0.s,
        top: 12.0.s,
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
