import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/modal_sheets/simple_modal_sheet.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class GalleryRequestDialog extends StatelessWidget {
  const GalleryRequestDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleModalSheet.alert(
      title: context.i18n.photo_library_require_access_title,
      description: context.i18n.photo_library_require_access_description,
      iconAsset: Assets.svg.iconGalleryOpen,
      button: Row(
        mainAxisSize: MainAxisSize.min, // Изменяем на min
        children: [
          Flexible(
            child: Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(context.i18n.button_dont_allow),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ),
          SizedBox(width: 16.0.s),
          Flexible(
            child: Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(context.i18n.button_allow),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ),
        ],
      ),
    );
  }
}
