// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/generated/assets.gen.dart';

class VideosIcon extends StatelessWidget {
  const VideosIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.0.s,
      height: 24.0.s,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.theme.appColors.primaryAccent,
        borderRadius: BorderRadius.circular(8.0.s),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(2.0.s, 1.0.s, 0, 0),
        child: Assets.svgIconVideosTrading.icon(
          color: context.theme.appColors.secondaryBackground,
        ),
      ),
    );
  }
}
