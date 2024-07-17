import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/languages.dart';
import 'package:ice/generated/assets.gen.dart';

class LanguageListItem extends StatelessWidget {
  const LanguageListItem({
    required this.language,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final Language language;

  final bool isSelected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ScreenSideOffset.small(
        child: Container(
          height: 44.0.s,
          decoration: BoxDecoration(
            color: context.theme.appColors.tertararyBackground,
            borderRadius: BorderRadius.circular(12.0.s),
          ),
          child: ScreenSideOffset.small(
            child: Row(
              children: [
                Text(
                  language.flag,
                  style: context.theme.appTextThemes.subtitle2.copyWith(
                    color: context.theme.appColors.primaryText,
                    fontSize: 22,
                  ),
                ),
                SizedBox(
                  width: 16.0.s,
                ),
                Expanded(
                  child: Text(
                    language.name,
                    style: context.theme.appTextThemes.subtitle2.copyWith(
                      color: context.theme.appColors.primaryText,
                    ),
                  ),
                ),
                if (isSelected)
                  Assets.images.icons.iconBlockCheckboxOn.icon()
                else
                  Assets.images.icons.iconBlockCheckboxOff.icon(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
