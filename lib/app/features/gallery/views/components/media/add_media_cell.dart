// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

class AddMediaCell extends ConsumerWidget {
  const AddMediaCell({
    required this.type,
    super.key,
  });

  final MediaPickerType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(mediaServiceProvider).presentLimitedGallery(type.toRequestType());
      },
      child: ColoredBox(
        color: context.theme.appColors.primaryBackground,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.svg.iconPostAddanswer.icon(
                color: context.theme.appColors.primaryAccent,
                size: 40.0.s,
              ),
              SizedBox(height: 2.0.s),
              Text(
                context.i18n.button_add,
                style: context.theme.appTextThemes.body.copyWith(
                  color: context.theme.appColors.primaryAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
