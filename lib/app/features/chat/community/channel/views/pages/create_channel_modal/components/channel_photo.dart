// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/avatar_picker/avatar_picker.dart';
import 'package:ion/generated/assets.gen.dart';

class ChannelPhoto extends StatelessWidget {
  const ChannelPhoto({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 38.0.s),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = width / (302 / 187);

          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: width,
                height: height,
                child: IconAsset(Assets.svgBackgroundCreatechannel, size: constraints.maxWidth),
              ),
              AvatarPicker(
                title: context.i18n.channel_create_add_photo,
              ),
            ],
          );
        },
      ),
    );
  }
}
