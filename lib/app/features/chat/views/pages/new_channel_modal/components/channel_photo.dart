// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/avatar_picker/avatar_picker.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/services/media_service/media_service.dart';
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
                child: Assets.svg.backgroundCreatechannel.icon(size: constraints.maxWidth),
              ),
              AvatarPicker(
                pickMediaFile: () async {
                  final mediaFiles =
                      await ChannelPictureRoute(title: context.i18n.channel_create_add_photo)
                          .push<List<MediaFile>>(context);
                  return mediaFiles?.first;
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
