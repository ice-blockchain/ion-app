// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/num.dart';

class BottomAction extends StatelessWidget {
  const BottomAction({
    required this.onTap,
    required this.asset,
    required this.title,
    super.key,
  });

  final VoidCallback onTap;
  final String asset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
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
